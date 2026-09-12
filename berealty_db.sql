DROP DATABASE IF EXISTS berealty_db;

CREATE DATABASE berealty_db;

USE berealty_db;

CREATE TABLE Agents (
    agent_id INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(60) NOT NULL,
    last_name VARCHAR(60) NOT NULL,
    email VARCHAR(120) NOT NULL,
    phone VARCHAR(30) NULL,
    hire_date DATE NOT NULL,
    license_number VARCHAR(50) NULL,
    default_commission_rate DECIMAL(5,2) NOT NULL,
    agent_status VARCHAR(20) NOT NULL,
    PRIMARY KEY (agent_id)
);

CREATE TABLE Clients (
    client_id INT NOT NULL AUTO_INCREMENT,
    client_kind VARCHAR(20) NOT NULL,
    first_name VARCHAR(60) NULL,
    last_name VARCHAR(60) NULL,
    company_name VARCHAR(120) NULL,
    email VARCHAR(120) NOT NULL,
    phone VARCHAR(30) NULL,
    address_line VARCHAR(150) NULL,
    city VARCHAR(80) NULL,
    postal_code VARCHAR(15) NULL,
    registration_date DATE NOT NULL,
    client_status VARCHAR(20) NOT NULL,
    PRIMARY KEY (client_id)
);

CREATE TABLE Property_Types (
    property_type_id INT NOT NULL AUTO_INCREMENT,
    category VARCHAR(30) NOT NULL,
    type_name VARCHAR(80) NOT NULL,
    description VARCHAR(255) NULL,
    PRIMARY KEY (property_type_id)
);

CREATE TABLE Properties (
    property_id INT NOT NULL AUTO_INCREMENT,
    property_type_id INT NOT NULL,
    street_address VARCHAR(150) NOT NULL,
    district VARCHAR(80) NULL,
    city VARCHAR(80) NOT NULL,
    postal_code VARCHAR(15) NOT NULL,
    area_sqm DECIMAL(10,2) NOT NULL,
    bedrooms INT NULL,
    bathrooms INT NULL,
    year_built INT NULL,
    current_status VARCHAR(30) NOT NULL,
    description TEXT NULL,
    PRIMARY KEY (property_id),
    CONSTRAINT fk_properties_property_type
        FOREIGN KEY (property_type_id)
        REFERENCES Property_Types(property_type_id)
);

CREATE TABLE Property_Ownership (
    property_id INT NOT NULL,
    client_id INT NOT NULL,
    ownership_start_date DATE NOT NULL,
    ownership_end_date DATE NULL,
    ownership_percentage DECIMAL(5,2) NOT NULL,
    PRIMARY KEY (
        property_id,
        client_id,
        ownership_start_date
    ),
    CONSTRAINT fk_ownership_property
        FOREIGN KEY (property_id)
        REFERENCES Properties(property_id),
    CONSTRAINT fk_ownership_client
        FOREIGN KEY (client_id)
        REFERENCES Clients(client_id)
);

CREATE TABLE Client_Requirements (
    requirement_id INT NOT NULL AUTO_INCREMENT,
    client_id INT NOT NULL,
    property_type_id INT NOT NULL,
    transaction_preference VARCHAR(20) NOT NULL,
    budget_min DECIMAL(15,2) NULL,
    budget_max DECIMAL(15,2) NULL,
    preferred_district VARCHAR(80) NULL,
    minimum_area_sqm DECIMAL(10,2) NULL,
    bedrooms_required INT NULL,
    requirement_status VARCHAR(20) NOT NULL,
    created_date DATE NOT NULL,
    PRIMARY KEY (requirement_id),
    CONSTRAINT fk_requirement_client
        FOREIGN KEY (client_id)
        REFERENCES Clients(client_id),
    CONSTRAINT fk_requirement_property_type
        FOREIGN KEY (property_type_id)
        REFERENCES Property_Types(property_type_id)
);

CREATE TABLE Listings (
    listing_id INT NOT NULL AUTO_INCREMENT,
    property_id INT NOT NULL,
    agent_id INT NOT NULL,
    listing_type VARCHAR(20) NOT NULL,
    asking_price DECIMAL(15,2) NOT NULL,
    listing_date DATE NOT NULL,
    available_from DATE NULL,
    listing_status VARCHAR(20) NOT NULL,
    description TEXT NULL,
    PRIMARY KEY (listing_id),
    CONSTRAINT fk_listing_property
        FOREIGN KEY (property_id)
        REFERENCES Properties(property_id),
    CONSTRAINT fk_listing_agent
        FOREIGN KEY (agent_id)
        REFERENCES Agents(agent_id)
);

