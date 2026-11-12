# Proyecto Integrador — Dashboard Kanban

Aplicación para **gestionar el ciclo de vida de un proyecto con Kanban**: tableros, columnas con límite de WIP, tarjetas que fluyen por el proceso, y un **dashboard de métricas**. Es el hilo del curso: se construye aplicando los métodos ágiles que vamos viendo (Kanban, XP, Scrum) y se documenta sobre sí mismo.

> **Equipos:** 3–4 personas. **Entrega final:** Unidad 5 (MVP funcionando + arquitectura + presentación).

---

## 1. ¿Qué debe hacer? (requisitos funcionales)

Se usa **MoSCoW** (de la metodología DSDM, Unidad 2) para priorizar.

### MUST — MVP obligatorio
- **Tableros (boards):** crear, listar, editar y eliminar un tablero (proyecto).
- **Columnas (columns):** por tablero, con **nombre**, **orden/posición** y **límite de WIP**. Representan las etapas del ciclo de vida (p. ej. *Backlog → Por hacer → En progreso → En pruebas → Hecho*).
- **Tarjetas (cards):** crear, editar, eliminar y **mover** entre columnas. Cada tarjeta tiene título, descripción, prioridad y fecha de creación.
- **Regla de WIP (la joya):** la app **impide mover** una tarjeta a una columna que ya alcanzó su límite de WIP. *La aplicación aplica lo que enseña Kanban.*
- **Dashboard de métricas:** mostrar, por tablero:
  - Número de tarjetas por columna y **WIP actual vs. límite**.
  - **Cycle time** (tiempo que tardó una tarjeta desde que entró "En progreso" hasta "Hecho").
  - Total de tarjetas por estado.

### SHOULD — deseable
- **Usuarios y asignación:** autenticación básica y asignar tarjetas a una persona.
- **Historial de movimientos** de cada tarjeta (para calcular tiempos de forma fiable).
- **Etiquetas/colores** en las tarjetas.

### COULD — si da tiempo (conecta con Unidad 5)
- **Tiempo real / multiusuario:** que varios vean el tablero actualizarse (WebSocket) → excelente para hablar de **arquitectura distribuida**.
- Gráfica de **flujo acumulado** (CFD) o burndown.

### WON'T — fuera de alcance (por ahora)
- Apps móviles nativas, integraciones externas, permisos avanzados por rol.

---

## 2. Stack técnico (obligatorio)

| Capa | Tecnología |
|------|------------|
| **Backend / API** | **Go (Golang)** — API REST |
| **Base de datos** | **MySQL 8** |
| **Migraciones** | Archivos de **migrations** versionados (ej. `golang-migrate`) |
| **Frontend** | **Libre** (React, Vue, Svelte, o incluso HTML + JS plano). Consume la API |
| **Contenedores** | Todo **dockerizado** (imágenes + `docker-compose`) |
| **Arquitectura** | **DDD** (Domain-Driven Design) — ver sección 3 |

---

## 3. ¿Qué es la estructura DDD? (Domain-Driven Design)

**DDD (Diseño Guiado por el Dominio)** es una forma de organizar el código **alrededor del negocio** (el "dominio"), no alrededor del framework o la base de datos. La idea central: el corazón del sistema es el **dominio** (las reglas del Kanban: qué es un tablero, una tarjeta, el límite de WIP), y ese corazón **no debe depender** de detalles técnicos (MySQL, HTTP, Docker). Esos detalles se enchufan por fuera.

### Sus 4 capas
1. **Domain (Dominio)** — el núcleo. Contiene:
   - **Entidades:** objetos con identidad (p. ej. `Board`, `Column`, `Card`).
   - **Value Objects:** valores sin identidad propia (p. ej. `WipLimit`, `Priority`).
   - **Agregados:** un grupo de entidades tratado como unidad (p. ej. `Board` es la raíz que contiene sus `Column` y `Card`).
   - **Interfaces de repositorio:** *contratos* para guardar/leer (ej. `BoardRepository`), **sin** decir cómo (eso va en infraestructura).
   - **Servicios de dominio:** reglas que no caben en una sola entidad (ej. "mover tarjeta respetando el WIP").
2. **Application (Aplicación)** — los **casos de uso** (ej. `CrearTablero`, `MoverTarjeta`). Orquesta el dominio; no tiene reglas de negocio propias.
3. **Infrastructure (Infraestructura)** — la implementación técnica: repositorios con **MySQL**, conexión a BD, configuración, etc. *Aquí* vive el "cómo".
4. **Interfaces / Presentation** — la entrada/salida: **handlers HTTP**, rutas de la API REST, DTOs (JSON). Traduce peticiones web en casos de uso.

> **Regla de oro (dependencias hacia adentro):** Interfaces → Application → Domain, e Infrastructure también apunta al Domain. El **Domain no importa nada** de las otras capas. Así puedes cambiar MySQL por otra BD, o HTTP por gRPC, sin tocar las reglas del Kanban.

