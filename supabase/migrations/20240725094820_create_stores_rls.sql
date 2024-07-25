ALTER TABLE stores ENABLE ROW LEVEL SECURITY;

CREATE
OR REPLACE FUNCTION is_store_staff (store_id UUID) RETURNS BOOLEAN AS $$
DECLARE
    access_granted BOOLEAN;
BEGIN
    access_granted := EXISTS (
        SELECT 1
        FROM store_staffs
        WHERE user_id = auth.uid()
        AND store_id = stores_id
    ) OR EXISTS (
        SELECT 1
        FROM stores
        WHERE provisionable_user_id = auth.uid()
        AND store_id = store_id
    );
    RETURN access_granted;
END;
$$ LANGUAGE plpgsql;

CREATE POLICY "all (select)" ON stores AS PERMISSIVE FOR
SELECT
    TO public USING (TRUE);

CREATE POLICY "store staff (update)" ON stores AS PERMISSIVE FOR
UPDATE TO authenticated USING (is_store_staff (id))
WITH
    CHECK (is_store_staff (id));