CREATE TABLE Transactions (
    transaction_id INT NOT NULL AUTO_INCREMENT,
    listing_id INT NOT NULL,
    agent_id INT NOT NULL,
    transaction_date DATE NOT NULL,
    transaction_amount DECIMAL(15,2) NOT NULL,
    applied_commission_rate DECIMAL(5,2) NOT NULL,
    commission_amount DECIMAL(15,2) NOT NULL,
    transaction_status VARCHAR(20) NOT NULL,
    notes TEXT NULL,
    PRIMARY KEY (transaction_id),
    CONSTRAINT fk_transaction_listing
        FOREIGN KEY (listing_id)
        REFERENCES Listings(listing_id),
    CONSTRAINT fk_transaction_agent
        FOREIGN KEY (agent_id)
        REFERENCES Agents(agent_id)
);

CREATE TABLE Transaction_Parties (
    transaction_id INT NOT NULL,
    client_id INT NOT NULL,
    party_role VARCHAR(20) NOT NULL,
    PRIMARY KEY (
        transaction_id,
        client_id,
        party_role
    ),
    CONSTRAINT fk_transaction_party_transaction
        FOREIGN KEY (transaction_id)
        REFERENCES Transactions(transaction_id),
    CONSTRAINT fk_transaction_party_client
        FOREIGN KEY (client_id)
        REFERENCES Clients(client_id)
);

CREATE TABLE Leases (
    lease_id INT NOT NULL AUTO_INCREMENT,
    transaction_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    monthly_rent DECIMAL(12,2) NOT NULL,
    security_deposit DECIMAL(12,2) NOT NULL,
    payment_due_day INT NOT NULL,
    lease_status VARCHAR(20) NOT NULL,
    PRIMARY KEY (lease_id),
    UNIQUE (transaction_id),
    CONSTRAINT fk_lease_transaction
        FOREIGN KEY (transaction_id)
        REFERENCES Transactions(transaction_id)
);

CREATE TABLE Payments (
    payment_id INT NOT NULL AUTO_INCREMENT,
    lease_id INT NOT NULL,
    due_date DATE NOT NULL,
    payment_date DATE NULL,
    amount_due DECIMAL(12,2) NOT NULL,
    amount_paid DECIMAL(12,2) NOT NULL,
    payment_type VARCHAR(20) NOT NULL,
    payment_method VARCHAR(30) NULL,
    payment_status VARCHAR(20) NOT NULL,
    PRIMARY KEY (payment_id),
    CONSTRAINT fk_payment_lease
        FOREIGN KEY (lease_id)
        REFERENCES Leases(lease_id)
);

CREATE TABLE Maintenance_Requests (
    maintenance_id INT NOT NULL AUTO_INCREMENT,
    property_id INT NOT NULL,
    reported_by_client_id INT NULL,
    reported_date DATE NOT NULL,
    description TEXT NOT NULL,
    priority VARCHAR(20) NOT NULL,
    maintenance_status VARCHAR(30) NOT NULL,
    cost DECIMAL(12,2) NOT NULL,
    resolved_date DATE NULL,
    PRIMARY KEY (maintenance_id),
    CONSTRAINT fk_maintenance_property
        FOREIGN KEY (property_id)
        REFERENCES Properties(property_id),
    CONSTRAINT fk_maintenance_client
        FOREIGN KEY (reported_by_client_id)
        REFERENCES Clients(client_id)
);
----------------------------------------------------------------
INSERTING VALUES
----------------------------------------------------------------

INSERT INTO Agents
(agent_id, first_name, last_name, email, phone, hire_date, license_number,
 default_commission_rate, agent_status)
VALUES
(1, 'Daniel', 'Krause', 'daniel.krause@berealty.de', '030-5551001',
 '2022-03-15', 'BR-A001', 3.00, 'ACTIVE'),

(2, 'Laura', 'Neumann', 'laura.neumann@berealty.de', '030-5551002',
 '2021-07-01', 'BR-A002', 4.00, 'ACTIVE'),

(3, 'Felix', 'Wagner', 'felix.wagner@berealty.de', '030-5551003',
 '2023-01-10', 'BR-A003', 3.50, 'ACTIVE'),

