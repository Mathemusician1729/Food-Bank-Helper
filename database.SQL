CREATE DATABASE cellar_constitution_db;

CREATE TABLE contact (
    email VARCHAR(50),
    phone_number VARCHAR(20),
    name VARCHAR(50),
    address VARCHAR(50),
    email_opt_out BOOLEAN
);

CREATE TABLE internal_contact (
    internal_id INT NOT NULL PRIMARY KEY,
    email VARCHAR(50),
    phone_number VARCHAR(20),
    name VARCHAR(50),
    address VARCHAR(50),
    sha256sum VARCHAR(64),
    salt VARCHAR(32),
    FOREIGN KEY (email) REFERENCES contact(email),
    FOREIGN KEY (phone_number) REFERENCES contact(phone_number),
    FOREIGN KEY (name) REFERENCES contact(name),
    FOREIGN KEY (address) REFERENCES contact(address)
);

CREATE TABLE volunteer_task (
    task_name VARCHAR(50) NOT NULL PRIMARY KEY
);

CREATE TABLE volunteer_shift (
    task_name VARCHAR(50) NOT NULL,
    manager_id INT NOT NULL,
    date DATE NOT NULL,
    start_timestamp TIME NOT NULL,
    end_timestamp TIME NOT NULL,
    location VARCHAR(50) NOT NULL,
    PRIMARY KEY (task_name, manager_id, date, start_timestamp, end_timestamp, location),
    FOREIGN KEY (task_name) REFERENCES volunteer_task(task_name),
    FOREIGN KEY (manager_id) REFERENCES internal_contact(internal_id)
);

CREATE TABLE volunteer (
    internal_id INT NOT NULL PRIMARY KEY,
    hours_worked INT NOT NULL,
    supervisor_id INT NOT NULL,
    FOREIGN KEY (internal_id) REFERENCES internal_contact(internal_id),
    FOREIGN KEY (supervisor_id) REFERENCES staff(internal_id)
);

CREATE TABLE staff (
    internal_id INT NOT NULL PRIMARY KEY,
    salary DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (internal_id) REFERENCES internal_contact(internal_id)
);

CREATE TABLE admin (
    internal_id INT NOT NULL PRIMARY KEY,
    FOREIGN KEY (internal_id) REFERENCES staff(internal_id)
);

CREATE TABLE scheduled_for (
    v_id INT NOT NULL,
    task_name VARCHAR(50) NOT NULL,
    date DATE NOT NULL,
    start_timestamp TIME NOT NULL,
    end_timestamp TIME NOT NULL,
    location VARCHAR(50) NOT NULL,
    PRIMARY KEY (v_id, task_name, date, start_timestamp, end_timestamp, location),
    FOREIGN KEY (v_id) REFERENCES volunteer(internal_id),
    FOREIGN KEY (task_name) REFERENCES volunteer_task(task_name),
    FOREIGN KEY (date) REFERENCES volunteer_shift(date),
    FOREIGN KEY (start_timestamp) REFERENCES volunteer_shift(start_timestamp),
    FOREIGN KEY (end_timestamp) REFERENCES volunteer_shift(end_timestamp),
    FOREIGN KEY (location) REFERENCES volunteer_shift(location)
);

CREATE TABLE external_contact (
    external_id INT NOT NULL PRIMARY KEY,
    email VARCHAR(50),
    phone_number VARCHAR(20),
    name VARCHAR(50),
    address VARCHAR(50),
    FOREIGN KEY (email) REFERENCES contact(email),
    FOREIGN KEY (phone_number) REFERENCES contact(phone_number),
    FOREIGN KEY (name) REFERENCES contact(name),
    FOREIGN KEY (address) REFERENCES contact(address)
);

CREATE TABLE external_org (
    org_id INT NOT NULL PRIMARY KEY,
    org_name VARCHAR(50) NOT NULL,
    FOREIGN KEY (org_id) REFERENCES external_contact(external_id)
);

