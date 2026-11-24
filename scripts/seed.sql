-- Script de datos simulados (Seed) para Kanban Boards
-- Contraseña de prueba utilizada para los hashes bcrypt de users: password123
-- Convenciones: wip_limit NULL = sin límite; columns.color_hex NULL = sin color;
-- cards.color_hex DEFAULT = '#FEFF9C'

INSERT INTO users (id, name, email, password_hash) VALUES
(1, 'Alexis Jair Fuentes Hernández', 'alexis@kanban.local', '$2a$04$QwjHucJadhrB1suQT1TjTuq2/7/osdYu7emBQ/qFKo.5icHxPGSde'),
(2, 'Edgar Arriaga Caracosa', 'edgar@kanban.local', '$2a$04$PdvDNVi80iDKE3mjb8zm/.zwKGlxF82XrZM7m8gBqvPX8FkaRIrye'),
(3, 'Jonas Heliane Hurtado Zepeda', 'jonas@kanban.local', '$2a$04$b6EU3T2HAxcm/4w.uFln6OhTOxpt26plVuC4d.SXak91swywFWLKK'),
(4, 'Iris Ivett', 'iivett0@t.co', '$2a$04$k8KqAgVI59VWAXRGScbJ3Oc5EebHw6VRSLo4B0yevi7pVBb04iZqm'),
(5, 'Maryellen Pedrollo', 'mpedrollo1@prweb.com', '$2a$04$TmQyKyOV.BHMpFCY1ciHqe2UOAI9ty/wEoVRa8fQU.7GRk9aVKJ/K'),
(6, 'Reg Eddowes', 'reddowes2@about.me', '$2a$04$ivvjyd/KswhPoB47O/joGOSUQeypWlx42qwqfClLVkJPCG6PRhW.C'),
(7, 'Olympia Kobieriecki', 'okobieriecki3@pcworld.com', '$2a$04$CYSG0u7a0ZRAsK61ZWSDAeeMozNEcBNVqyCNNi.yI7rUl/35OE0zC'),
(8, 'Shirl Warrack', 'swarrack4@nih.gov', '$2a$04$nECQ773Y1P7WxEpTpIKu5.nZFc9oJkqFtOBlDpNG6hqcVrY5nIvI2'),
(9, 'Huntington Howard', 'hhoward5@nature.com', '$2a$04$VuDqhQkNWfF9mx3M56limOkfIUnAZZdoP6s6vFibKvzWhSuuwM4RC'),
(10, 'Donaugh Stidson', 'dstidson6@twitter.com', '$2a$04$1Qx3PiOksxcGsdx7fKoMROMJlDJWVd43XSoLdu3V8oON67QUrEnVW'),
(11, 'Vikky Hardware', 'vhardware7@github.io', '$2a$04$RHm6j27W3SkQwHBSsEfWNOwNzGXc3pLBKThrBhI39HEGQ5GIM5rOy'),
(12, 'Lyndsey Tremmil', 'ltremmil8@trellian.com', '$2a$04$35gbAXCjBFtOXsdJCqa1sOTTjj.smyKm6wqC9uwQ3LnnNMfnjGC1K'),
(13, 'Julienne Bindon', 'jbindon9@webnode.com', '$2a$04$i9/qWwbJBgJjoXoZUtgfdeXh.k6FkVQSzSBmZQ28oFoAL/YQtPKEG');


INSERT INTO boards (id, name, description, created_at) VALUES
(1, 'Proyecto Integrador - Kanban MVP', 'Desarrollo del tablero Kanban con Go, MySQL 8 y arquitectura DDD.', '2026-11-01 09:00:00'),
(2, 'Diseño UI/UX y Documentación', 'Prototipos en Figma, manual de usuario y diagramas de arquitectura.', '2026-11-05 10:30:00');


INSERT INTO boards_users (user_id, board_id) VALUES
(1, 1), (2, 1), (3, 1),
(1, 2), (2, 2), (3, 2);


INSERT INTO columns (id, board_id, name, position, wip_limit, color_hex) VALUES
-- Tablero 1
(1, 1, 'Por hacer',   0, NULL, NULL),       -- sin límite, sin color
(2, 1, 'En progreso', 1, 3,    '#F59E0B'),  -- límite WIP de 3 tarjetas
(3, 1, 'Review/QA',   2, 2,    '#8B5CF6'),  -- límite WIP de 2 tarjetas
(4, 1, 'Terminado',   3, NULL, NULL),       -- sin límite, sin color
-- Tablero 2
(5, 2, 'Por hacer',   0, NULL, NULL),
(6, 2, 'En progreso', 1, 2,    '#3B82F6'),
(7, 2, 'Terminado',   2, NULL, '#22C55E');


