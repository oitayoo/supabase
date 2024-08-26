CREATE
OR REPLACE FUNCTION store_provisioning (target_store_id UUID) RETURNS stores AS $$
DECLARE
    updated_store stores %ROWTYPE;
BEGIN
    -- Add data to store_staffs table
    INSERT INTO store_staffs (user_id, store_id)
    VALUES (auth.uid(), target_store_id);

    -- Update store table
    UPDATE stores
    SET provisioned_at = timezone('utc' , now())
    WHERE id = target_store_id
    RETURNING * INTO updated_store;
    RETURN updated_store;
END;
$$ LANGUAGE plpgsql;