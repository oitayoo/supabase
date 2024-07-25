ALTER TABLE products ENABLE ROW LEVEL SECURITY;

CREATE POLICY "all (select)" ON products AS PERMISSIVE FOR
SELECT
    TO public USING (TRUE);

CREATE POLICY "store staff (insert)" ON products AS PERMISSIVE FOR INSERT TO authenticated
WITH
    CHECK (is_store_staff (store_id));

CREATE POLICY "store staff (update)" ON products AS PERMISSIVE FOR
UPDATE TO authenticated USING (is_store_staff (store_id))
WITH
    CHECK (is_store_staff (store_id));