(4, 'Nina', 'Hoffmann', 'nina.hoffmann@berealty.de', '030-5551004',
 '2020-11-20', 'BR-A004', 3.00, 'ACTIVE'),

(5, 'Emre', 'Demir', 'emre.demir@berealty.de', '030-5551005',
 '2024-02-01', 'BR-A005', 4.00, 'ACTIVE'),

(6, 'Sarah', 'Klein', 'sarah.klein@berealty.de', NULL,
 '2026-01-15', 'BR-A006', 3.00, 'ACTIVE');


INSERT INTO Clients
(client_id, client_kind, first_name, last_name, company_name,
 email, phone, address_line, city, postal_code,
 registration_date, client_status)
VALUES
(1, 'INDIVIDUAL', 'Anna', 'Weber', NULL,
 'anna.weber@email.de', '0171-1000001',
 'Rosenweg 14', 'Berlin', '10115',
 '2024-10-12', 'ACTIVE'),

(2, 'INDIVIDUAL', 'Lukas', 'Schneider', NULL,
 'lukas.schneider@email.de', '0171-1000002',
 'Parkstrasse 31', 'Berlin', '10557',
 '2025-01-02', 'ACTIVE'),

(3, 'INDIVIDUAL', 'Aisha', 'Khan', NULL,
 'aisha.khan@email.de', '0171-1000003',
 NULL, 'Berlin', '12043',
 '2025-04-10', 'ACTIVE'),

(4, 'INDIVIDUAL', 'Markus', 'Vogel', NULL,
 'markus.vogel@email.de', '0171-1000004',
 'Birkenweg 8', 'Berlin', '12165',
 '2024-06-18', 'ACTIVE'),

(5, 'COMPANY', NULL, NULL, 'Berlin Tech GmbH',
 'property@berlintech.de', '030-6002001',
 'Innovationsallee 12', 'Berlin', '10623',
 '2025-06-22', 'ACTIVE'),

(6, 'INDIVIDUAL', 'Sofia', 'Rossi', NULL,
 'sofia.rossi@email.de', '0171-1000006',
 'Lindenstrasse 18', 'Berlin', '10969',
 '2025-12-14', 'ACTIVE'),

(7, 'INDIVIDUAL', 'David', 'Fischer', NULL,
 'david.fischer@email.de', '0171-1000007',
 'Weserstrasse 71', 'Berlin', '12045',
 '2024-08-08', 'ACTIVE'),

(8, 'COMPANY', NULL, NULL, 'GreenHaus GmbH',
 'office@greenhaus.de', '030-6002002',
 'Kantstrasse 55', 'Berlin', '10627',
 '2024-02-15', 'ACTIVE'),

(9, 'INDIVIDUAL', 'Elena', 'Petrova', NULL,
 'elena.petrova@email.de', '0171-1000009',
 NULL, 'Berlin', '10437',
 '2026-01-20', 'ACTIVE'),

(10, 'COMPANY', NULL, NULL, 'NorthStar Retail GmbH',
 'realestate@northstar.de', '030-6002003',
 'Alexanderplatz 4', 'Berlin', '10178',
 '2025-08-18', 'ACTIVE'),

(11, 'INDIVIDUAL', 'Jonas', 'Becker', NULL,
 'jonas.becker@email.de', '0171-1000011',
 'Clayallee 110', 'Berlin', '14195',
 '2024-05-03', 'ACTIVE'),

(12, 'INDIVIDUAL', 'Mia', 'Hoffmann', NULL,
 'mia.hoffmann@email.de', '0171-1000012',
 NULL, 'Berlin', '10245',
 '2026-02-22', 'ACTIVE');


INSERT INTO Property_Types
(property_type_id, category, type_name, description)
VALUES
(1, 'RESIDENTIAL', 'Apartment',
 'Residential apartment'),

(2, 'RESIDENTIAL', 'House',
 'Detached or semi-detached house'),

(3, 'RESIDENTIAL', 'Residential Plot',
 'Land intended for residential construction'),

(4, 'COMMERCIAL', 'Office',
 'Commercial office space'),

(5, 'COMMERCIAL', 'Retail',
 'Retail or commercial shop unit'),

(6, 'COMMERCIAL', 'Warehouse',
 'Warehouse and logistics property'),

(7, 'COMMERCIAL', 'Commercial Plot',
 'Land intended for commercial development');


INSERT INTO Properties
(property_id, property_type_id, street_address, district,
 city, postal_code, area_sqm, bedrooms, bathrooms,
 year_built, current_status, description)
