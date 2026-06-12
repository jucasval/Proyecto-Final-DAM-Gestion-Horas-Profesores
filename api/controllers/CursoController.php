<?php
// api/controllers/CursoController.php — CON COPIA DE CARGOS

class CursoController {
    public function __construct(private PDO $db) {}

    public function index(): void {
        $stmt = $this->db->query("SELECT * FROM curso_escolar ORDER BY fecha_inicio DESC");
        echo json_encode($stmt->fetchAll());
    }

    public function show(int $id): void {
        $stmt = $this->db->prepare("SELECT * FROM curso_escolar WHERE id = ?");
        $stmt->execute([$id]);
        $row = $stmt->fetch();
        if (!$row) { http_response_code(404); echo json_encode(['error' => 'Curso no encontrado']); return; }
        echo json_encode($row);
    }

    public function activo(): void {
        $stmt = $this->db->query("SELECT * FROM curso_escolar WHERE activo = 1 LIMIT 1");
        $row  = $stmt->fetch();
        if (!$row) { http_response_code(404); echo json_encode(['error' => 'No hay ningún curso activo']); return; }
        echo json_encode($row);
    }

    public function store(array $data): void {
        foreach (['nombre', 'fecha_inicio', 'fecha_fin'] as $f) {
            if (empty($data[$f])) {
                http_response_code(422);
                echo json_encode(['error' => "El campo '$f' es obligatorio"]);
                return;
            }
        }

        // ========== VALIDAR FECHAS ==========
        $fechaInicio = strtotime($data['fecha_inicio']);
        $fechaFin = strtotime($data['fecha_fin']);
        
        if ($fechaFin < $fechaInicio) {
            http_response_code(422);
            echo json_encode(['error' => 'La fecha final no puede ser anterior a la fecha inicial']);
            return;
        }

        $this->db->beginTransaction();
        try {
            // Obtener curso activo antes de desactivar
            $stmtActivo = $this->db->query("SELECT id FROM curso_escolar WHERE activo = 1 LIMIT 1");
            $cursoAnterior = $stmtActivo->fetch();
            $cursoAnteriorId = $cursoAnterior ? (int)$cursoAnterior['id'] : null;

            // Desactivar curso actual
            $this->db->exec("UPDATE curso_escolar SET activo = 0");

            // Crear nuevo curso
            $stmt = $this->db->prepare(
                "INSERT INTO curso_escolar (nombre, fecha_inicio, fecha_fin, activo)
                 VALUES (:nombre, :fecha_inicio, :fecha_fin, 1)"
            );
            $stmt->execute([
                ':nombre'       => trim($data['nombre']),
                ':fecha_inicio' => $data['fecha_inicio'],
                ':fecha_fin'    => $data['fecha_fin'],
            ]);
            $nuevoCursoId = $this->db->lastInsertId();

            // ========== COPIAR MÓDULOS DEL CURSO ANTERIOR ==========
            $mapaModulos = []; // [id_viejo => id_nuevo]
            if ($cursoAnteriorId) {
                $stmtModulos = $this->db->prepare(
                    "SELECT id, nombre, codigo, horas_pes, horas_ptfp FROM modulo WHERE curso_id = ?"
                );
                $stmtModulos->execute([$cursoAnteriorId]);
                $modulos = $stmtModulos->fetchAll();

                if (!empty($modulos)) {
                    $insertMod = $this->db->prepare(
                        "INSERT INTO modulo (curso_id, nombre, codigo, horas_pes, horas_ptfp)
                         VALUES (:curso_id, :nombre, :codigo, :horas_pes, :horas_ptfp)"
                    );
                    foreach ($modulos as $m) {
                        $insertMod->execute([
                            ':curso_id'    => $nuevoCursoId,
                            ':nombre'      => $m['nombre'],
                            ':codigo'      => $m['codigo'],
                            ':horas_pes'   => $m['horas_pes'],
                            ':horas_ptfp'  => $m['horas_ptfp'],
                        ]);
                        $mapaModulos[$m['id']] = $this->db->lastInsertId();
                    }
                }
            }

            // ========== COPIAR GRUPOS Y ACTUALIZAR grupo_modulo ==========
            if ($cursoAnteriorId) {
                // Obtener SOLO grupos del curso anterior (asumiendo existe relación)
                // Como grupo NO tiene curso_id, obtenemos los grupos asignados a módulos del curso anterior
                $stmtGrupos = $this->db->prepare(
                    "SELECT DISTINCT g.id, g.nombre, g.ciclo, g.curso, g.modalidad 
                     FROM grupo g
                     JOIN grupo_modulo gm ON g.id = gm.grupo_id
                     JOIN modulo m ON gm.modulo_id = m.id
                     WHERE m.curso_id = ?
                     ORDER BY g.ciclo, g.curso, g.nombre"
                );
                $stmtGrupos->execute([$cursoAnteriorId]);
                $grupos = $stmtGrupos->fetchAll();

                $mapaGrupos = []; // [id_viejo => id_nuevo]
                foreach ($grupos as $g) {
                    // Verificar si el grupo ya existe
                    $stmtCheck = $this->db->prepare(
                        "SELECT id FROM grupo WHERE nombre = ? AND ciclo = ? AND curso = ? AND modalidad = ?"
                    );
                    $stmtCheck->execute([$g['nombre'], $g['ciclo'], $g['curso'], $g['modalidad']]);
                    $existe = $stmtCheck->fetch();
                    
                    if ($existe) {
                        // Grupo ya existe, usar su ID
                        $mapaGrupos[$g['id']] = $existe['id'];
                    } else {
                        // Grupo no existe, crearlo
                        $insertGrupo = $this->db->prepare(
                            "INSERT INTO grupo (nombre, ciclo, curso, modalidad) VALUES (?, ?, ?, ?)"
                        );
                        $insertGrupo->execute([
                            $g['nombre'],
                            $g['ciclo'],
                            $g['curso'],
                            $g['modalidad'],
                        ]);
                        $mapaGrupos[$g['id']] = $this->db->lastInsertId();
                    }
                }

                // Copiar grupo_modulo con los nuevos IDs de módulos y grupos
                if (!empty($mapaGrupos) && !empty($mapaModulos)) {
                    $stmtGM = $this->db->prepare(
                        "SELECT grupo_id, modulo_id FROM grupo_modulo WHERE grupo_id IN (" .
                        implode(',', array_fill(0, count($mapaGrupos), '?')) . ")"
                    );
                    $stmtGM->execute(array_keys($mapaGrupos));
                    $grupoModulos = $stmtGM->fetchAll();

                    $insertGM = $this->db->prepare(
                        "INSERT IGNORE INTO grupo_modulo (grupo_id, modulo_id) VALUES (?, ?)"
                    );
                    foreach ($grupoModulos as $gm) {
                        $nuevoGrupoId = $mapaGrupos[$gm['grupo_id']] ?? null;
                        $nuevoModuloId = $mapaModulos[$gm['modulo_id']] ?? null;
                        if ($nuevoGrupoId && $nuevoModuloId) {
                            $insertGM->execute([$nuevoGrupoId, $nuevoModuloId]);
                        }
                    }
                }
            }

            // ========== COPIAR CARGOS DEL CURSO ANTERIOR ==========
            if ($cursoAnteriorId) {
                $stmtCargos = $this->db->prepare(
                    "SELECT nombre, horas FROM cargo WHERE curso_id = ?"
                );
                $stmtCargos->execute([$cursoAnteriorId]);
                $cargos = $stmtCargos->fetchAll();

                if (!empty($cargos)) {
                    $insertCargo = $this->db->prepare(
                        "INSERT INTO cargo (curso_id, nombre, horas)
                         VALUES (:curso_id, :nombre, :horas)"
                    );
                    foreach ($cargos as $c) {
                        $insertCargo->execute([
                            ':curso_id' => $nuevoCursoId,
                            ':nombre'   => $c['nombre'],
                            ':horas'    => $c['horas'],
                        ]);
                    }
                }
            }

            // Copiar profesores seleccionados
            $profesoresIds = $data['profesores_ids'] ?? [];
            if (!empty($profesoresIds)) {
                $placeholders = implode(',', array_fill(0, count($profesoresIds), '?'));
                $stmt = $this->db->prepare(
                    "SELECT id, nombre, apellidos, puesto, horas_totales FROM profesor WHERE id IN ($placeholders)"
                );
                $stmt->execute($profesoresIds);
                $profesores = $stmt->fetchAll();

                $insertProf = $this->db->prepare(
                    "INSERT INTO profesor (curso_id, nombre, apellidos, puesto, horas_totales)
                     VALUES (:curso_id, :nombre, :apellidos, :puesto, :horas_totales)"
                );
                $mapaIds = []; // [id_antiguo => id_nuevo]
                foreach ($profesores as $p) {
                    $insertProf->execute([
                        ':curso_id'      => $nuevoCursoId,
                        ':nombre'        => $p['nombre'],
                        ':apellidos'     => $p['apellidos'],
                        ':puesto'        => $p['puesto'],
                        ':horas_totales' => $p['horas_totales'],
                    ]);
                    $mapaIds[$p['id']] = $this->db->lastInsertId();
                }

                // Copiar asignaciones de cargos del curso anterior con los nuevos IDs
                // EXCEPTO Tutor/a (se asigna manualmente cada año)
                // ⚠️ Crear mapa de cargos por nombre para asegurar IDs correctos
                if ($cursoAnteriorId && !empty($mapaIds)) {
                    // Crear mapa: [nombre => id_nuevo]
                    $stmtCargosMapa = $this->db->prepare(
                        "SELECT nombre, id FROM cargo WHERE curso_id = ?"
                    );
                    $stmtCargosMapa->execute([$nuevoCursoId]);
                    $mapaCargosPorNombre = [];
                    foreach ($stmtCargosMapa->fetchAll() as $c) {
                        $mapaCargosPorNombre[$c['nombre']] = $c['id'];
                    }

                    // Obtener asignaciones del curso anterior
                    $oldIds = array_keys($mapaIds);
                    $ph     = implode(',', array_fill(0, count($oldIds), '?'));
                    $stmtCargos = $this->db->prepare(
                        "SELECT pc.profesor_id, c.nombre, c.horas
                         FROM profesor_cargo pc
                         JOIN cargo c ON pc.cargo_id = c.id
                         WHERE pc.curso_id = ? AND pc.profesor_id IN ($ph)
                         AND c.nombre != 'Tutor/a'"
                    );
                    $stmtCargos->execute(array_merge([$cursoAnteriorId], $oldIds));
                    $cargosAnteriores = $stmtCargos->fetchAll();

                    // Insertar con los IDs nuevos del mapa
                    $insertCargo = $this->db->prepare(
                        "INSERT INTO profesor_cargo (curso_id, profesor_id, cargo_id, horas)
                         VALUES (:curso_id, :profesor_id, :cargo_id, :horas)"
                    );
                    foreach ($cargosAnteriores as $c) {
                        $nuevoProfesorId = $mapaIds[$c['profesor_id']] ?? null;
                        $nuevoCargoId = $mapaCargosPorNombre[$c['nombre']] ?? null;
                        if ($nuevoProfesorId && $nuevoCargoId) {
                            $insertCargo->execute([
                                ':curso_id'    => $nuevoCursoId,
                                ':profesor_id' => $nuevoProfesorId,
                                ':cargo_id'    => $nuevoCargoId,  // ← ID nuevo seguro
                                ':horas'       => $c['horas'],
                            ]);
                        }
                    }
                }
            }

            $this->db->commit();
            http_response_code(201);
            echo json_encode([
                'id'      => $nuevoCursoId,
                'mensaje' => 'Curso creado correctamente',
                'profesores_copiados' => count($profesoresIds),
            ]);

        } catch (Exception $e) {
            $this->db->rollBack();
            http_response_code(500);
            echo json_encode(['error' => 'Error al crear el curso: ' . $e->getMessage()]);
        }
    }

