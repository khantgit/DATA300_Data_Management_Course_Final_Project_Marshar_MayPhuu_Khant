-- Create User Roles (Groups)
CREATE ROLE student_role;
CREATE ROLE staff_role;
CREATE ROLE faculty_role;

---------------------------------------------------------------------------
-- Grant Access to Tables

-- Grant Full Control to Staff on some tables
GRANT INSERT, UPDATE, SELECT 
ON Request TO staff_role;

GRANT INSERT, UPDATE, SELECT 
ON Check_out TO staff_role;

GRANT INSERT, UPDATE, SELECT 
ON Return TO staff_role;

-- Revoke permission for students cannot accidentally delete resources
REVOKE DELETE 
ON Resources FROM student_role;

-------------------------------------------------------------------------

-- View for Users 
CREATE VIEW Public_Catalog_View AS
SELECT 
    r.resource_name,
    c.category_name,
    r.available_quantity,
    r.condition_status
FROM Resources r
JOIN Resources_category c ON r.category_id = c.category_id
WHERE r.available_quantity > 0;

-- Look at the View
SELECT * FROM Public_Catalog_View;

-- Grant Query Access to Catalog View
Grant QUERY access to Students on the View
GRANT SELECT 
ON Public_Catalog_View TO student_role;

-----------------------------------------------------------------------------

-- Create the View on Staff
CREATE VIEW Staff_Directory AS
SELECT 
    first_name || ' ' || last_name AS Staff_Name,
    position,
    email
FROM Staff;

-- Look at the View
SELECT * FROM public.staff_directory

-- Link with a Grant Permission
GRANT SELECT ON Staff_Directory TO student_role, faculty_role, staff_role;

-----------------------------------------------------------------------------

