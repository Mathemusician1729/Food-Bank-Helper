CREATE DATABASE cellarconstitution;
USE cellarconstitution;

CREATE TABLE IF NOT EXISTS contact (
    email VARCHAR(50),
    phone_number VARCHAR(20),
    name VARCHAR(50),
    address VARCHAR(50),
    email_opt_out BOOLEAN
);

ALTER TABLE contact 
ADD PRIMARY KEY (email);

INSERT INTO contact (email, phone_number, name, address, email_opt_out)
VALUES ('pooper.gmail.com', '123-456-7890', 'poopyman', '123 strret', TRUE);

SELECT * FROM contact;

-- quick clear from all contacts
DELETE FROM contact;

-- describe scheme
DESCRIBE contact;