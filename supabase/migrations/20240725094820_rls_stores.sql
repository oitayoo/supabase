ALTER TABLE stores ENABLE ROW LEVEL SECURITY;

CREATE POLICY "all (select)" ON stores AS PERMISSIVE FOR
SELECT
    TO public USING (TRUE);

CREATE POLICY "store staff (update)" ON stores AS PERMISSIVE FOR
UPDATE TO authenticated USING (is_store_staff (id))
WITH
    CHECK (is_store_staff (id));

ALTER TABLE store_staffs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "all (select)" ON store_staffs AS PERMISSIVE FOR
SELECT
    TO public USING (TRUE);

CREATE POLICY "store staff (insert)" ON store_staffs AS PERMISSIVE FOR INSERT TO authenticated
WITH
    CHECK (is_store_staff (store_id));

CREATE POLICY "store staff (delete)" ON store_staffs AS PERMISSIVE FOR DELETE TO authenticated USING (is_store_staff (store_id));