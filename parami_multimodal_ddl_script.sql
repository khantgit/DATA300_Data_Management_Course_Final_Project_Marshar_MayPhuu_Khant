CREATE TABLE Users (
    user_id VARCHAR(5) PRIMARY KEY, -- Format: U001
    person_type VARCHAR(15) NOT NULL 
	  CHECK (person_type IN ('Student', 'Faculty', 'Management', 'Staff', 'Guest')),
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    ph_number VARCHAR(20),
    address TEXT
);

CREATE TABLE Staff (
    staff_id VARCHAR(6) PRIMARY KEY, -- Format: S001
    position VARCHAR(15),
    email TEXT NOT NULL,
    first_name VARCHAR(15) NOT NULL,
    last_name VARCHAR(15) NOT NULL,
    address TEXT
);

CREATE TABLE Resources_category (
    category_id VARCHAR(5) PRIMARY KEY, -- Format: C001
    category_name TEXT NOT NULL
);

-- 2. DEPENDENT TABLES

CREATE TABLE Resources (
    resource_id VARCHAR(5) PRIMARY KEY, -- Format: R001
    category_id VARCHAR(5) NOT NULL,
    available_quantity INT NOT NULL DEFAULT 0,
    condition_status VARCHAR(15) NOT NULL 
	  CHECK (condition_status IN ('Excellent', 'Good', 'Fair', 'Error')),
    resource_name TEXT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Resources_category(category_id) 
      ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Request (
    request_id VARCHAR(6) PRIMARY KEY, -- Format: RE001
    user_id VARCHAR(5) NOT NULL,
    resource_id VARCHAR(5) NOT NULL,
    staff_id VARCHAR(6), 
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    approved_date TIMESTAMP,
    due_date TIMESTAMP,
    request_status VARCHAR(15) NOT NULL DEFAULT 'PENDING' 
	  CHECK (request_status IN ('APPROVED', 'PENDING', 'DECLINED')),
    request_quantity INT NOT NULL DEFAULT 1,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) 
	  ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id) 
	  ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (resource_id) REFERENCES Resources(resource_id) 
	  ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Check_out (
    check_out_id VARCHAR(5) PRIMARY KEY, -- Format: CK001
    staff_id VARCHAR(6) NOT NULL,
    request_id VARCHAR(6) NOT NULL,
    user_id VARCHAR(5) NOT NULL,
    checkout_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id) 
	  ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (request_id) REFERENCES Request(request_id) 
	  ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) 
	  ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Return (
    return_id VARCHAR(15) PRIMARY KEY, -- Format: RT001
    check_out_id VARCHAR(5) NOT NULL,
    staff_id VARCHAR(6) NOT NULL, 
    due_date TIMESTAMP,
    return_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    return_condition VARCHAR(15) NOT NULL 
	  CHECK (return_condition IN ('Excellent', 'Good', 'Fair', 'Error')),
    overdue_status VARCHAR(5) NOT NULL DEFAULT 'NO' 
	  CHECK (overdue_status IN ('YES', 'NO')),
    FOREIGN KEY (check_out_id) REFERENCES Check_out(check_out_id) 
	  ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id) 
	  ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE Fine (
    fine_id VARCHAR(5) PRIMARY KEY, -- Format: F001
    return_id VARCHAR(15) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00, 
    FOREIGN KEY (return_id) REFERENCES Return(return_id) 
	  ON UPDATE CASCADE ON DELETE CASCADE
);

-- Data Insertion

INSERT INTO Staff 
(staff_id, position, email, first_name, last_name, address) 
VALUES
('S001', 'Head Librarian', 'daw.ni.ni@parami.edu', 'Ni Ni', 'Win', '12 Inya Road, Yangon'),
('S002', 'IT Coordinator', 'alex.kyaw@parami.edu', 'Alex', 'Kyaw', '44 Baho Road, Sanchaung'),
('S003', 'Admin Officer', 'su.myat@parami.edu', 'Su', 'Myat', '78 Insein Road, Kamayut'),
('S004', 'Tech Support', 'zaw.htet@parami.edu', 'Zaw', 'Htet', '12 Pyay Road, Hlaing'),
('S005', 'Student Asst', 'thida.student@parami.edu', 'Thida', 'Aye', 'Parami Campus Dorm A'),
('S006', 'Library Asst', 'min.thant@parami.edu', 'Min', 'Thant', '88 Kabar Aye Pagoda Rd'),
('S007', 'Manager', 'sarah.c@parami.edu', 'Sarah', 'Connor', 'Star City, Thanlyin'),
('S008', 'IT Support', 'hein.min@parami.edu', 'Hein', 'Min', 'North Dagon Ext'),
('S009', 'Academic Off', 'dr.james@parami.edu', 'James', 'Smith', 'Golden Valley, Bahan'),
('S010', 'Intern', 'ei.ei@student.parami.edu', 'Ei', 'Ei', 'South Okkalapa');

