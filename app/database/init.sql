CREATE DATABASE IF NOT EXISTS quickbite;

USE quickbite;

CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    food_item VARCHAR(100) NOT NULL,
    status VARCHAR(50) DEFAULT 'PLACED'
);

INSERT INTO orders (customer_name, food_item, status)
VALUES ('QuickBite Customer', 'Pizza', 'PLACED');
