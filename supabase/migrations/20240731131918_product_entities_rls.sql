--- product_entities
ALTER TABLE product_entities ENABLE ROW LEVEL SECURITY;

CREATE POLICY "store_staff (select)" ON product_entities AS PERMISSIVE FOR
SELECT
    TO authenticated USING (is_store_staff (store_id));

CREATE POLICY "store staff (insert)" ON product_entities AS PERMISSIVE FOR INSERT TO authenticated
WITH
    CHECK (
        is_store_staff (store_id)
        AND is_me (user_id)
    );

CREATE POLICY "store staff (update)" ON product_entities AS PERMISSIVE FOR
UPDATE TO authenticated USING (is_store_staff (store_id))
WITH
    CHECK (is_store_staff (store_id));

--- product_entity_comments
ALTER TABLE product_entity_comments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "store staff (select)" ON product_entity_comments AS PERMISSIVE FOR
SELECT
    TO authenticated USING (is_store_staff (store_id));

CREATE POLICY "store staff (insert)" ON product_entity_comments AS PERMISSIVE FOR INSERT TO authenticated
WITH
    CHECK (
        is_store_staff (store_id)
        AND is_me (user_id)
    );

CREATE POLICY "me (update)" ON product_entity_comments AS PERMISSIVE FOR
UPDATE TO authenticated USING (
    is_store_staff (store_id)
    AND is_me (user_id)
)
WITH
    CHECK (
        is_store_staff (store_id)
        AND is_me (user_id)
    );

CREATE POLICY "me (delete)" ON product_entity_comments AS PERMISSIVE FOR DELETE TO authenticated USING (
    is_store_staff (user_id)
    AND is_me (user_id)
);

--- product_entity_statuses
ALTER TABLE product_entity_statuses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "all (select)" ON product_entity_statuses AS PERMISSIVE FOR
SELECT
    TO authenticated USING (is_store_staff (store_id));

CREATE POLICY "store staff (insert)" ON product_entity_statuses AS PERMISSIVE FOR INSERT TO authenticated
WITH
    CHECK (
        is_store_staff (store_id)
        AND is_me (user_id)
    );