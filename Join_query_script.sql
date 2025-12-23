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


 
-- 3. Display all return records along with their corresponding fine details, including returns that may not have any fines.
-- Right Join
SELECT 
    r.return_id,
    r.return_date,
    f.fine_id,
    f.amount
FROM fine f
RIGHT JOIN return r
ON f.return_id = r.return_id;

