# Asignación de Horas por Departamentos
## Proyecto Fin de Ciclo — DAM

---

## Descripción
Aplicación web para gestionar el reparto de horas lectivas del Departamento de Informática:
profesores, grupos, módulos, asignaciones, cargos y cursos escolares, con autenticación,
sincronización multiusuario e informes exportables.

Arquitectura API REST (PHP + MySQL) + Frontend (HTML/CSS/JS vanilla), desplegada en
hosting compartido (InfinityFree).

---

## Características principales

- **Autenticación con sesiones**: login con contraseñas bcrypt; la API devuelve `401` a
  cualquier petición sin sesión iniciada.
- **Cursos escolares**: solo uno activo a la vez; al crear un curso se puede copiar la
  plantilla de profesores del anterior.
- **Modelo de horas por puesto**: cada módulo define `horas_pes` y `horas_ptfp`; las horas
  de cada asignación las **calcula siempre el servidor** según el puesto del profesor
  (los valores del cliente se ignoran). Al editar un módulo, el cambio se propaga a las
  asignaciones existentes dentro de una transacción.
- **Planes de estudio**: relación grupo↔módulo (`grupo_modulo`) con restricción UNIQUE.
- **Cargos**: catálogo con horas por defecto y asignación al profesorado; computan en el
  total de horas de cada profesor.
- **Sincronización multiusuario**: polling cada 15 s que compara el JSON recibido con el
  anterior y solo repinta si hay cambios; se pausa cuando la pestaña no está visible.
- **Informes**: impresión directa, PDF en A4 apaisado (jsPDF + autotable) y Excel de tres
  hojas — Resumen, Módulos y Cargos — (SheetJS). Las librerías se cargan bajo demanda
  desde CDN: la aplicación no tiene dependencias externas en su núcleo.
- **Seguridad (OWASP Top 10 2021)**: consultas preparadas (A03), escapado XSS con `esc()`
  en todo el frontend (A03), control de acceso en el punto de entrada de la API (A01),
  `session_regenerate_id()` tras el login (A07), errores ocultos al cliente y sin CORS
  abierto (A05).

---

## Estructura del proyecto

```
proyecto/
├── api/
│   ├── .htaccess
│   ├── config/
│   │   └── database.php           ← Conexión MySQL (credenciales)
│   ├── controllers/
│   │   ├── AsignacionController.php
│   │   ├── CargoController.php
│   │   ├── CursoController.php
│   │   ├── GrupoController.php
│   │   ├── ModuloController.php
│   │   ├── ProfesorController.php
│   │   └── UsuarioController.php
│   └── index.php                  ← Punto de entrada: autenticación + router
├── frontend/
│   ├── index.php                  ← Dashboard
│   ├── includes/
│   │   └── sidebar.php
│   ├── css/
│   │   └── main.css
│   ├── img/
│   ├── js/
│   │   ├── api.js                 ← Cliente HTTP + esc() (XSS) + parseApiError()
│   │   ├── sync.js                ← Sincronización por polling
│   │   ├── informe.js             ← Informes: imprimir / PDF / Excel
│   │   ├── dashboard.js, profesores.js, grupos.js, mod.js,
│   │   ├── asignaciones.js, cursos.js, cargos.js, usuarios.js
│   │   └── hamburger.js
│   └── pages/
│       ├── profesores.php, grupos.php, modulos.php,
│       ├── asignaciones.php, cursos.php, cargos.php
│       └── usuarios.php
├── auth.php                       ← Validación de sesión en cada página
├── login.php / logout.php
├── schema_infinityfree.sql        ← Esquema completo (9 tablas) con datos de prueba
├── schema.png                     ← Diagrama E-R
└── README.md
```

---

## Instalación

### Requisitos
- PHP 8.1+
- MySQL 8.0+
- Apache / Nginx (o `php -S localhost:8000` para desarrollo)

### Desarrollo local

1. **Importar la base de datos**
   ```bash
   mysql -u root -p < schema_infinityfree.sql
   ```

2. **Configurar la conexión** en `api/config/database.php`
   (host, nombre de base de datos, usuario y contraseña).
   *No subas este fichero con credenciales reales a ningún repositorio.*

3. **Lanzar el servidor**
   ```bash
   php -S localhost:8000
   ```

4. Acceder a `http://localhost:8000/login.php` con un usuario activo de la tabla `usuario`.

### Despliegue en InfinityFree (u otro hosting compartido)

1. Subir todos los ficheros por FTP/SFTP manteniendo la estructura.
2. Importar `schema_infinityfree.sql` desde phpMyAdmin.
3. Ajustar las credenciales en `api/config/database.php` con los datos del hosting.

---

## Endpoints de la API

Todas las rutas exigen sesión iniciada (en caso contrario: `401 No autenticado`).

### CRUD genérico

Disponible para `profesores`, `grupos`, `modulos`, `asignaciones`, `cursos`, `cargos`
y `usuarios`:

| Método | URL                    | Acción          |
|--------|------------------------|-----------------|
| GET    | /api/{recurso}         | Listar          |
| GET    | /api/{recurso}/{id}    | Ver uno         |
| POST   | /api/{recurso}         | Crear           |
| PUT    | /api/{recurso}/{id}    | Editar          |
| DELETE | /api/{recurso}/{id}    | Eliminar        |

### Rutas especiales

| Método | URL                                  | Acción                                            |
|--------|--------------------------------------|---------------------------------------------------|
| GET    | /api/profesores/horas                | Resumen de horas por profesor (módulos + cargos)  |
| GET    | /api/cursos/activo                   | Curso escolar activo                              |
| GET    | /api/cursos/{id}/profesores          | Profesores de un curso                            |
| PUT    | /api/cursos/{id}/activar             | Activar un curso (desactiva el resto)             |
| GET    | /api/modulos/{id}/grupos             | Grupos que imparten un módulo                     |
| GET    | /api/grupos/{id}/modulos             | Plan de estudios de un grupo                      |
| POST   | /api/grupos/{id}/modulos             | Añadir un módulo al plan del grupo                |
| DELETE | /api/grupos/{id}/modulos/{moduloId}  | Quitar un módulo del plan del grupo               |
| GET    | /api/cargos/asignaciones             | Cargos asignados en el curso activo               |
| POST   | /api/cargos/asignaciones             | Asignar un cargo a un profesor                    |
| PUT    | /api/cargos/asignaciones/{id}        | Editar una asignación de cargo                    |
| DELETE | /api/cargos/asignaciones/{id}        | Eliminar una asignación de cargo                  |

---

## Base de datos

9 tablas: `usuario`, `curso_escolar`, `profesor`, `modulo`, `grupo`, `grupo_modulo`,
`asignacion`, `cargo` y `profesor_cargo`, con claves foráneas, borrado en cascada donde
corresponde y restricciones UNIQUE contra duplicados. El diagrama E-R está en `schema.png`.

---

## Tecnologías

- **Backend**: PHP 8.1, PDO (prepared statements nativos)
- **Base de datos**: MySQL 8.0
- **Frontend**: HTML5, CSS3 (variables, sin frameworks), JavaScript vanilla
- **Informes**: jsPDF 2.5.1 + autotable 3.8.2, SheetJS 0.18.5 (carga bajo demanda desde CDN)
- **Arquitectura**: API REST con punto de entrada único — preparada para conectar una
  app Android/iOS futura
- **Hosting**: InfinityFree (compartido, gratuito)
