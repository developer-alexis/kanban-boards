-- Script de datos simulados (Seed) para Kanban Boards
-- Contraseña de prueba utilizada para los hashes bcrypt de users: password123

INSERT INTO users (id, name, email, password_hash) VALUES
(1, 'Alexis Jair Fuentes Hernández', 'alexis@kanban.local', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy'),
(2, 'Edgar Arriaga Caracosa', 'edgar@kanban.local', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy'),
(3, 'Jonas Heliane Hurtado Zepeda', 'jonas@kanban.local', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy');
(4, 'Iris Ivett', 'iivett0@t.co', '$2a$04$FRnwDIVVN6fpA2TL7ZdGU.gW4PKdW8N/ayUjU6eLbXD3Ln4peanBq'),
(5, 'Maryellen Pedrollo', 'mpedrollo1@prweb.com', '$2a$04$KA8JRbYjwhoAUh2gJ/deL.0WMQQWmYtHF0ol2fxweNFGGKlSAkUZy'),
(6, 'Reg Eddowes', 'reddowes2@about.me', '$2a$04$rYK6dyDAKjFX.kcWtCJT9ONZaCVDCfJBKT5IFqdI5qOGiFNTc2MO2'),
(7, 'Olympia Kobieriecki', 'okobieriecki3@pcworld.com', '$2a$04$ZYPVGrNFN9/j/ZpfhlcSzuKkCxiEb7apXnHn2do3RQhJFGhxblBRe'),
(8, 'Shirl Warrack', 'swarrack4@nih.gov', '$2a$04$Ckrtbwtc1CXdcJnU0YwyYetrifEePyT2jJ9l0/srQJWzLePs6jh5e'),
(9, 'Huntington Howard', 'hhoward5@nature.com', '$2a$04$5vhTG.RAGJ0lRXYfuns8FeRDp2EMAGaDllpTnu2QpSBOLYYRTFm4.'),
(10, 'Donaugh Stidson', 'dstidson6@twitter.com', '$2a$04$RvKs6zgcxaLuw.W9iDL7qeZirv5lOWp5JVhZl6drVDKQISmXFoLEu'),
(11, 'Vikky Hardware', 'vhardware7@github.io', '$2a$04$ifz7RBS3XJAyUF//n/2h/OAtbn4tySaCvqaUbVCF/fWGwu5gzVpea'),
(12, 'Lyndsey Tremmil', 'ltremmil8@trellian.com', '$2a$04$fxgy8AtfllnXMUmy3Z/RWev3pVBHDnoiJwxLXwQyJEXyfbrk7AGKa'),
(13, 'Julienne Bindon', 'jbindon9@webnode.com', '$2a$04$K761QkEB1lQbTq5H4mXKZOo6ouumYQnHvuiezsigYjNSlSfyRpkEm');


INSERT INTO boards (id, name, description, created_at) VALUES
(1, 'Proyecto Integrador - Kanban MVP', 'Desarrollo del tablero Kanban con Go, MySQL 8 y arquitectura DDD.', '2026-11-01 09:00:00'),
(2, 'Diseño UI/UX y Documentación', 'Prototipos en Figma, manual de usuario y diagramas de arquitectura.', '2026-11-05 10:30:00');


INSERT INTO boards_users (user_id, board_id) VALUES
(1, 1), (2, 1), (3, 1),
(1, 2), (3, 2);


INSERT INTO columns (id, board_id, name, position, wip_limit) VALUES

(1, 1, 'Por hacer',   0, 0),  -- Backlog/Por hacer sin límite estricto (0 = ilimitado)
(2, 1, 'En progreso', 1, 3),  -- Límite WIP de 3 tarjetas
(3, 1, 'Review/QA',   2, 2),  -- Límite WIP de 2 tarjetas
(4, 1, 'Terminado',   3, 0),


(5, 2, 'Por hacer',   0, 0),
(6, 2, 'En progreso', 1, 2),
(7, 2, 'Terminado',   2, 0);


INSERT INTO labels (id, board_id, name, description, color_hex) VALUES
(1, 1, 'Backend',      'Tareas de API REST en Go y lógica DDD', '#2563EB'),
(2, 1, 'Base de Datos','Migraciones SQL, índices y scripts',    '#16A34A'),
(3, 1, 'Bug',          'Errores detectados en pruebas',         '#DC2626'),
(4, 2, 'Figma',        'Vistas y componentes visuales',         '#9333EA');


INSERT INTO cards (id, column_id, title, description, priority, created_at, position) VALUES

(1, 1, 'Implementar endpoint de métricas', 'Calcular cycle time y conteo por columna en GET /boards/{id}/metrics', 'alta',  '2026-11-10 10:00:00', 0),
(2, 1, 'Conectar vista de Login con API',  'Validar credenciales con bcrypt y guardar sesión',                    'media', '2026-11-11 11:20:00', 1),

(3, 2, 'Programar regla de límite WIP',    'Bloquear movimiento con HTTP 409 si la columna destino está llena',     'alta',  '2026-11-08 09:15:00', 0),
(4, 2, 'Maquetar vista del Dashboard',     'Integrar gráficas de flujo acumulado y tarjetas por estado',          'media', '2026-11-09 14:00:00', 1),


(5, 3, 'Revisar migraciones MySQL 8',      'Verificar llaves foráneas, restricciones CHECK y ON DELETE',          'baja',  '2026-11-06 16:45:00', 0),

(6, 4, 'Configurar Docker Compose',        'Levantar contenedor mysql:8.4 con variables de entorno',              'alta',  '2026-11-02 08:30:00', 0),
(7, 4, 'Diseñar diagrama Entidad-Relación','Definir tablas pivote e historial de movimientos',                    'media', '2026-11-03 12:00:00', 1),


(8, 5, 'Definir paleta de colores',        'Estandarizar colores de prioridad rojo, amarillo y verde',            'baja',  '2026-11-05 11:00:00', 0),
(9, 6, 'Prototipo de pantalla Board page', 'Diseñar tarjetas arrastrables y contador WIP en encabezado',          'alta',  '2026-11-06 15:10:00', 0);


INSERT INTO cards_users (user_id, card_id) VALUES
(1, 3), (1, 5), (1, 6),
(2, 2), (2, 4), (2, 9),
(3, 1), (3, 7), (3, 8);


INSERT INTO cards_labels (label_id, card_id) VALUES
(1, 1), (1, 3),
(2, 5), (2, 6), (2, 7),
(4, 8), (4, 9);


INSERT INTO card_movements (id, card_id, from_column_id, to_column_id, moved_at) VALUES

(1, 6, NULL, 1, '2026-11-02 08:30:00'),
(2, 6, 1,    2, '2026-11-02 10:00:00'),
(3, 6, 2,    4, '2026-11-04 16:00:00'),


(4, 7, NULL, 1, '2026-11-03 12:00:00'),
(5, 7, 1,    2, '2026-11-04 09:00:00'),
(6, 7, 2,    4, '2026-11-05 15:00:00'),


(7, 3, NULL, 1, '2026-11-08 09:15:00'),
(8, 3, 1,    2, '2026-11-09 10:00:00');