INSERT INTO Resources_category 
(category_id, category_name) 
VALUES 
('C001', 'Hardware: Laptops & Tablets'),
('C002', 'Hardware: Cameras & Audio'),
('C003', 'Digital: Learning Platforms'),
('C004', 'Digital: Software Licenses'),
('C005', 'Academic: Textbooks & Journals'),
('C006', 'Accessories: Cables & Chargers');

INSERT INTO Users 
(user_id, person_type, first_name, last_name, email, ph_number, address) 
VALUES
('U001', 'Student', 'Aung', 'Ko Ko', 'aung.koko@stu.parami.edu', '09111111111', 'Hledan'),
('U002', 'Student', 'Aye', 'Thandar', 'aye.thandar@stu.parami.edu', '09222222222', 'Sanchaung'),
('U003', 'Student', 'Phone', 'Pyae', 'phone.pyae@stu.parami.edu', '09333333333', 'Tamwe'),
('U004', 'Student', 'Yoon', 'Nadi', 'yoon.nadi@stu.parami.edu', '09444444444', 'Yankin'),
('U005', 'Student', 'Htet', 'Htet', 'htet.htet@stu.parami.edu', '09555555555', 'Insein'),
('U006', 'Student', 'Kyaw', 'Zin', 'kyaw.zin@stu.parami.edu', '09666666666', 'North Dagon'),
('U007', 'Student', 'Nang', 'Hom', 'nang.hom@stu.parami.edu', '09777777777', 'South Okkalapa'),
('U008', 'Student', 'Sai', 'Sai', 'sai.sai@stu.parami.edu', '09888888888', 'Thingangyun'),
('U009', 'Student', 'Ei', 'Phyu', 'ei.phyu@stu.parami.edu', '09999999999', 'Kamayut'),
('U010', 'Student', 'Min', 'Khant', 'min.khant@stu.parami.edu', '09101010101', 'Hlaing'),
('U011', 'Faculty', 'Dr. Peter', 'Parker', 'peter.p@parami.edu', '09202020202', 'Bahan'),
('U012', 'Faculty', 'Prof. Mary', 'Jane', 'mary.j@parami.edu', '09303030303', 'Downtown'),
('U013', 'Faculty', 'U Hla', 'Myint', 'hla.myint@parami.edu', '09404040404', 'Mayangone'),
('U014', 'Faculty', 'Daw Khin', 'May', 'khin.may@parami.edu', '09505050505', 'Thaketa'),
('U015', 'Faculty', 'John', 'Doe', 'john.doe@parami.edu', '09606060606', '7 Mile'),
('U016', 'Student', 'Thura', 'Aung', 'thura.aung@stu.parami.edu', '09717171717', '8 Mile'),
('U017', 'Student', 'Nilar', 'Win', 'nilar.win@stu.parami.edu', '09818181818', '9 Mile'),
('U018', 'Student', 'Moe', 'Moe', 'moe.moe@stu.parami.edu', '09919191919', '10 Mile'),
('U019', 'Student', 'Kaung', 'Myat', 'kaung.myat@stu.parami.edu', '09121212121', 'Inya'),
('U020', 'Student', 'Su', 'Su', 'su.su@stu.parami.edu', '09232323232', 'University Ave'),
('U021', 'Student', 'Wai', 'Yan', 'wai.yan@stu.parami.edu', '09343434343', 'Parami Road'),
('U022', 'Student', 'Zin', 'Mar', 'zin.mar@stu.parami.edu', '09454545454', 'Kyeemyindaing'),
('U023', 'Student', 'Nay', 'Toe', 'nay.toe@stu.parami.edu', '09565656565', 'Ahlone'),
('U024', 'Student', 'Phway', 'Phway', 'phway.phway@stu.parami.edu', '09676767676', 'Dagon'),
('U025', 'Student', 'Lu', 'Min', 'lu.min@stu.parami.edu', '09787878787', 'Latha'),
('U026', 'Guest', 'Alice', 'Wonder', 'alice@external.com', '09898989898', 'Hotel Yangon'),
('U027', 'Guest', 'Bob', 'Builder', 'bob@construct.com', '09112233445', 'Sedona Hotel'),
('U028', 'Management', 'U Ba', 'Gyi', 'ba.gyi@admin.parami.edu', '09223344556', 'FMI City'),
('U029', 'Management', 'Daw Aye', 'Mya', 'aye.mya@admin.parami.edu', '09334455667', 'Pun Hlaing'),
('U030', 'Staff', 'Ko', 'Latt', 'ko.latt@staff.parami.edu', '09445566778', 'Shwe Pyi Thar'),
('U031', 'Student', 'Student', 'ThirtyOne', 'st31@parami.edu', '09000000031', 'Hostel'),
('U032', 'Student', 'Student', 'ThirtyTwo', 'st32@parami.edu', '09000000032', 'Hostel'),
('U033', 'Student', 'Student', 'ThirtyThree', 'st33@parami.edu', '09000000033', 'Hostel'),
('U034', 'Student', 'Student', 'ThirtyFour', 'st34@parami.edu', '09000000034', 'Hostel'),
('U035', 'Student', 'Student', 'ThirtyFive', 'st35@parami.edu', '09000000035', 'Hostel'),
('U036', 'Student', 'Student', 'ThirtySix', 'st36@parami.edu', '09000000036', 'Hostel'),
('U037', 'Student', 'Student', 'ThirtySeven', 'st37@parami.edu', '09000000037', 'Hostel'),
('U038', 'Student', 'Student', 'ThirtyEight', 'st38@parami.edu', '09000000038', 'Hostel'),
('U039', 'Student', 'Student', 'ThirtyNine', 'st39@parami.edu', '09000000039', 'Hostel'),
('U040', 'Student', 'Student', 'Forty', 'st40@parami.edu', '09000000040', 'Hostel'),
('U041', 'Student', 'Student', 'FortyOne', 'st41@parami.edu', '09000000041', 'Hostel'),
('U042', 'Student', 'Student', 'FortyTwo', 'st42@parami.edu', '09000000042', 'Hostel'),
('U043', 'Student', 'Student', 'FortyThree', 'st43@parami.edu', '09000000043', 'Hostel'),
('U044', 'Student', 'Student', 'FortyFour', 'st44@parami.edu', '09000000044', 'Hostel'),
('U045', 'Student', 'Student', 'FortyFive', 'st45@parami.edu', '09000000045', 'Hostel'),
('U046', 'Student', 'Student', 'FortySix', 'st46@parami.edu', '09000000046', 'Hostel'),
('U047', 'Student', 'Student', 'FortySeven', 'st47@parami.edu', '09000000047', 'Hostel'),
('U048', 'Student', 'Student', 'FortyEight', 'st48@parami.edu', '09000000048', 'Hostel'),
('U049', 'Student', 'Student', 'FortyNine', 'st49@parami.edu', '09000000049', 'Hostel'),
('U050', 'Student', 'Student', 'Fifty', 'st50@parami.edu', '09000000050', 'Hostel');

