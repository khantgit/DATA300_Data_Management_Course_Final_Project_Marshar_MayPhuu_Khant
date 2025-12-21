--Procedure a staff use to Approve or Decline a Resource request from a user

CREATE OR REPLACE PROCEDURE approve_or_decline_request(
    p_request_id VARCHAR,
    p_staff_id VARCHAR,
    p_request_status VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validate status
    IF UPPER(p_request_status) NOT IN ('APPROVED', 'DECLINED') THEN
        RAISE EXCEPTION 'Invalid status. Use APPROVED or DECLINED';
    END IF;

    -- Update request status
    UPDATE "request"
    SET request_status = UPPER(p_request_status),
        staff_id = p_staff_id
    WHERE request_id = p_request_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Request % not found', p_request_id;
    END IF;

    RAISE NOTICE
    'Request % has been % by staff %',
    p_request_id, p_request_status, p_staff_id;
END;
$$;
--check
CALL approve_or_decline_request('RE001', 'S002', 'APPROVED');

--Staff want to check or maintain a resource by updating resource condition and quantity
CREATE OR REPLACE PROCEDURE update_resource_status(
    p_resource_id VARCHAR,
    p_new_condition VARCHAR,
    p_new_quantity INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_new_quantity < 0 THEN
        RAISE EXCEPTION 'Quantity cannot be negative';
    END IF;

    UPDATE resources
    SET condition_status = p_new_condition,
        available_quantity = p_new_quantity
    WHERE resource_id = p_resource_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Resource % not found', p_resource_id;
    END IF;

    RAISE NOTICE
    'Resource % updated successfully', p_resource_id;
END;
$$;
--to check 
CALL update_resource_status('R001', 'Good', 15);

