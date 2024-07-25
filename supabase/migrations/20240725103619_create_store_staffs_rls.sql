ALTER TABLE store_staffs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "store staff (select)" ON store_staffs AS PERMISSIVE FOR
SELECT
    TO authenticated USING (is_store_staff (id));

CREATE POLICY "store staff (insert)" ON store_staffs AS PERMISSIVE FOR INSERT TO authenticated
WITH
    CHECK (is_store_staff (id));

CREATE POLICY "store staff (delete)" ON store_staffs AS PERMISSIVE FOR DELETE TO authenticated USING (is_store_staff (id));