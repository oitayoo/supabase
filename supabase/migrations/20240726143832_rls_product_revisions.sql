ALTER TABLE product_revisions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "all (select)" ON product_revisions AS PERMISSIVE FOR
SELECT
    TO public USING (TRUE);

CREATE POLICY "store staff (insert)" ON product_revisions AS PERMISSIVE FOR INSERT TO authenticated
WITH
    CHECK (is_store_staff (store_id));