INSERT INTO Resources 
(resource_id, category_id, available_quantity, condition_status, resource_name) 
VALUES
('R001', 'C001', 10, 'Excellent', 'Dell XPS 15 Laptop'),
('R002', 'C001', 8, 'Excellent', 'MacBook Air M2'),
('R003', 'C001', 5, 'Error', 'Lenovo ThinkPad X1'), -- "Error" used for repair need
('R004', 'C001', 12, 'Good', 'iPad Pro 12.9'),
('R005', 'C001', 6, 'Fair', 'Samsung Galaxy Tab S8'), -- "Fair" used for inactive/old
('R006', 'C002', 3, 'Excellent', 'Sony Alpha a7 III Camera'),
('R007', 'C002', 2, 'Excellent', 'Canon EOS R5'),
('R008', 'C002', 5, 'Good', 'Rode Wireless Go II Mic'),
('R009', 'C002', 4, 'Error', 'Blue Yeti USB Mic'),
('R010', 'C002', 1, 'Excellent', 'DJI Mavic 3 Drone'),
('R011', 'C003', 500, 'Excellent', 'Canvas LMS Student Access'),
('R012', 'C003', 50, 'Excellent', 'Coursera Enterprise License'),
('R013', 'C003', 100, 'Good', 'EdX Premium Coupon'),
('R014', 'C003', 20, 'Fair', 'Udemy Business Key (Expired)'),
('R015', 'C003', 200, 'Excellent', 'Moodle Cloud Login'),
('R016', 'C004', 50, 'Excellent', 'Adobe Creative Cloud All Apps'),
('R017', 'C004', 50, 'Excellent', 'Zoom Pro Host License'),
('R018', 'C004', 100, 'Excellent', 'Microsoft Office 365 Enterprise'),
('R019', 'C004', 30, 'Good', 'Notion Team Plan'),
('R020', 'C004', 10, 'Good', 'Tableau Desktop License'),
('R021', 'C005', 20, 'Good', 'Intro to Political Science'),
('R022', 'C005', 15, 'Good', 'Database System Concepts (Silberschatz)'),
('R023', 'C005', 10, 'Good', 'Modern Operating Systems'),
('R024', 'C005', 25, 'Excellent', 'Principles of Economics'),
('R025', 'C005', 12, 'Error', 'History of Southeast Asia (Torn)'),
('R026', 'C005', 30, 'Good', 'Calculus: Early Transcendentals'),
('R027', 'C005', 18, 'Good', 'Linear Algebra Done Right'),
('R028', 'C005', 14, 'Good', 'AI: A Modern Approach'),
('R029', 'C005', 5, 'Fair', 'Old Physics Textbook'),
('R030', 'C005', 22, 'Excellent', 'Academic Writing Skills'),
('R031', 'C006', 50, 'Excellent', 'HDMI Cable 2m'),
('R032', 'C006', 40, 'Excellent', 'USB-C to HDMI Adapter'),
('R033', 'C006', 30, 'Good', 'MacBook MagSafe Charger'),
('R034', 'C006', 20, 'Good', 'Lightning Cable'),
('R035', 'C006', 25, 'Good', 'Power Extension Cord'),
('R036', 'C006', 15, 'Error', 'Projector Remote'),
('R037', 'C006', 10, 'Good', 'VGA Cable'),
('R038', 'C006', 50, 'Good', 'Ethernet Cable 5m'),
('R039', 'C006', 5, 'Excellent', 'Webcam Logitech C920'),
('R040', 'C006', 8, 'Excellent', 'Headphones (Noise Cancelling)'),
('R041', 'C005', 10, 'Good', 'Burmese History Vol 1'),
('R042', 'C005', 10, 'Good', 'Burmese History Vol 2'),
('R043', 'C003', 50, 'Excellent', 'JSTOR Access Token'),
('R044', 'C004', 5, 'Excellent', 'SPSS Statistics License'),
('R045', 'C001', 3, 'Excellent', 'Wacom Drawing Tablet'),
('R046', 'C002', 2, 'Excellent', 'GoPro Hero 11'),
('R047', 'C006', 10, 'Good', 'Tripod Manfrotto'),
('R048', 'C005', 20, 'Good', 'Environmental Science Basics'),
('R049', 'C004', 100, 'Excellent', 'Canva Pro Team Invite'),
('R050', 'C001', 20, 'Good', 'Kindle Paperwhite');