VALUES
(1, 1, 'Musterstrasse 21', 'Mitte',
 'Berlin', '10115', 82.50, 3, 1,
 2015, 'SOLD',
 'Modern apartment close to central Berlin'),

(2, 2, 'Ahornweg 8', 'Steglitz',
 'Berlin', '12169', 145.00, 4, 2,
 2008, 'RENTED',
 'Family house with garden'),

(3, 4, 'Kantallee 45', 'Charlottenburg',
 'Berlin', '10625', 220.00, NULL, NULL,
 2018, 'RENTED',
 'Modern commercial office space'),

(4, 5, 'Oranienstrasse 88', 'Kreuzberg',
 'Berlin', '10969', 160.00, NULL, 2,
 2012, 'SOLD',
 'Street-facing retail property'),

(5, 6, 'Industrieweg 17', 'Tempelhof',
 'Berlin', '12099', 720.00, NULL, 2,
 2004, 'AVAILABLE',
 'Warehouse with loading area'),

(6, 1, 'Sonnenallee 115', 'Neukoelln',
 'Berlin', '12045', 68.00, 2, 1,
 2010, 'SOLD',
 'Two-bedroom apartment'),

(7, 1, 'Kollwitzweg 11', 'Prenzlauer Berg',
 'Berlin', '10405', 95.00, 3, 2,
 2017, 'RENTED',
 'Three-bedroom premium apartment'),

(8, 7, 'Gewerbeallee 30', 'Marzahn',
 'Berlin', '12681', 1250.00, NULL, NULL,
 NULL, 'AVAILABLE',
 'Commercial development plot'),

(9, 2, 'Waldweg 24', 'Zehlendorf',
 'Berlin', '14167', 190.00, 5, 3,
 2001, 'AVAILABLE',
 'Large detached house'),

(10, 1, 'Boxhagener Weg 42', 'Friedrichshain',
 'Berlin', '10245', 74.00, 2, 1,
 2019, 'RENTED',
 'Modern apartment near Boxhagener Platz');


INSERT INTO Property_Ownership
(property_id, client_id, ownership_start_date,
 ownership_end_date, ownership_percentage)
VALUES
(1, 1, '2018-05-01', '2025-03-05', 100.00),
(1, 2, '2025-03-05', NULL, 100.00),

(2, 4, '2012-09-15', NULL, 100.00),

(3, 8, '2019-04-10', NULL, 100.00),

(4, 11, '2015-02-01', '2025-11-28', 100.00),
(4, 10, '2025-11-28', NULL, 100.00),

(5, 8, '2010-06-22', NULL, 100.00),

(6, 7, '2016-11-01', '2026-02-14', 100.00),
(6, 6, '2026-02-14', NULL, 100.00),

(7, 1, '2020-03-01', NULL, 60.00),
(7, 4, '2020-03-01', NULL, 40.00),

(8, 8, '2017-07-15', NULL, 100.00),

(9, 11, '2006-08-01', NULL, 100.00),

(10, 7, '2020-09-01', NULL, 100.00);


INSERT INTO Client_Requirements
(requirement_id, client_id, property_type_id,
 transaction_preference, budget_min, budget_max,
 preferred_district, minimum_area_sqm,
 bedrooms_required, requirement_status, created_date)
VALUES
(1, 2, 1, 'PURCHASE',
 350000, 520000, 'Mitte',
 70, 2, 'MATCHED', '2025-01-05'),

(2, 3, 2, 'RENT',
 1800, 2800, 'Steglitz',
 100, 3, 'MATCHED', '2025-04-15'),

(3, 5, 4, 'RENT',
 4000, 6500, 'Charlottenburg',
 180, NULL, 'MATCHED', '2025-06-25'),

(4, 6, 1, 'PURCHASE',
 300000, 420000, 'Neukoelln',
 60, 2, 'MATCHED', '2026-01-05'),

(5, 9, 1, 'RENT',
 1400, 2100, 'Prenzlauer Berg',
 70, 2, 'MATCHED', '2026-01-25'),

(6, 10, 5, 'PURCHASE',
 600000, 850000, 'Kreuzberg',
 120, NULL, 'MATCHED', '2025-08-22'),

(7, 12, 1, 'RENT',
 1500, 2300, 'Friedrichshain',
 60, 2, 'MATCHED', '2026-02-28'),

(8, 12, 7, 'PURCHASE',
 900000, 1300000, 'Marzahn',
 900, NULL, 'ACTIVE', '2026-06-10');


