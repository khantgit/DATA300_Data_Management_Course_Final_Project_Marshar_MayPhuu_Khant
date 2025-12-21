JOIN Queries 

-- Find the list of users who have submitted resource requests along with the resources they requested and the request status must be approved.
-- Inner Join 

SELECT u.user_id, rq.request_id,r.resource_name, rq.request_status
FROM users u
INNER JOIN request rq
        ON u.user_id = rq.user_id
INNER JOIN resources r
        ON rq.resource_id = r.resource_id AND request_status = 'APPROVED';



-- 2. Display all resources in the PMRC system, including those that have never been requested.
-- Left Join
SELECT r.resource_id,
       r.resource_name,
       rq.*
FROM resource r
LEFT JOIN request rq
       ON r.resource_id = rq.resource_id;


-- 3. Display all checkout records, even if some request details are missing.
-- Right Join
SELECT c.check_out_id,
       c.checkout_date,
       rq.*
FROM request rq
RIGHT JOIN check_out c
        ON rq.request_id = c.request_id;

 