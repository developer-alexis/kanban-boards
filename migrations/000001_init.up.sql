CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL,
    password_hash CHAR(60) NOT NULL,
    CONSTRAINT uq_users_email UNIQUE (email),
    CONSTRAINT chk_users_name_not_empty CHECK (TRIM(name) <> '')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS boards (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    description TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_boards_name_not_empty CHECK (TRIM(name) <> '')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS boards_users (
    user_id INT NOT NULL,
    board_id INT NOT NULL,
    PRIMARY KEY (user_id, board_id),
    CONSTRAINT fk_bu_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_bu_board FOREIGN KEY (board_id) REFERENCES boards(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS columns (
    id INT AUTO_INCREMENT PRIMARY KEY,
    board_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    position INT NOT NULL DEFAULT 0,
    wip_limit INT NOT NULL DEFAULT 0,
    CONSTRAINT uq_columns_board_name UNIQUE (board_id, name),
    CONSTRAINT chk_columns_position_non_neg CHECK (position >= 0),
    CONSTRAINT chk_columns_wip_non_neg CHECK (wip_limit >= 0),
    CONSTRAINT fk_col_board FOREIGN KEY (board_id) REFERENCES boards(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS cards (
    id INT AUTO_INCREMENT PRIMARY KEY,
    column_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    priority VARCHAR(50) NOT NULL DEFAULT 'media',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    position INT NOT NULL DEFAULT 0,
    CONSTRAINT chk_cards_title_not_empty CHECK (TRIM(title) <> ''),
    CONSTRAINT chk_cards_priority CHECK (priority IN ('baja', 'media', 'alta')),
    CONSTRAINT chk_cards_position_non_neg CHECK (position >= 0),
    CONSTRAINT fk_card_column FOREIGN KEY (column_id) REFERENCES columns(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS cards_users (
    user_id INT NOT NULL,
    card_id INT NOT NULL,
    PRIMARY KEY (user_id, card_id),
    CONSTRAINT fk_cu_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_cu_card FOREIGN KEY (card_id) REFERENCES cards(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS labels (
    id INT AUTO_INCREMENT PRIMARY KEY,
    board_id INT NOT NULL,
    name VARCHAR(120) NOT NULL,
    description TEXT,
    color_hex CHAR(7) NOT NULL DEFAULT '#808080',
    CONSTRAINT uq_labels_board_name UNIQUE (board_id, name),
    CONSTRAINT chk_labels_color_hex CHECK (color_hex REGEXP '^#[0-9A-Fa-f]{6}$'),
    CONSTRAINT fk_label_board FOREIGN KEY (board_id) REFERENCES boards(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS cards_labels (
    label_id INT NOT NULL,
    card_id INT NOT NULL,
    PRIMARY KEY (label_id, card_id),
    CONSTRAINT fk_cl_label FOREIGN KEY (label_id) REFERENCES labels(id) ON DELETE CASCADE,
    CONSTRAINT fk_cl_card FOREIGN KEY (card_id) REFERENCES cards(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS card_movements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    card_id INT NOT NULL,
    from_column_id INT NULL,
    to_column_id INT NOT NULL,
    moved_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_mov_card FOREIGN KEY (card_id) REFERENCES cards(id) ON DELETE CASCADE,
    CONSTRAINT fk_mov_from_col FOREIGN KEY (from_column_id) REFERENCES columns(id) ON DELETE SET NULL,
    CONSTRAINT fk_mov_to_col FOREIGN KEY (to_column_id) REFERENCES columns(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;