INSERT INTO Listings
(listing_id, property_id, agent_id,
 listing_type, asking_price, listing_date,
 available_from, listing_status, description)
VALUES
(1, 1, 1, 'SALE',
 495000, '2025-01-10', '2025-02-01',
 'CLOSED', 'Apartment offered for sale'),

(2, 2, 2, 'RENT',
 2400, '2025-04-20', '2025-07-01',
 'CLOSED', 'Family house available for rent'),

(3, 3, 3, 'RENT',
 5200, '2025-07-01', '2025-10-01',
 'CLOSED', 'Commercial office available for rent'),

(4, 4, 4, 'SALE',
 780000, '2025-08-10', '2025-10-01',
 'CLOSED', 'Retail unit offered for sale'),

(5, 5, 2, 'RENT',
 8500, '2026-01-15', '2026-03-01',
 'ACTIVE', 'Warehouse available for commercial rent'),

(6, 6, 1, 'SALE',
 365000, '2026-01-08', '2026-02-01',
 'CLOSED', 'Apartment offered for sale'),

(7, 7, 5, 'RENT',
 1850, '2026-02-10', '2026-04-01',
 'CLOSED', 'Apartment available for long-term rent'),

(8, 8, 3, 'SALE',
 1200000, '2026-05-05', '2026-06-01',
 'PENDING', 'Commercial development plot'),

(9, 9, 4, 'SALE',
 910000, '2026-03-15', '2026-04-01',
 'ACTIVE', 'Detached house for sale'),

(10, 10, 5, 'RENT',
 2100, '2026-06-01', '2026-09-01',
 'CLOSED', 'Apartment available for rent');


INSERT INTO Transactions
(transaction_id, listing_id, agent_id,
 transaction_date, transaction_amount,
 applied_commission_rate, commission_amount,
 transaction_status, notes)
VALUES
(1, 1, 1,
 '2025-03-05', 480000,
 3.00, 14400,
 'COMPLETED', 'Residential property sale completed'),

(2, 2, 2,
 '2025-06-20', 28800,
 4.00, 1152,
 'COMPLETED', 'Residential rental agreement completed'),

(3, 3, 3,
 '2025-09-15', 62400,
 3.50, 2184,
 'COMPLETED', 'Commercial office rental completed'),

(4, 4, 4,
 '2025-11-28', 760000,
 3.00, 22800,
 'COMPLETED', 'Retail property sale completed'),

(5, 6, 1,
 '2026-02-14', 350000,
 3.00, 10500,
 'COMPLETED', 'Apartment sale completed'),

(6, 7, 5,
 '2026-04-03', 22200,
 4.00, 888,
 'COMPLETED', 'Residential rental completed'),

(7, 8, 3,
 '2026-07-21', 1180000,
 3.00, 35400,
 'PENDING', 'Commercial land transaction under negotiation'),

(8, 10, 5,
 '2026-08-10', 25200,
 4.00, 1008,
 'COMPLETED', 'Residential rental completed'),

(9, 9, 4,
 '2026-05-12', 890000,
 3.00, 26700,
 'CANCELLED', 'Buyer withdrew from transaction');


INSERT INTO Transaction_Parties
(transaction_id, client_id, party_role)
VALUES
(1, 2, 'BUYER'),
(1, 1, 'SELLER'),

(2, 3, 'TENANT'),
(2, 4, 'LANDLORD'),

(3, 5, 'TENANT'),
(3, 8, 'LANDLORD'),

(4, 10, 'BUYER'),
(4, 11, 'SELLER'),

(5, 6, 'BUYER'),
(5, 7, 'SELLER'),

(6, 9, 'TENANT'),
(6, 1, 'LANDLORD'),
(6, 4, 'LANDLORD'),

(7, 12, 'BUYER'),
(7, 8, 'SELLER'),

(8, 12, 'TENANT'),
(8, 7, 'LANDLORD'),

(9, 2, 'BUYER'),
(9, 11, 'SELLER');


INSERT INTO Leases
(lease_id, transaction_id, start_date, end_date,
 monthly_rent, security_deposit,
 payment_due_day, lease_status)
VALUES
(1, 2,
 '2025-07-01', '2027-06-30',
 2400, 4800, 1, 'ACTIVE'),

(2, 3,
 '2025-10-01', '2028-09-30',
 5200, 10400, 1, 'ACTIVE'),

