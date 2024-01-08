CREATE DATABASE bepresent;
USE bepresent;

CREATE TABLE app_user (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username varchar(255),
    password varchar(255),
    email varchar(255),
    money INT
);

CREATE TABLE inventory (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    category varchar(255),
    name varchar(255),
    imagepath varchar(255),
    cost INT,
    postop INT,
    posleft INT,
    possize INT,
    top_ingame INT,
    left_ingame INT,
    FOREIGN KEY (user_id) REFERENCES app_user(id) ON DELETE CASCADE
);

CREATE TABLE contacts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    name varchar(255),
    phonenumber varchar (255),
    FOREIGN KEY (user_id) REFERENCES app_user(id) ON DELETE CASCADE
);
