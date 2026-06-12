<?php
// api/controllers/ModuloController.php — VERSIÓN FINAL
// Actualiza asignaciones basado en el puesto del profesor

class ModuloController {
    public function __construct(private PDO $db) {}

    private function cursoActivoId(): int {
        $stmt = $this->db->query("SELECT id FROM curso_escolar WHERE activo = 1 LIMIT 1");
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        if (!$row) throw new Exception('No hay curso activo');
        return (int)$row['id'];
    }

    public function index(): void {
        try {
            $cursoId = $this->cursoActivoId();
            $stmt = $this->db->prepare("SELECT * FROM modulo WHERE curso_id = ? ORDER BY nombre");
            $stmt->execute([$cursoId]);
            echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['error' => $e->getMessage()]);
        }
    }

    public function show(int $id): void {
        try {
            $stmt = $this->db->prepare("SELECT * FROM modulo WHERE id = ?");
            $stmt->execute([$id]);
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            if (!$row) {
                http_response_code(404);
                echo json_encode(['error' => 'Módulo no encontrado']);
                return;
            }
            echo json_encode($row);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['error' => $e->getMessage()]);
        }
    }

    // GET /modulos/{id}/grupos — grupos a los que pertenece el módulo
    public function grupos(int $id): void {
        try {
            $stmt = $this->db->prepare(
                "SELECT g.id, g.nombre, g.ciclo, g.curso, g.modalidad
                 FROM grupo_modulo gm
                 JOIN grupo g ON gm.grupo_id = g.id
                 WHERE gm.modulo_id = ?
                 ORDER BY g.ciclo, g.curso, g.nombre"
            );
            $stmt->execute([$id]);
            echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['error' => $e->getMessage()]);
        }
    }

    // Sincroniza la relación grupo_modulo con los grupos seleccionados.
    // No quita un grupo si tiene asignaciones activas con este módulo.
    private function sincronizarGrupos(int $moduloId, array $gruposIds): void {
        $gruposIds = array_map('intval', $gruposIds);

        $stmt = $this->db->prepare("SELECT grupo_id FROM grupo_modulo WHERE modulo_id = ?");
        $stmt->execute([$moduloId]);
        $actuales = array_map('intval', array_column($stmt->fetchAll(PDO::FETCH_ASSOC), 'grupo_id'));

        // Quitar los desmarcados (solo si no tienen asignaciones)
        foreach ($actuales as $gid) {
            if (!in_array($gid, $gruposIds, true)) {
                $chk = $this->db->prepare(
                    "SELECT COUNT(*) FROM asignacion WHERE grupo_id = ? AND modulo_id = ?"
                );
                $chk->execute([$gid, $moduloId]);
                if ($chk->fetchColumn() == 0) {
                    $this->db->prepare(
                        "DELETE FROM grupo_modulo WHERE grupo_id = ? AND modulo_id = ?"
                    )->execute([$gid, $moduloId]);
                }
            }
        }

        // Añadir los nuevos
        $ins = $this->db->prepare(
            "INSERT IGNORE INTO grupo_modulo (grupo_id, modulo_id) VALUES (?, ?)"
        );
        foreach ($gruposIds as $gid) {
            $ins->execute([$gid, $moduloId]);
        }
    }

    public function store(array $data): void {
        try {
            if (empty($data['nombre'])) {
                http_response_code(422);
                echo json_encode(['error' => "Campo 'nombre' obligatorio"]);
                return;
            }

            $cursoId = $this->cursoActivoId();

            $this->db->beginTransaction();
            $stmt = $this->db->prepare(
                "INSERT INTO modulo (curso_id, nombre, codigo, horas_pes, horas_ptfp)
                 VALUES (?, ?, ?, ?, ?)"
            );
            $stmt->execute([
                $cursoId,
                trim($data['nombre']),
                $data['codigo'] ?? null,
                $data['horas_pes'] ?? 0,
                $data['horas_ptfp'] ?? 0
            ]);
            $moduloId = (int)$this->db->lastInsertId();

            // Vincular a los grupos seleccionados
            if (!empty($data['grupos_ids']) && is_array($data['grupos_ids'])) {
                $this->sincronizarGrupos($moduloId, $data['grupos_ids']);
            }
            $this->db->commit();

            http_response_code(201);
            echo json_encode(['id' => $moduloId, 'mensaje' => 'Módulo creado']);
        } catch (Exception $e) {
            if ($this->db->inTransaction()) $this->db->rollBack();
            http_response_code(500);
            echo json_encode(['error' => $e->getMessage()]);
        }
    }

    public function update(int $id, array $data): void {
        try {
            $cursoId = $this->cursoActivoId();

            $nuevasPes = (float)($data['horas_pes'] ?? 0);
            $nuevasPtfp = (float)($data['horas_ptfp'] ?? 0);

            $this->db->beginTransaction();

            // ========== 1. ACTUALIZAR MÓDULO ==========
            $stmt = $this->db->prepare(
                "UPDATE modulo SET nombre=?, codigo=?, horas_pes=?, horas_ptfp=?
                 WHERE id=? AND curso_id=?"
            );
            $stmt->execute([
                trim($data['nombre']),
                $data['codigo'] ?? null,
                $nuevasPes,
                $nuevasPtfp,
                $id,
                $cursoId
            ]);

            if ($stmt->rowCount() === 0) {
                $this->db->rollBack();
                http_response_code(404);
                echo json_encode(['error' => 'Módulo no encontrado en curso activo']);
                return;
            }

            // ========== 2. SINCRONIZAR GRUPOS ==========
            if (isset($data['grupos_ids']) && is_array($data['grupos_ids'])) {
                $this->sincronizarGrupos($id, $data['grupos_ids']);
            }

            // ========== 3. ACTUALIZAR ASIGNACIONES (según puesto del profesor) ==========
            
            // Para profesores PES
            $stmtPes = $this->db->prepare(
                "UPDATE asignacion a
                 JOIN profesor p ON a.profesor_id = p.id
                 SET a.horas = ?
                 WHERE a.modulo_id = ? AND a.curso_id = ? AND p.puesto = 'PES'"
            );
            $stmtPes->execute([$nuevasPes, $id, $cursoId]);

            // Para profesores PTFP
            $stmtPtfp = $this->db->prepare(
                "UPDATE asignacion a
                 JOIN profesor p ON a.profesor_id = p.id
                 SET a.horas = ?
                 WHERE a.modulo_id = ? AND a.curso_id = ? AND p.puesto = 'PTFP'"
            );
            $stmtPtfp->execute([$nuevasPtfp, $id, $cursoId]);

            $this->db->commit();

            echo json_encode([
                'mensaje' => 'Módulo actualizado',
                'detalles' => [
                    'horas_pes' => $nuevasPes,
                    'horas_ptfp' => $nuevasPtfp,
                    'asignaciones_pes_actualizadas' => $stmtPes->rowCount(),
                    'asignaciones_ptfp_actualizadas' => $stmtPtfp->rowCount()
                ]
            ]);
        } catch (Exception $e) {
            if ($this->db->inTransaction()) $this->db->rollBack();
            http_response_code(500);
            echo json_encode(['error' => $e->getMessage()]);
        }
    }

    public function destroy(int $id): void {
        try {
            $check = $this->db->prepare("SELECT COUNT(*) as cnt FROM asignacion WHERE modulo_id = ?");
            $check->execute([$id]);
            if ($check->fetch(PDO::FETCH_ASSOC)['cnt'] > 0) {
                http_response_code(409);
                echo json_encode(['error' => 'Módulo tiene asignaciones activas']);
                return;
            }
            $stmt = $this->db->prepare("DELETE FROM modulo WHERE id = ?");
            $stmt->execute([$id]);
            echo json_encode(['mensaje' => 'Módulo eliminado']);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['error' => $e->getMessage()]);
        }
    }
}