(3, 6,
 '2026-04-01', '2027-03-31',
 1850, 3700, 1, 'ACTIVE'),

(4, 8,
 '2026-09-01', '2027-08-31',
 2100, 4200, 1, 'ACTIVE');


INSERT INTO Payments
(payment_id, lease_id, due_date,
 payment_date, amount_due, amount_paid,
 payment_type, payment_method, payment_status)
VALUES
(1, 1,
 '2026-06-01', '2026-06-01',
 2400, 2400,
 'RENT', 'BANK_TRANSFER', 'PAID'),

(2, 1,
 '2026-07-01', '2026-07-03',
 2400, 2400,
 'RENT', 'BANK_TRANSFER', 'PAID'),

(3, 1,
 '2026-08-01', NULL,
 2400, 1200,
 'RENT', 'BANK_TRANSFER', 'PARTIAL'),

(4, 2,
 '2026-06-01', '2026-06-01',
 5200, 5200,
 'RENT', 'BANK_TRANSFER', 'PAID'),

(5, 2,
 '2026-07-01', '2026-07-01',
 5200, 5200,
 'RENT', 'BANK_TRANSFER', 'PAID'),

(6, 2,
 '2026-08-01', NULL,
 5200, 0,
 'RENT', NULL, 'PENDING'),

(7, 3,
 '2026-06-01', '2026-06-02',
 1850, 1850,
 'RENT', 'BANK_TRANSFER', 'PAID'),

(8, 3,
 '2026-07-01', '2026-07-01',
 1850, 1850,
 'RENT', 'BANK_TRANSFER', 'PAID'),

(9, 3,
 '2026-08-01', '2026-08-05',
 1850, 1850,
 'RENT', 'BANK_TRANSFER', 'PAID'),

(10, 4,
 '2026-09-01', '2026-09-01',
 4200, 4200,
 'DEPOSIT', 'BANK_TRANSFER', 'PAID'),

(11, 4,
 '2026-09-01', NULL,
 2100, 0,
 'RENT', NULL, 'PENDING');


INSERT INTO Maintenance_Requests
(maintenance_id, property_id, reported_by_client_id,
 reported_date, description, priority,
 maintenance_status, cost, resolved_date)
VALUES
(1, 2, 3,
 '2026-02-10',
 'Heating system not functioning correctly',
 'HIGH', 'RESOLVED',
 480, '2026-02-12'),

(2, 3, 5,
 '2026-03-18',
 'Air conditioning requires servicing',
 'MEDIUM', 'RESOLVED',
 650, '2026-03-23'),

(3, 7, 9,
 '2026-05-06',
 'Water leakage under kitchen sink',
 'HIGH', 'RESOLVED',
 220, '2026-05-07'),

(4, 5, NULL,
 '2026-06-12',
 'Warehouse loading door requires repair',
 'MEDIUM', 'IN_PROGRESS',
 900, NULL),

(5, 10, 12,
 '2026-09-03',
 'Bathroom ventilation system not working',
 'LOW', 'OPEN',
 0, NULL),

(6, 2, 3,
 '2026-08-20',
 'Garden fence damaged',
 'LOW', 'OPEN',
 0, NULL);
---------------------------------------------------------------------------------------
INSERTED VALUES CHECKING IF UPLOADED
---------------------------------------------------------------------------------------
SELECT * FROM Agents;
SELECT * FROM Clients;
SELECT * FROM Property_Types;
SELECT * FROM Properties;
SELECT * FROM Property_Ownership;
SELECT * FROM Client_Requirements;
SELECT * FROM Listings;
SELECT * FROM Transactions;
SELECT * FROM Transaction_Parties;
SELECT * FROM Leases;
SELECT * FROM Payments;
SELECT * FROM Maintenance_Requests;
--------------------------------------------------------------------------------------------
LO2/LO3
--------------------------------------------------------------------------------------------
--1--
SELECT 
    p.property_id,
    pt.category,
    pt.type_name,
    p.street_address,
    p.district,
    p.area_sqm,
    p.current_status
FROM Properties p
INNER JOIN Property_Types pt
    ON p.property_type_id = pt.property_type_id
WHERE p.current_status = 'AVAILABLE';
--2--
SELECT
    t.transaction_id,
    CONCAT(a.first_name, ' ', a.last_name) AS agent_name,
    t.transaction_date,
    t.transaction_amount,
    t.commission_amount,
    t.transaction_status
FROM Transactions t
INNER JOIN Agents a
    ON t.agent_id = a.agent_id