INSERT INTO Request 
(request_id, user_id, resource_id, staff_id, request_date, request_status, request_quantity) 
VALUES
('RE001', 'U001', 'R001', 'S002', '2025-01-01 10:00:00', 'APPROVED', 1),
('RE002', 'U002', 'R021', 'S001', '2025-01-02 10:15:00', 'APPROVED', 1),
('RE003', 'U003', 'R016', 'S002', '2025-01-03 09:30:00', 'APPROVED', 1),
('RE004', 'U004', 'R011', 'S002', '2025-01-04 11:00:00', 'APPROVED', 1),
('RE005', 'U005', 'R006', 'S004', '2025-01-05 14:20:00', 'APPROVED', 1),
('RE006', 'U006', 'R031', 'S005', '2025-01-06 15:45:00', 'APPROVED', 2),
('RE007', 'U007', 'R002', 'S002', '2025-01-07 10:00:00', 'APPROVED', 1),
('RE008', 'U008', 'R022', 'S001', '2025-01-08 11:30:00', 'APPROVED', 1),
('RE009', 'U009', 'R017', 'S002', '2025-01-09 13:00:00', 'APPROVED', 1),
('RE010', 'U010', 'R012', 'S002', '2025-01-10 09:00:00', 'APPROVED', 1),
('RE011', 'U011', 'R005', 'S004', '2025-01-11 16:00:00', 'APPROVED', 1),
('RE012', 'U012', 'R032', 'S005', '2025-01-12 10:30:00', 'APPROVED', 1),
('RE013', 'U013', 'R003', 'S002', '2025-01-13 14:15:00', 'APPROVED', 1),
('RE014', 'U014', 'R023', 'S001', '2025-01-14 09:45:00', 'APPROVED', 1),
('RE015', 'U015', 'R018', 'S002', '2025-01-15 11:20:00', 'APPROVED', 1),
('RE016', 'U016', 'R013', 'S002', '2025-01-16 12:50:00', 'APPROVED', 1),
('RE017', 'U017', 'R007', 'S004', '2025-01-17 15:00:00', 'APPROVED', 1),
('RE018', 'U018', 'R033', 'S005', '2025-01-18 16:30:00', 'APPROVED', 1),
('RE019', 'U019', 'R004', 'S002', '2025-01-19 10:10:00', 'APPROVED', 1),
('RE020', 'U020', 'R024', 'S001', '2025-01-20 11:45:00', 'APPROVED', 1),
('RE021', 'U021', 'R019', 'S002', '2025-01-21 14:00:00', 'APPROVED', 1),
('RE022', 'U022', 'R014', 'S002', '2025-01-22 09:15:00', 'APPROVED', 1),
('RE023', 'U023', 'R008', 'S004', '2025-01-23 10:50:00', 'APPROVED', 1),
('RE024', 'U024', 'R034', 'S005', '2025-01-24 13:25:00', 'APPROVED', 1),
('RE025', 'U025', 'R001', 'S002', '2025-01-25 15:10:00', 'APPROVED', 1),
('RE026', 'U026', 'R025', 'S001', '2025-01-26 11:30:00', 'APPROVED', 1),
('RE027', 'U027', 'R020', 'S002', '2025-01-27 12:45:00', 'APPROVED', 1),
('RE028', 'U028', 'R015', 'S002', '2025-01-28 14:55:00', 'APPROVED', 1),
('RE029', 'U029', 'R009', 'S004', '2025-01-29 09:05:00', 'APPROVED', 1),
('RE030', 'U030', 'R035', 'S005', '2025-01-30 10:40:00', 'APPROVED', 1),
('RE031', 'U031', 'R002', 'S002', '2025-02-01 11:15:00', 'APPROVED', 1),
('RE032', 'U032', 'R026', 'S001', '2025-02-02 13:50:00', 'APPROVED', 1),
('RE033', 'U033', 'R016', 'S002', '2025-02-03 15:30:00', 'APPROVED', 1),
('RE034', 'U034', 'R011', 'S002', '2025-02-04 09:25:00', 'APPROVED', 1),
('RE035', 'U035', 'R010', 'S004', '2025-02-05 10:55:00', 'APPROVED', 1),
('RE036', 'U036', 'R036', 'S005', '2025-02-06 14:10:00', 'APPROVED', 1),
('RE037', 'U037', 'R003', 'S002', '2025-02-07 16:20:00', 'APPROVED', 1),
('RE038', 'U038', 'R027', 'S001', '2025-02-08 11:45:00', 'APPROVED', 1),
('RE039', 'U039', 'R017', 'S002', '2025-02-09 13:00:00', 'APPROVED', 1),
('RE040', 'U040', 'R012', 'S002', '2025-02-10 09:35:00', 'APPROVED', 1),
('RE041', 'U041', 'R005', 'S004', '2025-02-11 15:05:00', 'APPROVED', 1),
('RE042', 'U042', 'R037', 'S005', '2025-02-12 10:20:00', 'APPROVED', 1),
('RE043', 'U043', 'R004', 'S002', '2025-02-13 11:50:00', 'APPROVED', 1),
('RE044', 'U044', 'R028', 'S001', '2025-02-14 14:40:00', 'APPROVED', 1),
('RE045', 'U045', 'R018', 'S002', '2025-02-15 16:15:00', 'APPROVED', 1),
('RE046', 'U046', 'R013', 'S002', '2025-02-16 09:50:00', 'APPROVED', 1),
('RE047', 'U047', 'R006', 'S004', '2025-02-17 12:30:00', 'APPROVED', 1),
('RE048', 'U048', 'R038', 'S005', '2025-02-18 13:45:00', 'APPROVED', 1),
('RE049', 'U049', 'R001', 'S002', '2025-02-19 10:00:00', 'APPROVED', 1),
('RE050', 'U050', 'R029', 'S001', '2025-02-20 11:10:00', 'APPROVED', 1),
('RE051', 'U001', 'R001', 'S002', '2025-03-01 10:00:00', 'APPROVED', 1),
('RE052', 'U002', 'R002', 'S002', '2025-03-01 10:05:00', 'APPROVED', 1),
('RE053', 'U003', 'R003', 'S002', '2025-03-01 10:10:00', 'APPROVED', 1),
('RE054', 'U004', 'R004', 'S002', '2025-03-01 10:15:00', 'APPROVED', 1),
('RE055', 'U005', 'R005', 'S002', '2025-03-01 10:20:00', 'APPROVED', 1),
('RE056', 'U006', 'R006', 'S002', '2025-03-01 10:25:00', 'APPROVED', 1),
('RE057', 'U007', 'R007', 'S002', '2025-03-01 10:30:00', 'APPROVED', 1),
('RE058', 'U008', 'R008', 'S002', '2025-03-01 10:35:00', 'APPROVED', 1),
('RE059', 'U009', 'R009', 'S002', '2025-03-01 10:40:00', 'APPROVED', 1),
('RE060', 'U010', 'R010', 'S002', '2025-03-01 10:45:00', 'APPROVED', 1),
('RE061', 'U011', 'R011', 'S002', '2025-03-02 11:00:00', 'APPROVED', 1),
('RE062', 'U012', 'R012', 'S002', '2025-03-02 11:05:00', 'APPROVED', 1),
('RE063', 'U013', 'R013', 'S002', '2025-03-02 11:10:00', 'APPROVED', 1),
('RE064', 'U014', 'R014', 'S002', '2025-03-02 11:15:00', 'APPROVED', 1),
('RE065', 'U015', 'R015', 'S002', '2025-03-02 11:20:00', 'APPROVED', 1),
('RE066', 'U016', 'R016', 'S002', '2025-03-02 11:25:00', 'APPROVED', 1),
('RE067', 'U017', 'R017', 'S002', '2025-03-02 11:30:00', 'APPROVED', 1),
('RE068', 'U018', 'R018', 'S002', '2025-03-02 11:35:00', 'APPROVED', 1),
('RE069', 'U019', 'R019', 'S002', '2025-03-02 11:40:00', 'APPROVED', 1),
('RE070', 'U020', 'R020', 'S002', '2025-03-02 11:45:00', 'APPROVED', 1),
('RE071', 'U021', 'R021', 'S002', '2025-03-03 14:00:00', 'APPROVED', 1),
('RE072', 'U022', 'R022', 'S002', '2025-03-03 14:05:00', 'APPROVED', 1),
('RE073', 'U023', 'R023', 'S002', '2025-03-03 14:10:00', 'APPROVED', 1),
('RE074', 'U024', 'R024', 'S002', '2025-03-03 14:15:00', 'APPROVED', 1),
('RE075', 'U025', 'R025', 'S002', '2025-03-03 14:20:00', 'APPROVED', 1),
('RE076', 'U026', 'R026', 'S002', '2025-03-03 14:25:00', 'APPROVED', 1),
('RE077', 'U027', 'R027', 'S002', '2025-03-03 14:30:00', 'APPROVED', 1),
('RE078', 'U028', 'R028', 'S002', '2025-03-03 14:35:00', 'APPROVED', 1),
('RE079', 'U029', 'R029', 'S002', '2025-03-03 14:40:00', 'APPROVED', 1),
('RE080', 'U030', 'R030', 'S002', '2025-03-03 14:45:00', 'APPROVED', 1),
('RE081', 'U001', 'R031', 'S002', '2025-03-04 09:00:00', 'APPROVED', 1),
('RE082', 'U002', 'R032', 'S002', '2025-03-04 09:05:00', 'APPROVED', 1),
('RE083', 'U003', 'R033', 'S002', '2025-03-04 09:10:00', 'APPROVED', 1),
('RE084', 'U004', 'R034', 'S002', '2025-03-04 09:15:00', 'APPROVED', 1),
('RE085', 'U005', 'R035', 'S002', '2025-03-04 09:20:00', 'APPROVED', 1),
('RE086', 'U006', 'R036', 'S002', '2025-03-04 09:25:00', 'APPROVED', 1),
('RE087', 'U007', 'R037', 'S002', '2025-03-04 09:30:00', 'APPROVED', 1),
('RE088', 'U008', 'R038', 'S002', '2025-03-04 09:35:00', 'APPROVED', 1),
('RE089', 'U009', 'R039', 'S002', '2025-03-04 09:40:00', 'APPROVED', 1),
('RE090', 'U010', 'R040', 'S002', '2025-03-04 09:45:00', 'APPROVED', 1),
('RE091', 'U011', 'R041', NULL, '2025-03-05 10:00:00', 'PENDING', 1),
('RE092', 'U012', 'R042', NULL, '2025-03-05 10:10:00', 'PENDING', 1),
('RE093', 'U013', 'R043', 'S002', '2025-03-05 10:20:00', 'DECLINED', 1),
('RE094', 'U014', 'R044', NULL, '2025-03-05 10:30:00', 'PENDING', 1),
('RE095', 'U015', 'R045', NULL, '2025-03-05 10:40:00', 'PENDING', 1),
('RE096', 'U016', 'R046', 'S002', '2025-03-05 10:50:00', 'DECLINED', 1),
('RE097', 'U017', 'R047', NULL, '2025-03-05 11:00:00', 'PENDING', 1),
('RE098', 'U018', 'R048', NULL, '2025-03-05 11:10:00', 'PENDING', 1),
('RE099', 'U019', 'R049', NULL, '2025-03-05 11:20:00', 'PENDING', 1),
('RE100', 'U020', 'R050', NULL, '2025-03-05 11:30:00', 'PENDING', 1);