INSERT INTO labels (id, board_id, name, description, color_hex) VALUES
(1, 1, 'Backend',      'Tareas de API REST en Go y lógica DDD', '#2563EB'),
(2, 1, 'Base de Datos','Migraciones SQL, índices y scripts',    '#16A34A'),
(3, 1, 'Bug',          'Errores detectados en pruebas',         '#DC2626'),
(4, 2, 'Figma',        'Vistas y componentes visuales',         '#9333EA');


INSERT INTO cards (id, column_id, title, description, priority, color_hex, created_at, position) VALUES
-- Por hacer (tablero 1)
(1, 1, 'Implementar endpoint de métricas', 'Calcular cycle time y conteo por columna en GET /boards/{id}/metrics', 'alta',  DEFAULT,   '2026-11-10 10:00:00', 0),
(2, 1, 'Conectar vista de Login con API',  'Validar credenciales con bcrypt y guardar sesión',                    'media', '#FCA5A5', '2026-11-11 11:20:00', 1),
-- En progreso (tablero 1)
(3, 2, 'Programar regla de límite WIP',    'Bloquear movimiento con HTTP 409 si la columna destino está llena',   'alta',  DEFAULT,   '2026-11-08 09:15:00', 0),
(4, 2, 'Maquetar vista del Dashboard',     'Integrar gráficas de flujo acumulado y tarjetas por estado',          'media', '#93C5FD', '2026-11-09 14:00:00', 1),
-- Review/QA (tablero 1)
(5, 3, 'Revisar migraciones MySQL 8',      'Verificar llaves foráneas, restricciones CHECK y ON DELETE',          'baja',  '#C4B5FD', '2026-11-06 16:45:00', 0),
-- Terminado (tablero 1)
(6, 4, 'Configurar Docker Compose',        'Levantar contenedor mysql:8.4 con variables de entorno',              'alta',  DEFAULT,   '2026-11-02 08:30:00', 0),
(7, 4, 'Diseñar diagrama Entidad-Relación','Definir tablas pivote e historial de movimientos',                    'media', '#86EFAC', '2026-11-03 12:00:00', 1),
-- Tablero 2
(8, 5, 'Definir paleta de colores',        'Estandarizar colores de prioridad rojo, amarillo y verde',            'baja',  DEFAULT,   '2026-11-05 11:00:00', 0),
(9, 6, 'Prototipo de pantalla Board page', 'Diseñar tarjetas arrastrables y contador WIP en encabezado',          'alta',  '#FDBA74', '2026-11-06 15:10:00', 0);


INSERT INTO cards_users (user_id, card_id) VALUES
(1, 3), (1, 5), (1, 6),
(2, 2), (2, 4), (2, 9),
(3, 1), (3, 7), (3, 8);


INSERT INTO cards_labels (label_id, card_id) VALUES
(1, 1), (1, 3),
(2, 5), (2, 6), (2, 7),
(4, 8), (4, 9);


INSERT INTO card_movements (id, card_id, from_column_id, to_column_id, moved_at) VALUES
(1,  1, NULL, 1, '2026-11-10 10:00:00'),
(2,  2, NULL, 1, '2026-11-11 11:20:00'),
(3,  3, NULL, 1, '2026-11-08 09:15:00'),
(4,  3, 1,    2, '2026-11-09 10:00:00'),
(5,  4, NULL, 1, '2026-11-09 14:00:00'),
(6,  4, 1,    2, '2026-11-09 16:00:00'),
(7,  5, NULL, 1, '2026-11-06 16:45:00'),
(8,  5, 1,    3, '2026-11-07 10:00:00'),
(9,  6, NULL, 1, '2026-11-02 08:30:00'),
(10, 6, 1,    2, '2026-11-02 10:00:00'),
(11, 6, 2,    4, '2026-11-04 16:00:00'),
(12, 7, NULL, 1, '2026-11-03 12:00:00'),
(13, 7, 1,    2, '2026-11-04 09:00:00'),
(14, 7, 2,    4, '2026-11-05 15:00:00'),
(15, 8, NULL, 5, '2026-11-05 11:00:00'),
(16, 9, NULL, 5, '2026-11-06 15:10:00'),
(17, 9, 5,    6, '2026-11-07 09:00:00');