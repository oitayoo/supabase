CREATE
OR REPLACE FUNCTION is_any_store_staff () RETURNS BOOLEAN AS $$
DECLARE
    access_granted BOOLEAN;
BEGIN
    access_granted := EXISTS (
        SELECT 1
        FROM store_staffs
        WHERE user_id = auth.uid()
    );
    RETURN access_granted;
END;
$$ LANGUAGE plpgsql;