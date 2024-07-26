ALTER TABLE product_details ENABLE ROW LEVEL SECURITY;

CREATE POLICY "all (select)" ON product_details AS PERMISSIVE FOR
SELECT
    TO public USING (TRUE);

CREATE POLICY "store staff (insert)" ON product_details AS PERMISSIVE FOR INSERT TO authenticated
WITH
    CHECK (is_store_staff (store_id));