INSERT INTO Check_out 
(check_out_id, staff_id, request_id, user_id, checkout_date) 
VALUES
('CK001', 'S002', 'RE001', 'U001', '2025-01-01 10:00:00'),
('CK002', 'S001', 'RE002', 'U002', '2025-01-02 10:15:00'),
('CK003', 'S002', 'RE003', 'U003', '2025-01-03 09:30:00'),
('CK004', 'S002', 'RE004', 'U004', '2025-01-04 11:00:00'),
('CK005', 'S004', 'RE005', 'U005', '2025-01-05 14:20:00'),
('CK006', 'S005', 'RE006', 'U006', '2025-01-06 15:45:00'),
('CK007', 'S002', 'RE007', 'U007', '2025-01-07 10:00:00'),
('CK008', 'S001', 'RE008', 'U008', '2025-01-08 11:30:00'),
('CK009', 'S002', 'RE009', 'U009', '2025-01-09 13:00:00'),
('CK010', 'S002', 'RE010', 'U010', '2025-01-10 09:00:00'),
('CK011', 'S004', 'RE011', 'U011', '2025-01-11 16:00:00'),
('CK012', 'S005', 'RE012', 'U012', '2025-01-12 10:30:00'),
('CK013', 'S002', 'RE013', 'U013', '2025-01-13 14:15:00'),
('CK014', 'S001', 'RE014', 'U014', '2025-01-14 09:45:00'),
('CK015', 'S002', 'RE015', 'U015', '2025-01-15 11:20:00'),
('CK016', 'S002', 'RE016', 'U016', '2025-01-16 12:50:00'),
('CK017', 'S004', 'RE017', 'U017', '2025-01-17 15:00:00'),
('CK018', 'S005', 'RE018', 'U018', '2025-01-18 16:30:00'),
('CK019', 'S002', 'RE019', 'U019', '2025-01-19 10:10:00'),
('CK020', 'S001', 'RE020', 'U020', '2025-01-20 11:45:00'),
('CK021', 'S002', 'RE021', 'U021', '2025-01-21 14:00:00'),
('CK022', 'S002', 'RE022', 'U022', '2025-01-22 09:15:00'),
('CK023', 'S004', 'RE023', 'U023', '2025-01-23 10:50:00'),
('CK024', 'S005', 'RE024', 'U024', '2025-01-24 13:25:00'),
('CK025', 'S002', 'RE025', 'U025', '2025-01-25 15:10:00'),
('CK026', 'S001', 'RE026', 'U026', '2025-01-26 11:30:00'),
('CK027', 'S002', 'RE027', 'U027', '2025-01-27 12:45:00'),
('CK028', 'S002', 'RE028', 'U028', '2025-01-28 14:55:00'),
('CK029', 'S004', 'RE029', 'U029', '2025-01-29 09:05:00'),
('CK030', 'S005', 'RE030', 'U030', '2025-01-30 10:40:00'),
('CK031', 'S002', 'RE031', 'U031', '2025-02-01 11:15:00'),
('CK032', 'S001', 'RE032', 'U032', '2025-02-02 13:50:00'),
('CK033', 'S002', 'RE033', 'U033', '2025-02-03 15:30:00'),
('CK034', 'S002', 'RE034', 'U034', '2025-02-04 09:25:00'),
('CK035', 'S004', 'RE035', 'U035', '2025-02-05 10:55:00'),
('CK036', 'S005', 'RE036', 'U036', '2025-02-06 14:10:00'),
('CK037', 'S002', 'RE037', 'U037', '2025-02-07 16:20:00'),
('CK038', 'S001', 'RE038', 'U038', '2025-02-08 11:45:00'),
('CK039', 'S002', 'RE039', 'U039', '2025-02-09 13:00:00'),
('CK040', 'S002', 'RE040', 'U040', '2025-02-10 09:35:00'),
('CK041', 'S004', 'RE041', 'U041', '2025-02-11 15:05:00'),
('CK042', 'S005', 'RE042', 'U042', '2025-02-12 10:20:00'),
('CK043', 'S002', 'RE043', 'U043', '2025-02-13 11:50:00'),
('CK044', 'S001', 'RE044', 'U044', '2025-02-14 14:40:00'),
('CK045', 'S002', 'RE045', 'U045', '2025-02-15 16:15:00'),
('CK046', 'S002', 'RE046', 'U046', '2025-02-16 09:50:00'),
('CK047', 'S004', 'RE047', 'U047', '2025-02-17 12:30:00'),
('CK048', 'S005', 'RE048', 'U048', '2025-02-18 13:45:00'),
('CK049', 'S002', 'RE049', 'U049', '2025-02-19 10:00:00'),
('CK050', 'S001', 'RE050', 'U050', '2025-02-20 11:10:00');