ORDER BY t.transaction_date;
--3--
SELECT
    t.transaction_id,
    COALESCE(
        c.company_name,
        CONCAT(c.first_name, ' ', c.last_name)
    ) AS client_name,
    tp.party_role,
    l.listing_type,
    t.transaction_amount,
    t.transaction_status
FROM Transactions t
INNER JOIN Transaction_Parties tp
    ON t.transaction_id = tp.transaction_id
INNER JOIN Clients c
    ON tp.client_id = c.client_id
INNER JOIN Listings l
    ON t.listing_id = l.listing_id
ORDER BY t.transaction_id;
--4--
SELECT
    p.property_id,
    p.street_address,
    p.current_status,
    l.listing_id,
    l.listing_type,
    l.asking_price,
    l.listing_status
FROM Properties p
LEFT JOIN Listings l
    ON p.property_id = l.property_id
ORDER BY p.property_id;
--5--
SELECT
    a.agent_id,
    CONCAT(a.first_name, ' ', a.last_name) AS agent_name,
    t.transaction_id,
    t.transaction_amount,
    t.transaction_status
FROM Transactions t
RIGHT JOIN Agents a
    ON t.agent_id = a.agent_id
ORDER BY a.agent_id;
--6--
SELECT
    CONCAT(a.first_name, ' ', a.last_name) AS agent_name,
    pt.category,
    pt.type_name
FROM Agents a
CROSS JOIN Property_Types pt
WHERE a.agent_status = 'ACTIVE'
ORDER BY a.agent_id, pt.property_type_id;
--7--
SELECT
    a.agent_id,
    CONCAT(a.first_name, ' ', a.last_name) AS agent_name,
    COUNT(t.transaction_id) AS total_transactions,
    SUM(
        CASE 
            WHEN t.transaction_status = 'COMPLETED'
            THEN t.transaction_amount
            ELSE 0
        END
    ) AS completed_transaction_value,
    SUM(
        CASE 
            WHEN t.transaction_status = 'COMPLETED'
            THEN t.commission_amount
            ELSE 0
        END
    ) AS total_commission
FROM Agents a
LEFT JOIN Transactions t
    ON a.agent_id = t.agent_id
GROUP BY
    a.agent_id,
    a.first_name,
    a.last_name
ORDER BY total_commission DESC;
--8--
SELECT
    l.listing_id,
    p.street_address,
    l.listing_type,
    l.asking_price
FROM Listings l
INNER JOIN Properties p
    ON l.property_id = p.property_id
WHERE l.asking_price > (
    SELECT AVG(l2.asking_price)
    FROM Listings l2
    WHERE l2.listing_type = l.listing_type
)
ORDER BY l.asking_price DESC;
--9--
SELECT cr.requirement_id, COALESCE(c.company_name, CONCAT(c.first_name, ' ', c.last_name)) AS client_name,
    pt.type_name AS requested_property_type,
    cr.transaction_preference,
    cr.preferred_district,
    cr.budget_max,
    p.property_id,
    p.street_address,
    p.district,
    l.listing_type,
    l.asking_price
FROM Client_Requirements cr
INNER JOIN Clients c
    ON cr.client_id = c.client_id
INNER JOIN Property_Types pt
    ON cr.property_type_id = pt.property_type_id
INNER JOIN Properties p
    ON p.property_type_id = cr.property_type_id
INNER JOIN Listings l
    ON p.property_id = l.property_id
WHERE cr.requirement_status = 'ACTIVE'
AND l.listing_status IN ('ACTIVE', 'PENDING')
AND (
    (cr.transaction_preference = 'PURCHASE'
     AND l.listing_type = 'SALE')
    OR
    (cr.transaction_preference = 'RENT'
     AND l.listing_type = 'RENT')
)
AND (
    cr.budget_max IS NULL
    OR l.asking_price <= cr.budget_max
)
AND (
    cr.minimum_area_sqm IS NULL
    OR p.area_sqm >= cr.minimum_area_sqm
)
AND (
    cr.preferred_district IS NULL
    OR p.district = cr.preferred_district
)
AND (
    cr.bedrooms_required IS NULL
    OR p.bedrooms >= cr.bedrooms_required
)
ORDER BY cr.requirement_id;
--10 --
SELECT
    COALESCE(
        c.company_name,
        CONCAT(c.first_name, ' ', c.last_name)
    ) AS tenant_name,
    l.lease_id,
    p.due_date,
    p.amount_due,
    p.amount_paid,
    (p.amount_due - p.amount_paid) AS outstanding_balance,
    p.payment_status
