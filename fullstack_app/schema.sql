-- =========================================================
-- schema.sql
-- Run this once to create the database and tables.
-- Usage: mysql -u root -p < schema.sql
-- =========================================================

CREATE DATABASE IF NOT EXISTS fullstack_app;
USE fullstack_app;

-- ---------------------------------------------------------
-- Table: users
-- Stores sign-up details
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(100)  NOT NULL,
    age           INT           NOT NULL,
    address       VARCHAR(255)  NOT NULL,
    email         VARCHAR(120)  NOT NULL UNIQUE,
    mobile_number VARCHAR(15)   NOT NULL UNIQUE,
    password_hash VARCHAR(255)  NOT NULL,
    created_at    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- Table: uploaded_files
-- Stores metadata of files uploaded by logged-in users
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS uploaded_files (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    user_id       INT           NOT NULL,
    filename      VARCHAR(255)  NOT NULL,
    file_type     VARCHAR(10)   NOT NULL,
    upload_time   TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_uploaded_files_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE
) ENGINE=InnoDB;
