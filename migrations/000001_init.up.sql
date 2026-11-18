CREATE TABLE users (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash CHAR(60) NOT NULL
);

CREATE TABLE boards (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    description TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE columns (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    board_id INT UNSIGNED NOT NULL,
    name VARCHAR(100) NOT NULL,
    position INT UNSIGNED NOT NULL,
    wip_limit INT UNSIGNED,
    CONSTRAINT chk_columns_wip_limit CHECK (wip_limit IS NULL OR wip_limit > 0),
    CONSTRAINT fk_columns_board FOREIGN KEY (board_id) REFERENCES boards(id) ON DELETE CASCADE
);

CREATE TABLE cards (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    column_id INT UNSIGNED NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    priority VARCHAR(50),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    position INT UNSIGNED NOT NULL,
    CONSTRAINT fk_cards_column FOREIGN KEY (column_id) REFERENCES columns(id) ON DELETE CASCADE
);

CREATE TABLE labels (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    board_id INT UNSIGNED NOT NULL,
    name VARCHAR(120) NOT NULL,
    description TEXT,
    color_hex CHAR(7) NOT NULL,
    CONSTRAINT chk_labels_color_hex CHECK (color_hex REGEXP '^#[0-9A-Fa-f]{6}$'),
    CONSTRAINT uq_labels_board_name UNIQUE (board_id, name),
    CONSTRAINT fk_labels_board FOREIGN KEY (board_id) REFERENCES boards(id) ON DELETE CASCADE
);

CREATE TABLE card_movements (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    card_id INT UNSIGNED NOT NULL,
    from_column_id INT UNSIGNED,
    to_column_id INT UNSIGNED NOT NULL,
    moved_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_card_movements_card FOREIGN KEY (card_id) REFERENCES cards(id) ON DELETE CASCADE,
    CONSTRAINT fk_card_movements_from_column FOREIGN KEY (from_column_id) REFERENCES columns(id) ON DELETE CASCADE,
    CONSTRAINT fk_card_movements_to_column FOREIGN KEY (to_column_id) REFERENCES columns(id) ON DELETE CASCADE
);

CREATE TABLE boards_users (
    board_id INT UNSIGNED NOT NULL,
    user_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (board_id, user_id),
    CONSTRAINT fk_boards_users_board FOREIGN KEY (board_id) REFERENCES boards(id) ON DELETE CASCADE,
    CONSTRAINT fk_boards_users_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE cards_users (
    card_id INT UNSIGNED NOT NULL,
    user_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (card_id, user_id),
    CONSTRAINT fk_cards_users_card FOREIGN KEY (card_id) REFERENCES cards(id) ON DELETE CASCADE,
    CONSTRAINT fk_cards_users_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE cards_labels (
    card_id INT UNSIGNED NOT NULL,
    label_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (card_id, label_id),
    CONSTRAINT fk_cards_labels_card FOREIGN KEY (card_id) REFERENCES cards(id) ON DELETE CASCADE,
    CONSTRAINT fk_cards_labels_label FOREIGN KEY (label_id) REFERENCES labels(id) ON DELETE CASCADE
);