FROM Payments p
INNER JOIN Leases l
    ON p.lease_id = l.lease_id
INNER JOIN Transactions t
    ON l.transaction_id = t.transaction_id
INNER JOIN Transaction_Parties tp
    ON t.transaction_id = tp.transaction_id
    AND tp.party_role = 'TENANT'
INNER JOIN Clients c
    ON tp.client_id = c.client_id
WHERE
    p.amount_paid < p.amount_due
ORDER BY p.due_date;
--11--
SELECT
    YEAR(transaction_date) AS year,
    MONTH(transaction_date) AS month,
    COUNT(transaction_id) AS number_of_transactions,
    SUM(transaction_amount) AS total_transaction_value,
    SUM(commission_amount) AS total_commission
FROM Transactions
WHERE transaction_status = 'COMPLETED'
GROUP BY
    YEAR(transaction_date),
    MONTH(transaction_date)
ORDER BY year, month;
--12--
SELECT
    YEAR(transaction_date) AS year,
    QUARTER(transaction_date) AS quarter,
    COUNT(transaction_id) AS number_of_transactions,
    SUM(transaction_amount) AS total_transaction_value,
    SUM(commission_amount) AS total_commission
FROM Transactions
WHERE transaction_status = 'COMPLETED'
GROUP BY
    YEAR(transaction_date),
    QUARTER(transaction_date)
ORDER BY year, quarter;
--13--
SELECT
    YEAR(transaction_date) AS year,
    COUNT(transaction_id) AS number_of_transactions,
    SUM(transaction_amount) AS total_transaction_value,
    SUM(commission_amount) AS total_commission,
    AVG(transaction_amount) AS average_transaction_value
FROM Transactions
WHERE transaction_status = 'COMPLETED'
GROUP BY YEAR(transaction_date)
ORDER BY year;
--14--
SELECT
    a.agent_id,
    CONCAT(a.first_name, ' ', a.last_name) AS agent_name,
    SUM(t.transaction_amount) AS agent_transaction_value
FROM Agents a
INNER JOIN Transactions t
    ON a.agent_id = t.agent_id
WHERE t.transaction_status = 'COMPLETED'
GROUP BY
    a.agent_id,
    a.first_name,
    a.last_name
HAVING SUM(t.transaction_amount) > (
    SELECT AVG(agent_total)
    FROM (
        SELECT
            SUM(transaction_amount) AS agent_total
        FROM Transactions
        WHERE transaction_status = 'COMPLETED'
        GROUP BY agent_id
    ) AS agent_totals
)
ORDER BY agent_transaction_value DESC;

--
DELIMITER //

CREATE TRIGGER trg_transaction_completed
AFTER UPDATE ON Transactions
FOR EACH ROW
BEGIN

    IF NEW.transaction_status = 'COMPLETED'
       AND OLD.transaction_status <> 'COMPLETED' THEN

        UPDATE Listings
        SET listing_status = 'CLOSED'
        WHERE listing_id = NEW.listing_id;

        UPDATE Properties p
        INNER JOIN Listings l
            ON p.property_id = l.property_id
        SET p.current_status =
            CASE
                WHEN l.listing_type = 'SALE'
                    THEN 'SOLD'
                WHEN l.listing_type = 'RENT'
                    THEN 'RENTED'
                ELSE p.current_status
            END
        WHERE l.listing_id = NEW.listing_id;

    END IF;

END//

DELIMITER ;

SHOW TRIGGERS;

SELECT
    t.transaction_id,
    t.transaction_status,
    l.listing_id,
    l.listing_type,
    l.listing_status,
    p.property_id,
    p.current_status
FROM Transactions t
INNER JOIN Listings l
    ON t.listing_id = l.listing_id
INNER JOIN Properties p
    ON l.property_id = p.property_id
WHERE t.transaction_id = 7;

START TRANSACTION;

UPDATE Transactions
SET transaction_status = 'COMPLETED'
WHERE transaction_id = 7;

SELECT
    t.transaction_id,
    t.transaction_status,
    l.listing_status,
    p.current_status
FROM Transactions t
INNER JOIN Listings l
    ON t.listing_id = l.listing_id
INNER JOIN Properties p
    ON l.property_id = p.property_id
WHERE t.transaction_id = 7;

ROLLBACK;