CREATE TABLE household (
    household_id INT NOT NULL PRIMARY KEY,
    household_size INT NOT NULL,
    FOREIGN KEY (household_id) REFERENCES external_org(org_id)
);

CREATE TABLE supplier (
    supplier_id INT NOT NULL PRIMARY KEY,
    FOREIGN KEY (supplier_id) REFERENCES external_contact(external_id)
);

CREATE TABLE monetary_donation (
    timestamp TIMESTAMP NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    donor_id INT NOT NULL,
    PRIMARY KEY (timestamp, donor_id),
    FOREIGN KEY (donor_id) REFERENCES donor(donor_id)
);

CREATE TABLE donor (
    donor_id INT NOT NULL PRIMARY KEY,
    FOREIGN KEY (donor_id) REFERENCES external_contact(external_id)
);

CREATE TABLE ext_id_surrogate_key (
    external_id INT NOT NULL PRIMARY KEY, 
    FOREIGN KEY (external_id) REFERENCES external_contact(external_id)
);

CREATE TABLE has_contacts_ext (
    org_external_id INT NOT NULL,
    contact_external_id INT NOT NULL,
    PRIMARY KEY (org_external_id, contact_external_id),
    FOREIGN KEY (org_external_id) REFERENCES external_org(org_id),
    FOREIGN KEY (contact_external_id) REFERENCES external_contact(external_id)
);

CREATE TABLE has_contacts_int (
    org_external_id INT NOT NULL,
    contact_internal_id INT NOT NULL,
    PRIMARY KEY (org_external_id, contact_internal_id),
    FOREIGN KEY (org_external_id) REFERENCES external_org(org_id),
    FOREIGN KEY (contact_internal_id) REFERENCES internal_contact(internal_id)
);

CREATE TABLE main_contact_ext (
    org_external_id INT NOT NULL,
    contact_external_id INT NOT NULL,
    PRIMARY KEY (org_external_id, contact_external_id),
    FOREIGN KEY (org_external_id) REFERENCES external_org(org_id),
    FOREIGN KEY (contact_external_id) REFERENCES external_contact(external_id)
);

CREATE TABLE main_contact_int (
    org_external_id INT NOT NULL,
    contact_internal_id INT NOT NULL,
    PRIMARY KEY (org_external_id, contact_internal_id),
    FOREIGN KEY (org_external_id) REFERENCES external_org(org_id),
    FOREIGN KEY (contact_internal_id) REFERENCES internal_contact(internal_id)
);

CREATE TABLE seller (
    seller_id INT NOT NULL PRIMARY KEY,
    FOREIGN KEY (seller_id) REFERENCES ext_id_surrogate_key(external_id)
);

CREATE TABLE item_donor (
    donor_id INT NOT NULL,
    FOREIGN KEY (donor_id) REFERENCES ext_id_surrogate_key(external_id)
);

CREATE TABLE item_purchased (
    seller_id INT NOT NULL,
    batch_id INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    date_purchased DATE NOT NULL,
    PRIMARY KEY (seller_id, batch_id),
    FOREIGN KEY (seller_id) REFERENCES seller(seller_id),
    FOREIGN KEY (batch_id) REFERENCES stored_item(batch_id)
);

CREATE TABLE item_donated (
    donor_id INT NOT NULL,
    batch_id INT NOT NULL,
    date_donated DATE NOT NULL,
    PRIMARY KEY (donor_id, batch_id),
    FOREIGN KEY (donor_id) REFERENCES item_donor(donor_id),
    FOREIGN KEY (batch_id) REFERENCES stored_item(batch_id)
);

CREATE TABLE storage_type (
    type_name VARCHAR(50) NOT NULL PRIMARY KEY,
    temperature DECIMAL(5, 2) NOT NULL
);

CREATE TABLE storage (
    storage_name VARCHAR(50) NOT NULL PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL,
    temperature DECIMAL(5, 2) NOT NULL,
    capacity INT NOT NULL,
    location VARCHAR(50),
    FOREIGN KEY (type_name) REFERENCES storage_type(type_name),
    FOREIGN KEY (temperature) REFERENCES storage_type(temperature)
);