    public function update(int $id, array $data): void {
        // ========== VALIDAR FECHAS ==========
        if (!empty($data['fecha_inicio']) && !empty($data['fecha_fin'])) {
            $fechaInicio = strtotime($data['fecha_inicio']);
            $fechaFin = strtotime($data['fecha_fin']);
            
            if ($fechaFin < $fechaInicio) {
                http_response_code(422);
                echo json_encode(['error' => 'La fecha final no puede ser anterior a la fecha inicial']);
                return;
            }
        }

        $stmt = $this->db->prepare(
            "UPDATE curso_escolar SET nombre=:nombre, fecha_inicio=:fecha_inicio, fecha_fin=:fecha_fin WHERE id=:id"
        );
        $stmt->execute([
            ':nombre'       => trim($data['nombre']),
            ':fecha_inicio' => $data['fecha_inicio'],
            ':fecha_fin'    => $data['fecha_fin'],
            ':id'           => $id,
        ]);
        echo json_encode(['mensaje' => 'Curso actualizado']);
    }

    public function activar(int $id): void {
        $this->db->beginTransaction();
        try {
            $this->db->exec("UPDATE curso_escolar SET activo = 0");
            $stmt = $this->db->prepare("UPDATE curso_escolar SET activo = 1 WHERE id = ?");
            $stmt->execute([$id]);
            $this->db->commit();
            echo json_encode(['mensaje' => 'Curso activado correctamente']);
        } catch (Exception $e) {
            $this->db->rollBack();
            http_response_code(500);
            echo json_encode(['error' => 'Error al activar el curso']);
        }
    }

