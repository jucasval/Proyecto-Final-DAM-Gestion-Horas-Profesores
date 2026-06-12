<?php
// Plantilla de configuración: copiar como database.php y rellenar.
// database.php está en .gitignore y NUNCA debe subirse al repositorio.
// api/config/database.php
// VERSIÓN INFINITYFREE - Con puerto 3306 explícito

define('DB_HOST', 'localhost');  // ✅ Con puerto
define('DB_NAME', 'nombre_de_tu_bd');
define('DB_USER', 'tu_usuario');
define('DB_PASS', 'tu_contrasena');
define('DB_CHARSET', 'utf8mb4');

function getConnection(): PDO
{
    static $pdo = null;
    if ($pdo === null) {
        $dsn = "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=" . DB_CHARSET;
        $options = [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ];
        try {
            $pdo = new PDO($dsn, DB_USER, DB_PASS, $options);
        } catch (PDOException $e) {
            http_response_code(500);
            error_log('DB: ' . $e->getMessage());
            echo json_encode(['error' => 'Error de conexión a la base de datos']);
            exit;
        }
    }
    return $pdo;
}
