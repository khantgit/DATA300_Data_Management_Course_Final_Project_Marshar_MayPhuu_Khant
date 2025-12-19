--- Use Case 1: Browse Available Resources with Categories
--- SQL Logic: This query joins Resources with Categories 
--- to show what is available (Quantity > 0).

SELECT 
    r.resource_id,
	c.category_name,
    r.resource_name,
    r.available_quantity,
    r.condition_status
FROM Resources r
JOIN Resources_category c 
ON r.category_id = c.category_id
WHERE r.available_quantity > 0
ORDER BY c.category_name, r.resource_name;


--- Use Case 2: Submit Resource Request
--- SQL Logic: A student inserts a new row into the Request table. 
--- Note that request_status defaults to 'PENDING', so we don't need to type that.

INSERT INTO Request 
(request_id, user_id, resource_id, request_quantity, due_date)
VALUES 
('RE101', 'U001', 'R006', 1, '2025-03-10 10:00:00');

SELECT * 
FROM Request
WHERE request_id = 'RE101';


--- Use Case 3: Staff Approves/Rejects Requests
--- SQL Logic: First, the staff needs to see the pending requests. 
--- Then, they update the status.

--- View Pending
SELECT 
    req.request_id,
    u.first_name,
    u.last_name,
    r.resource_name,
    req.request_date
FROM Request req
JOIN Users u ON req.user_id = u.user_id
JOIN Resources r ON req.resource_id = r.resource_id
WHERE req.request_status = 'PENDING';


-- Approve RE101
UPDATE Request
SET 
    request_status = 'APPROVED',
    staff_id = 'S002',
    approved_date = CURRENT_TIMESTAMP
WHERE request_id = 'RE101';


--- Use Case 4: Check-Out Resource
--- SQL Logic: Once the student comes to collect the item, 
--- the staff creates a Check_out record.

INSERT INTO Check_out 
(check_out_id, staff_id, request_id, user_id)
VALUES 
('CK051', 'S002', 'RE101', 'U001');


--- Use Case 5: Check-In Resource (The Return)
--- SQL Logic: When the item comes back, 
--- we log it in the Return table and mark its condition.

INSERT INTO Return 
(return_id, check_out_id, staff_id, return_condition, overdue_status)
VALUES 
('RT051', 'CK051', 'S002', 'Good', 'NO');


--- Use Case 6: Issue Fine for Overdue or Damaged Item
--- SQL Logic: This inserts a record into the Fine table linked to the specific Return ID.

-- Scenario: The item returned in 'RT051' (from Use Case 5) was actually broken.
-- Staff issues a fine of $50.00.

INSERT INTO Fine 
(fine_id, return_id, amount)
VALUES 
('F016', 'RT051', 50.00);


--- Use Case 7: Manage Digital Licenses
--- SQL Logic: This is a specific query to find resources that are Digital/Software 

SELECT 
    r.resource_name,
    r.available_quantity,
    c.category_name
FROM Resources r
JOIN Resources_category c ON r.category_id = c.category_id
WHERE c.category_name LIKE '%Digital%';


