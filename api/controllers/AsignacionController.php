<?php
// api/controllers/AsignacionController.php — VERSIÓN CORREGIDA
// Las horas se toman del módulo según el puesto del profesor

class AsignacionController {
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
            $stmt = $this->db->prepare(
                "SELECT a.id,
                        CONCAT(p.apellidos, ', ', p.nombre) AS profesor,
                        p.puesto,
                        m.nombre AS modulo,
                        m.codigo,
                        g.nombre AS grupo,
                        g.ciclo,
                        a.horas,
                        a.es_desdoble,
                        a.observaciones,
                        a.profesor_id,
                        a.modulo_id,
                        a.grupo_id
                 FROM asignacion a
                 JOIN profesor p ON a.profesor_id = p.id
                 JOIN modulo m ON a.modulo_id = m.id
                 JOIN grupo g ON a.grupo_id = g.id
                 WHERE a.curso_id = ?
                 ORDER BY p.apellidos, m.nombre"
            );
            $stmt->execute([$cursoId]);
            echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['error' => $e->getMessage()]);
        }
    }

    public function show(int $id): void {
        try {
            $stmt = $this->db->prepare(
                "SELECT a.id,
                        CONCAT(p.apellidos, ', ', p.nombre) AS profesor,
                        p.puesto,
                        m.nombre AS modulo,
                        m.codigo,
                        g.nombre AS grupo,
                        a.horas,
                        a.es_desdoble,
                        a.observaciones,
                        a.profesor_id,
                        a.modulo_id,
                        a.grupo_id
                 FROM asignacion a
                 JOIN profesor p ON a.profesor_id = p.id
                 JOIN modulo m ON a.modulo_id = m.id
                 JOIN grupo g ON a.grupo_id = g.id
                 WHERE a.id = ?"
            );
            $stmt->execute([$id]);
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            if (!$row) {
                http_response_code(404);
                echo json_encode(['error' => 'Asignación no encontrada']);
                return;
            }
            echo json_encode($row);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['error' => $e->getMessage()]);
        }
    }

    public function store(array $data): void {
        try {
            // Validar campos
            foreach (['profesor_id', 'modulo_id', 'grupo_id'] as $f) {
                if (!isset($data[$f]) || $data[$f] === '') {
                    http_response_code(422);
                    echo json_encode(['error' => "Campo '$f' obligatorio"]);
                    return;
                }
            }

            $cursoId = $this->cursoActivoId();

            // Verificar duplicado
            $check = $this->db->prepare(
                "SELECT COUNT(*) as cnt FROM asignacion
                 WHERE curso_id=? AND profesor_id=? AND modulo_id=? AND grupo_id=?"
            );
            $check->execute([$cursoId, (int)$data['profesor_id'], (int)$data['modulo_id'], (int)$data['grupo_id']]);
            if ($check->fetch(PDO::FETCH_ASSOC)['cnt'] > 0) {
                http_response_code(409);
                echo json_encode(['error' => 'Asignación duplicada']);
                return;
            }

            // Las horas de un módulo no se reparten: el mismo módulo+grupo
            // solo puede tener otro profesor si la nueva asignación es un desdoble
            $esDesdoble = isset($data['es_desdoble']) ? (int)$data['es_desdoble'] : 0;
            if (!$esDesdoble) {
                $chk = $this->db->prepare(
                    "SELECT COUNT(*) as cnt FROM asignacion
                     WHERE curso_id=? AND modulo_id=? AND grupo_id=?"
                );
                $chk->execute([$cursoId, (int)$data['modulo_id'], (int)$data['grupo_id']]);
                if ($chk->fetch(PDO::FETCH_ASSOC)['cnt'] > 0) {
                    http_response_code(409);
                    echo json_encode(['error' => 'Este módulo ya está asignado a otro profesor en este grupo. Márcalo como desdoble si imparten el grupo en paralelo.']);
                    return;
                }
            }

            // ========== OBTENER PUESTO DEL PROFESOR ==========
            $profStmt = $this->db->prepare("SELECT puesto FROM profesor WHERE id = ?");
            $profStmt->execute([(int)$data['profesor_id']]);
            $profesor = $profStmt->fetch(PDO::FETCH_ASSOC);
            if (!$profesor) {
                http_response_code(404);
                echo json_encode(['error' => 'Profesor no encontrado']);
                return;
            }

            // ========== OBTENER HORAS DEL MÓDULO (según puesto) ==========
            $modStmt = $this->db->prepare("SELECT horas_pes, horas_ptfp FROM modulo WHERE id = ?");
            $modStmt->execute([(int)$data['modulo_id']]);
            $modulo = $modStmt->fetch(PDO::FETCH_ASSOC);
            if (!$modulo) {
                http_response_code(404);
                echo json_encode(['error' => 'Módulo no encontrado']);
                return;
            }

            // Seleccionar horas según puesto del profesor
            $horas = $profesor['puesto'] === 'PES' ? $modulo['horas_pes'] : $modulo['horas_ptfp'];

            // ========== CREAR ASIGNACIÓN ==========
            $stmt = $this->db->prepare(
                "INSERT INTO asignacion (curso_id, profesor_id, modulo_id, grupo_id, horas, es_desdoble, observaciones)
                 VALUES (?, ?, ?, ?, ?, ?, ?)"
            );
            $stmt->execute([
                $cursoId,
                (int)$data['profesor_id'],
                (int)$data['modulo_id'],
                (int)$data['grupo_id'],
                (float)$horas,
                $esDesdoble,
                $data['observaciones'] ?? null
            ]);

            http_response_code(201);
            echo json_encode([
                'id' => $this->db->lastInsertId(),
                'mensaje' => 'Asignación creada',
                'detalles' => [
                    'horas' => $horas,
                    'puesto_profesor' => $profesor['puesto'],
                    'nota' => 'Las horas se toman automáticamente del módulo'
                ]
            ]);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['error' => $e->getMessage()]);
        }
    }

    public function update(int $id, array $data): void {
        try {
            // Las horas que envíe el cliente se ignoran: se recalculan
            // siempre a partir del módulo y del puesto del profesor.

            // Obtener asignación actual
            $current = $this->db->prepare("SELECT * FROM asignacion WHERE id = ?");
            $current->execute([$id]);
            $row = $current->fetch(PDO::FETCH_ASSOC);
            if (!$row) {
                http_response_code(404);
                echo json_encode(['error' => 'Asignación no encontrada']);
                return;
            }

            // Verificar duplicado (excluir la actual)
            $cursoId = $this->cursoActivoId();
            $check = $this->db->prepare(
                "SELECT COUNT(*) as cnt FROM asignacion
                 WHERE curso_id=? AND profesor_id=? AND modulo_id=? AND grupo_id=? AND id!=?"
            );
            $check->execute([
                $cursoId,
                (int)$data['profesor_id'],
                (int)$data['modulo_id'],
                (int)$data['grupo_id'],
                $id
            ]);
            if ($check->fetch(PDO::FETCH_ASSOC)['cnt'] > 0) {
                http_response_code(409);
                echo json_encode(['error' => 'Asignación duplicada']);
                return;
            }

            // Sin reparto de horas: comprobar módulo+grupo (excluyendo esta asignación)
            $esDesdoble = isset($data['es_desdoble']) ? (int)$data['es_desdoble'] : 0;
            if (!$esDesdoble) {
                $chk = $this->db->prepare(
                    "SELECT COUNT(*) as cnt FROM asignacion
                     WHERE curso_id=? AND modulo_id=? AND grupo_id=? AND id!=?"
                );
                $chk->execute([$cursoId, (int)$data['modulo_id'], (int)$data['grupo_id'], $id]);
                if ($chk->fetch(PDO::FETCH_ASSOC)['cnt'] > 0) {
                    http_response_code(409);
                    echo json_encode(['error' => 'Este módulo ya está asignado a otro profesor en este grupo. Márcalo como desdoble si imparten el grupo en paralelo.']);
                    return;
                }
            }

            // Recalcular horas: puesto del (posiblemente nuevo) profesor + módulo
            $profStmt = $this->db->prepare("SELECT puesto FROM profesor WHERE id = ?");
            $profStmt->execute([(int)$data['profesor_id']]);
            $profesor = $profStmt->fetch(PDO::FETCH_ASSOC);
            if (!$profesor) {
                http_response_code(404);
                echo json_encode(['error' => 'Profesor no encontrado']);
                return;
            }
            $modStmt = $this->db->prepare("SELECT horas_pes, horas_ptfp FROM modulo WHERE id = ?");
            $modStmt->execute([(int)$data['modulo_id']]);
            $modulo = $modStmt->fetch(PDO::FETCH_ASSOC);
            if (!$modulo) {
                http_response_code(404);
                echo json_encode(['error' => 'Módulo no encontrado']);
                return;
            }
            $horas = $profesor['puesto'] === 'PES' ? $modulo['horas_pes'] : $modulo['horas_ptfp'];

            $stmt = $this->db->prepare(
                "UPDATE asignacion
                 SET profesor_id=?, modulo_id=?, grupo_id=?, horas=?, es_desdoble=?, observaciones=?
                 WHERE id=?"
            );
            $stmt->execute([
                (int)$data['profesor_id'],
                (int)$data['modulo_id'],
                (int)$data['grupo_id'],
                (float)$horas,
                $esDesdoble,
                $data['observaciones'] ?? null,
                $id
            ]);

            echo json_encode(['mensaje' => 'Asignación actualizada', 'horas' => $horas]);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['error' => $e->getMessage()]);
        }
    }

    public function destroy(int $id): void {
        try {
            $stmt = $this->db->prepare("DELETE FROM asignacion WHERE id = ?");
            $stmt->execute([$id]);
            echo json_encode(['mensaje' => 'Asignación eliminada']);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['error' => $e->getMessage()]);
        }
    }
}