### Estructura de carpetas sugerida (Go)
```
kanban-dashboard/
├── cmd/
│   └── api/
│       └── main.go                 # arranque de la app
├── internal/
│   ├── domain/                     # NÚCLEO (sin dependencias técnicas)
│   │   ├── board/
│   │   │   ├── board.go            # entidad/agregado Board
│   │   │   ├── column.go           # entidad Column (+ WipLimit value object)
│   │   │   ├── card.go             # entidad Card
│   │   │   └── repository.go       # interface BoardRepository
│   │   └── service/
│   │       └── move_card.go        # servicio de dominio (regla del WIP)
│   ├── application/                # CASOS DE USO
│   │   ├── create_board.go
│   │   ├── move_card.go
│   │   └── get_metrics.go
│   ├── infrastructure/             # DETALLES TÉCNICOS
│   │   ├── persistence/mysql/
│   │   │   └── board_repository.go # implementa BoardRepository con MySQL 8
│   │   └── config/
│   └── interfaces/http/            # ENTRADA (API REST)
│       ├── handlers/
│       └── router.go
├── migrations/                     # migraciones SQL versionadas
│   ├── 000001_init.up.sql
│   └── 000001_init.down.sql
├── frontend/                       # el frontend (libre)
├── Dockerfile                      # imagen del backend (Go, multi-stage)
├── docker-compose.yml              # api + mysql (+ frontend)
└── README.md
```

---

## 4. Modelo de datos (MySQL 8)

Tablas mínimas:

- **boards** — `id`, `name`, `description`, `created_at`.
- **columns** — `id`, `board_id` (FK), `name`, `position`, `wip_limit`.
- **cards** — `id`, `column_id` (FK), `title`, `description`, `priority`, `assignee`, `created_at`, `position`.
- **card_movements** — `id`, `card_id` (FK), `from_column_id`, `to_column_id`, `moved_at` *(para calcular cycle time)*.
- *(opcional)* **users** — `id`, `name`, `email`, `password_hash`.

Todo el esquema se crea con **archivos de migración** (nunca a mano en la BD), para que cualquiera levante el proyecto desde cero.

---

## 5. API REST (ejemplos de endpoints)

```
GET    /boards                 # listar tableros
POST   /boards                 # crear tablero
GET    /boards/{id}            # tablero con sus columnas y tarjetas
PUT    /boards/{id}            # editar
DELETE /boards/{id}            # eliminar

POST   /boards/{id}/columns    # crear columna (con wip_limit)
PUT    /columns/{id}           # editar columna / límite WIP

POST   /columns/{id}/cards     # crear tarjeta
PUT    /cards/{id}             # editar tarjeta
POST   /cards/{id}/move        # mover a otra columna  -> valida el WIP (409 si excede)
DELETE /cards/{id}             # eliminar

GET    /boards/{id}/metrics    # métricas del dashboard (WIP, cycle time, conteos)
```

---

## 6. Dockerización

- **`Dockerfile`** del backend: **multi-stage** (compila el binario de Go y lo copia a una imagen ligera, p. ej. `alpine` o `scratch`).
- **`docker-compose.yml`** con, al menos, estos servicios:
  - **`db`** → imagen `mysql:8`, con volumen para persistir datos y variables de entorno (usuario/clave/BD).
  - **`api`** → la imagen del backend Go; depende de `db`.
  - *(opcional)* **`migrate`** → corre las migraciones al levantar.
  - *(opcional)* **`frontend`** → sirve el frontend.
- Objetivo: que con **`docker-compose up`** el proyecto quede corriendo completo, sin instalar nada en la máquina.

---

## 7. Cómo se documenta sobre sí mismo (auto-documentación)

El equipo **gestiona el desarrollo del dashboard usando un tablero Kanban** (puede ser físico, Trello/GitHub Projects, o el propio dashboard cuando ya funcione). Van registrando ahí las tareas de construcción, aplicando el **límite de WIP** que enseña la materia. Ese tablero **es la bitácora** del proceso.

---

## 8. Entregables por unidad (evidencias)

| Unidad | Entrega del proyecto |
|--------|----------------------|
| **U2** | Tablero Kanban del equipo + metodología justificada |
| **U3 (XP)** | Evidencia de **TDD** (pruebas del dominio en Go) + **pair programming** |
| **U4 (Scrum)** | **Product/Sprint Backlog** con historias de usuario + 1 Sprint documentado |
| **U5** | **MVP funcionando** (dockerizado) + documento de **arquitectura (DDD)** + **presentación y demo** |

> La Unidad 1 evalúa los fundamentos (cuadro comparativo + Manifiesto), no el proyecto.

---

## 9. Criterios de evaluación del entregable final (U5, rúbrica, 60)

- Funciona con `docker-compose up` y usa **MySQL 8** + **migrations** — **15**
- Respeta la **estructura DDD** (capas separadas, dominio independiente) — **15**
- **Regla de WIP** implementada y funcionando — **10**
- **Dashboard de métricas** (WIP, cycle time, conteos) — **10**
- Calidad del código y del frontend — **10**

*(La evidencia 2 de U5, 40 pts, es la presentación y demo.)*

---

> **Recordatorio de alcance:** no busquen un Trello completo. Un **MVP pequeño pero bien hecho** (tableros, columnas con WIP, tarjetas que se mueven, y un dashboard básico) vale más que muchas funciones a medias. Lo importante es **aplicar bien el proceso ágil, la arquitectura DDD y dockerizar**.