    public function profesores(int $id): void {
        $stmt = $this->db->prepare(
            "SELECT * FROM profesor WHERE curso_id = ? ORDER BY apellidos, nombre"
        );
        $stmt->execute([$id]);
        echo json_encode($stmt->fetchAll());
    }

    public function destroy(int $id): void {
        // No se puede eliminar el curso activo (el frontend deshabilita el
        // botón, pero la API debe garantizarlo igualmente)
        $activo = $this->db->prepare("SELECT activo FROM curso_escolar WHERE id = ?");
        $activo->execute([$id]);
        $row = $activo->fetch();
        if (!$row) {
            http_response_code(404);
            echo json_encode(['error' => 'Curso no encontrado']);
            return;
        }
        if ((int)$row['activo'] === 1) {
            http_response_code(409);
            echo json_encode(['error' => 'No se puede eliminar el curso activo']);
            return;
        }

        // No se puede borrar si tiene asignaciones de módulos
        $check = $this->db->prepare("SELECT COUNT(*) FROM asignacion WHERE curso_id = ?");
        $check->execute([$id]);
        if ($check->fetchColumn() > 0) {
            http_response_code(409);
            echo json_encode(['error' => 'No se puede eliminar: el curso tiene asignaciones de módulos']);
            return;
        }

        $this->db->beginTransaction();
        try {
            // Eliminar en orden correcto (respetando FKs). Tras el guard
            // anterior ya no quedan asignaciones que borrar.
            $this->db->prepare("DELETE FROM grupo_modulo WHERE modulo_id IN (SELECT id FROM modulo WHERE curso_id = ?)")->execute([$id]);
            $this->db->prepare("DELETE FROM profesor_cargo WHERE curso_id = ?")->execute([$id]);
            $this->db->prepare("DELETE FROM profesor WHERE curso_id = ?")->execute([$id]);
            $this->db->prepare("DELETE FROM modulo WHERE curso_id = ?")->execute([$id]);
            $this->db->prepare("DELETE FROM cargo WHERE curso_id = ?")->execute([$id]);
            $this->db->prepare("DELETE FROM curso_escolar WHERE id = ?")->execute([$id]);
            $this->db->commit();

            echo json_encode(['mensaje' => 'Curso eliminado']);
        } catch (Exception $e) {
            $this->db->rollBack();
            error_log('Eliminar curso: ' . $e->getMessage());
            http_response_code(500);
            echo json_encode(['error' => 'Error al eliminar el curso']);
        }
    }
}