CREATE TABLE stores (
    storage_name VARCHAR(50) NOT NULL,
    batch_id INT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (storage_name, batch_id),
    FOREIGN KEY (storage_name) REFERENCES storage(storage_type_name),
    FOREIGN KEY (batch_id) REFERENCES stored_item(batch_id)
);

CREATE TABLE item_type (
    type_name VARCHAR(50) NOT NULL PRIMARY KEY,
    unit_quantity VARCHAR(20) NOT NULL,
    perishable BOOLEAN NOT NULL,
    storage_type_name VARCHAR(50) NOT NULL,
    FOREIGN KEY (storage_type_name) REFERENCES storage_type(type_name)
);

CREATE TABLE nutr_val (
    item_type_name VARCHAR(50) NOT NULL,
    nutrition_value VARCHAR(50) NOT NULL,
    PRIMARY KEY (item_type_name, nutrition_value),
    FOREIGN KEY (item_type_name) REFERENCES item_type(type_name)
);

CREATE TABLE dietary_flags (
    item_type_name VARCHAR(50) NOT NULL,
    dietary_flag VARCHAR(50) NOT NULL,
    PRIMARY KEY (item_type_name, dietary_flag),
    FOREIGN KEY (item_type_name) REFERENCES item_type(type_name)
);

CREATE TABLE recipe (
    item_type_name VARCHAR(50) NOT NULL PRIMARY KEY,
    FOREIGN KEY (item_type_name) REFERENCES item_type(type_name)
);

CREATE TABLE ingredient_for (
    ingredient_name VARCHAR(50) NOT NULL,
    recipe_name VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (ingredient_name, recipe_name),
    FOREIGN KEY (ingredient_name) REFERENCES item_type(type_name),
    FOREIGN KEY (recipe_name) REFERENCES recipe(item_type_name)
);

CREATE TABLE stored_item (
    batch_id INT NOT NULL PRIMARY KEY,
    item_type_name VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    date_received DATE NOT NULL,
    FOREIGN KEY (item_type_name) REFERENCES item_type(type_name)
);

CREATE TABLE stored_food_item (
    batch_id INT NOT NULL PRIMARY KEY,
    item_type_name VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    date_recieved DATE NOT NULL,
    expiration_date DATE NOT NULL,
    FOREIGN KEY (batch_id) REFERENCES stored_item(batch_id),
    FOREIGN KEY (item_type_name) REFERENCES stored_item(item_type_name),
    FOREIGN KEY (quantity) REFERENCES stored_item(quantity),
    FOREIGN KEY (date_recieved) REFERENCES stored_item(date_received)
);

CREATE TABLE inventory_deduction (
    batch_id INT NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (batch_id, quantity),
    FOREIGN KEY (batch_id) REFERENCES stored_item(batch_id)
);

CREATE TABLE discarded_item (
    batch_id INT NOT NULL,
    quantity INT NOT NULL,
    reason VARCHAR(100) NOT NULL,
    PRIMARY KEY (batch_id, quantity),
    FOREIGN KEY (batch_id) REFERENCES inventory_deduction(batch_id),
    FOREIGN KEY (quantity) REFERENCES inventory_deduction(quantity)
);

CREATE TABLE distributed_item (
    batch_id INT NOT NULL,
    quantity INT NOT NULL,
    external_id INT NOT NULL,
    PRIMARY KEY (batch_id, quantity), 
    FOREIGN KEY (batch_id) REFERENCES inventory_deduction(batch_id),
    FOREIGN KEY (quantity) REFERENCES inventory_deduction(quantity),
    FOREIGN KEY (external_id) REFERENCES external_org(org_id)
);

CREATE TABLE used_in (
    batch_id INT NOT NULL,
    recipe_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (batch_id, recipe_name),
    FOREIGN KEY (batch_id) REFERENCES inventory_deduction(batch_id),
    FOREIGN KEY (recipe_name) REFERENCES recipe(item_type_name)
);