INSERT INTO Return 
(return_id, check_out_id, staff_id, due_date, return_date, return_condition, overdue_status) 
VALUES
('RT001', 'CK001', 'S002', '2025-01-08 10:00:00', '2025-01-15 10:00:00', 'Good', 'YES'),
('RT002', 'CK002', 'S001', '2025-01-09 10:00:00', '2025-01-12 10:00:00', 'Good', 'YES'),
('RT003', 'CK003', 'S002', '2025-01-10 10:00:00', '2025-01-18 10:00:00', 'Error', 'YES'),
('RT004', 'CK004', 'S002', '2025-01-11 10:00:00', '2025-01-14 10:00:00', 'Good', 'YES'),
('RT005', 'CK005', 'S004', '2025-01-12 10:00:00', '2025-01-20 10:00:00', 'Good', 'YES'),
('RT006', 'CK006', 'S005', '2025-01-13 10:00:00', '2025-01-15 10:00:00', 'Good', 'YES'),
('RT007', 'CK007', 'S002', '2025-01-14 10:00:00', '2025-01-16 10:00:00', 'Good', 'YES'),
('RT008', 'CK008', 'S001', '2025-01-15 10:00:00', '2025-01-22 10:00:00', 'Good', 'YES'),
('RT009', 'CK009', 'S002', '2025-01-16 10:00:00', '2025-01-18 10:00:00', 'Good', 'YES'),
('RT010', 'CK010', 'S002', '2025-01-17 10:00:00', '2025-01-25 10:00:00', 'Error', 'YES'),
('RT011', 'CK011', 'S004', '2025-01-18 10:00:00', '2025-01-19 10:00:00', 'Good', 'YES'),
('RT012', 'CK012', 'S005', '2025-01-19 10:00:00', '2025-01-21 10:00:00', 'Good', 'YES'),
('RT013', 'CK013', 'S002', '2025-01-20 10:00:00', '2025-01-24 10:00:00', 'Good', 'YES'),
('RT014', 'CK014', 'S001', '2025-01-21 10:00:00', '2025-01-28 10:00:00', 'Good', 'YES'),
('RT015', 'CK015', 'S002', '2025-01-22 10:00:00', '2025-01-23 10:00:00', 'Good', 'YES'),
('RT016', 'CK016', 'S002', '2025-01-25 10:00:00', '2025-01-25 12:00:00', 'Good', 'NO'),
('RT017', 'CK017', 'S004', '2025-01-25 10:00:00', '2025-01-24 10:00:00', 'Good', 'NO'),
('RT018', 'CK018', 'S005', '2025-01-25 10:00:00', '2025-01-25 10:00:00', 'Good', 'NO'),
('RT019', 'CK019', 'S002', '2025-01-26 10:00:00', '2025-01-26 10:00:00', 'Good', 'NO'),
('RT020', 'CK020', 'S001', '2025-01-27 10:00:00', '2025-01-27 10:00:00', 'Good', 'NO'),
('RT021', 'CK021', 'S002', '2025-01-28 10:00:00', '2025-01-28 10:00:00', 'Good', 'NO'),
('RT022', 'CK022', 'S002', '2025-01-29 10:00:00', '2025-01-29 10:00:00', 'Good', 'NO'),
('RT023', 'CK023', 'S004', '2025-01-30 10:00:00', '2025-01-30 10:00:00', 'Good', 'NO'),
('RT024', 'CK024', 'S005', '2025-01-31 10:00:00', '2025-01-31 10:00:00', 'Good', 'NO'),
('RT025', 'CK025', 'S002', '2025-02-01 10:00:00', '2025-02-01 10:00:00', 'Good', 'NO'),
('RT026', 'CK026', 'S001', '2025-02-02 10:00:00', '2025-02-02 10:00:00', 'Good', 'NO'),
('RT027', 'CK027', 'S002', '2025-02-03 10:00:00', '2025-02-03 10:00:00', 'Good', 'NO'),
('RT028', 'CK028', 'S002', '2025-02-04 10:00:00', '2025-02-04 10:00:00', 'Good', 'NO'),
('RT029', 'CK029', 'S004', '2025-02-05 10:00:00', '2025-02-05 10:00:00', 'Good', 'NO'),
('RT030', 'CK030', 'S005', '2025-02-06 10:00:00', '2025-02-06 10:00:00', 'Good', 'NO'),
('RT031', 'CK031', 'S002', '2025-02-08 10:00:00', '2025-02-08 10:00:00', 'Good', 'NO'),
('RT032', 'CK032', 'S001', '2025-02-09 10:00:00', '2025-02-09 10:00:00', 'Good', 'NO'),
('RT033', 'CK033', 'S002', '2025-02-10 10:00:00', '2025-02-10 10:00:00', 'Good', 'NO'),
('RT034', 'CK034', 'S002', '2025-02-11 10:00:00', '2025-02-11 10:00:00', 'Good', 'NO'),
('RT035', 'CK035', 'S004', '2025-02-12 10:00:00', '2025-02-12 10:00:00', 'Good', 'NO'),
('RT036', 'CK036', 'S005', '2025-02-13 10:00:00', '2025-02-13 10:00:00', 'Good', 'NO'),
('RT037', 'CK037', 'S002', '2025-02-14 10:00:00', '2025-02-14 10:00:00', 'Good', 'NO'),
('RT038', 'CK038', 'S001', '2025-02-15 10:00:00', '2025-02-15 10:00:00', 'Good', 'NO'),
('RT039', 'CK039', 'S002', '2025-02-16 10:00:00', '2025-02-16 10:00:00', 'Good', 'NO'),
('RT040', 'CK040', 'S002', '2025-02-17 10:00:00', '2025-02-17 10:00:00', 'Good', 'NO'),
('RT041', 'CK041', 'S004', '2025-02-18 10:00:00', '2025-02-18 10:00:00', 'Good', 'NO'),
('RT042', 'CK042', 'S005', '2025-02-19 10:00:00', '2025-02-19 10:00:00', 'Good', 'NO'),
('RT043', 'CK043', 'S002', '2025-02-20 10:00:00', '2025-02-20 10:00:00', 'Good', 'NO'),
('RT044', 'CK044', 'S001', '2025-02-21 10:00:00', '2025-02-21 10:00:00', 'Good', 'NO'),
('RT045', 'CK045', 'S002', '2025-02-22 10:00:00', '2025-02-22 10:00:00', 'Good', 'NO'),
('RT046', 'CK046', 'S002', '2025-02-23 10:00:00', '2025-02-23 10:00:00', 'Good', 'NO'),
('RT047', 'CK047', 'S004', '2025-02-24 10:00:00', '2025-02-24 10:00:00', 'Good', 'NO'),
('RT048', 'CK048', 'S005', '2025-02-25 10:00:00', '2025-02-25 10:00:00', 'Good', 'NO'),
('RT049', 'CK049', 'S002', '2025-02-26 10:00:00', '2025-02-26 10:00:00', 'Good', 'NO'),
('RT050', 'CK050', 'S001', '2025-02-27 10:00:00', '2025-02-27 10:00:00', 'Good', 'NO');

INSERT INTO Fine 
(fine_id, return_id, amount) 
VALUES
('F001', 'RT001', 5.00),
('F002', 'RT002', 2.50),
('F003', 'RT003', 50.00),
('F004', 'RT004', 3.00),
('F005', 'RT005', 8.00),
('F006', 'RT006', 2.00),
('F007', 'RT007', 2.00),
('F008', 'RT008', 7.50),
('F009', 'RT009', 2.00),
('F010', 'RT010', 75.00),
('F011', 'RT011', 1.00),
('F012', 'RT012', 2.00),
('F013', 'RT013', 4.00),
('F014', 'RT014', 7.00),
('F015', 'RT015', 1.00);