<?php
// api/controllers/CargoController.php — VERSIÓN CORREGIDA CON curso_id

class CargoController {
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
                "SELECT * FROM cargo WHERE curso_id = ? ORDER BY nombre"
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
            $stmt = $this->db->prepare("SELECT * FROM cargo WHERE id = ?");
            $stmt->execute([$id]);
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            if (!$row) {
                http_response_code(404);
                echo json_encode(['error' => 'Cargo no encontrado']);
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
            if (empty($data['nombre'])) {
                http_response_code(422);
                echo json_encode(['error' => "Campo 'nombre' obligatorio"]);
                return;
            }

            $cursoId = $this->cursoActivoId();

            $stmt = $this->db->prepare(
                "INSERT INTO cargo (curso_id, nombre, horas) VALUES (?, ?, ?)"
            );
            $stmt->execute([
                $cursoId,
                trim($data['nombre']),
                $data['horas'] ?? 0
            ]);

            http_response_code(201);
            echo json_encode(['id' => $this->db->lastInsertId(), 'mensaje' => 'Cargo creado']);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['error' => $e->getMessage()]);
        }
    }

    public function update(int $id, array $data): void {
        try {
            if (empty($data['nombre'])) {
                http_response_code(422);
                echo json_encode(['error' => "Campo 'nombre' obligatorio"]);
                return;
            }

            $cursoId = $this->cursoActivoId();
            $nuevasHoras = (float)($data['horas'] ?? 0);

            // ========== 1. ACTUALIZAR CARGO ==========
            $stmt = $this->db->prepare(
                "UPDATE cargo SET nombre = ?, horas = ? WHERE id = ? AND curso_id = ?"
            );
            $stmt->execute([
                trim($data['nombre']),
                $nuevasHoras,
                $id,
                $cursoId
            ]);

            if ($stmt->rowCount() === 0) {
                http_response_code(404);
                echo json_encode(['error' => 'Cargo no encontrado en curso activo']);
                return;
            }

            // ========== 2. ACTUALIZAR ASIGNACIONES ==========
            $stmtAssign = $this->db->prepare(
                "UPDATE profesor_cargo SET horas = ? WHERE cargo_id = ? AND curso_id = ?"
            );
            $stmtAssign->execute([$nuevasHoras, $id, $cursoId]);

            echo json_encode([
                'mensaje' => 'Cargo actualizado',
                'detalles' => [
                    'horas_nuevas' => $nuevasHoras,
                    'asignaciones_actualizadas' => $stmtAssign->rowCount()
                ]
            ]);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['error' => $e->getMessage()]);
        }
    }

    public function destroy(int $id): void {
        try {
            $cursoId = $this->cursoActivoId();

            $check = $this->db->prepare(
                "SELECT COUNT(*) as cnt FROM profesor_cargo WHERE cargo_id = ? AND curso_id = ?"
            );
            $check->execute([$id, $cursoId]);
            if ($check->fetch(PDO::FETCH_ASSOC)['cnt'] > 0) {
                http_response_code(409);
                echo json_encode(['error' => 'Cargo tiene asignaciones en el curso activo']);
                return;
            }

            $stmt = $this->db->prepare("DELETE FROM cargo WHERE id = ? AND curso_id = ?");
            $stmt->execute([$id, $cursoId]);
            echo json_encode(['mensaje' => 'Cargo eliminado']);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['error' => $e->getMessage()]);
        }
    }

    // ---- Asignaciones de cargos ----

    public function asignaciones(): void {
        try {
            $cursoId = $this->cursoActivoId();
            $stmt = $this->db->prepare(
                "SELECT pc.id, pc.curso_id, pc.profesor_id, pc.cargo_id, pc.horas,
                        c.horas AS horas_defecto,
                        CONCAT(p.apellidos, ', ', p.nombre) AS profesor,
                        p.puesto,
                        c.nombre AS cargo
                 FROM profesor_cargo pc
                 JOIN profesor p ON pc.profesor_id = p.id
                 JOIN cargo c ON pc.cargo_id = c.id
                 WHERE pc.curso_id = ?
                 ORDER BY p.apellidos, c.nombre"
            );
            $stmt->execute([$cursoId]);
            echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['error' => $e->getMessage()]);
        }
    }

    public function asignar(array $data): void {
        try {
            foreach (['profesor_id', 'cargo_id'] as $f) {
                if (empty($data[$f])) {
                    http_response_code(422);
                    echo json_encode(['error' => "Campo '$f' obligatorio"]);
                    return;
                }
            }

            $cursoId = $this->cursoActivoId();

            // Si no hay horas, usar las del cargo
            if (!isset($data['horas']) || $data['horas'] === '') {
                $cargostmt = $this->db->prepare("SELECT horas FROM cargo WHERE id = ? AND curso_id = ?");
                $cargostmt->execute([$data['cargo_id'], $cursoId]);
                $cargo = $cargostmt->fetch(PDO::FETCH_ASSOC);
                $data['horas'] = $cargo ? $cargo['horas'] : 0;
            }

            $stmt = $this->db->prepare(
                "INSERT INTO profesor_cargo (curso_id, profesor_id, cargo_id, horas) VALUES (?, ?, ?, ?)"
            );
            $stmt->execute([
                $cursoId,
                (int)$data['profesor_id'],
                (int)$data['cargo_id'],
                (float)$data['horas']
            ]);

            http_response_code(201);
            echo json_encode(['id' => $this->db->lastInsertId(), 'mensaje' => 'Cargo asignado']);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['error' => $e->getMessage()]);
        }
    }

    public function actualizarAsignacion(int $id, array $data): void {
        try {
            // Las horas que envíe el cliente se ignoran: se toman siempre del cargo
            $cargoStmt = $this->db->prepare("SELECT horas FROM cargo WHERE id = ?");
            $cargoStmt->execute([(int)$data['cargo_id']]);
            $cargo = $cargoStmt->fetch(PDO::FETCH_ASSOC);
            if (!$cargo) {
                http_response_code(404);
                echo json_encode(['error' => 'Cargo no encontrado']);
                return;
            }

            $stmt = $this->db->prepare(
                "UPDATE profesor_cargo SET profesor_id = ?, cargo_id = ?, horas = ? WHERE id = ?"
            );
            $stmt->execute([
                (int)$data['profesor_id'],
                (int)$data['cargo_id'],
                (float)$cargo['horas'],
                $id
            ]);

            echo json_encode(['mensaje' => 'Asignación de cargo actualizada']);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['error' => $e->getMessage()]);
        }
    }

    public function eliminarAsignacion(int $id): void {
        try {
            $stmt = $this->db->prepare("DELETE FROM profesor_cargo WHERE id = ?");
            $stmt->execute([$id]);
            echo json_encode(['mensaje' => 'Asignación de cargo eliminada']);
        } catch (Exception $e) {
            http_response_code(500);
            echo json_encode(['error' => $e->getMessage()]);
        }
    }
}
