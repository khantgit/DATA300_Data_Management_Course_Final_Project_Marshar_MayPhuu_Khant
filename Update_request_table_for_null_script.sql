-- Approved_date and due_date in REQUEST table are all null from raw data. So, we should update to fill null. 

-- Step 1 (Fill approved_date for APPROVED requests)
UPDATE request
SET approved_date = request_date + INTERVAL '1 hour'
WHERE request_status = 'APPROVED'
  AND approved_date IS NULL;

-- Step 2 (Set due_date for PHYSICAL resources (7 days))
UPDATE request r
SET due_date = r.approved_date + INTERVAL '7 days'
FROM resources res
JOIN resources_category rc ON res.category_id = rc.category_id
WHERE r.resource_id = res.resource_id
  AND r.request_status = 'APPROVED'
  AND rc.category_id IN ('C001', 'C002', 'C005', 'C006')
  AND r.due_date IS NULL;

-- Step 3 (Set due_date for DIGITAL resources (30 days))
UPDATE request r
SET due_date = r.approved_date + INTERVAL '30 days'
FROM resources res
JOIN resources_category rc ON res.category_id = rc.category_id
WHERE r.resource_id = res.resource_id
  AND r.request_status = 'APPROVED'
  AND rc.category_id IN ('C003', 'C004')
  AND r.due_date IS NULL;

--Step 4 (Ensure PENDING & DECLINED requests stay NULL (safety check))
UPDATE Request
SET approved_date = NULL,
    due_date = NULL
WHERE request_status IN ('PENDING', 'DECLINED');



