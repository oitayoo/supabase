CREATE
OR REPLACE FUNCTION is_store_staff (target_store_id UUID) RETURNS BOOLEAN AS $$
DECLARE
    access_granted BOOLEAN;
BEGIN
    access_granted := EXISTS (
        SELECT 1
        FROM store_staffs
        WHERE user_id = auth.uid()
        AND store_id = target_store_id
    ) OR EXISTS (
        SELECT 1
        FROM stores
        WHERE provisionable_user_id = auth.uid()
        AND id = target_store_id
    );
    RETURN access_granted;
END;
$$ LANGUAGE plpgsql;