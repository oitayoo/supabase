CREATE
OR REPLACE FUNCTION is_store_staff_for_one_of_order_products (order_id UUID) RETURNS BOOLEAN AS $$
DECLARE
    is_store_staff boolean;
BEGIN
    SELECT EXISTS(
        SELECT 1
        FROM orders o
        JOIN order_products op ON o.id = op.order_id
        JOIN store_staffs ss ON op.store_id = ss.store_id
        WHERE op.store_id = ss.store_id AND ss.user_id = auth.uid()
    ) INTO is_store_staff;

    RETURN is_store_staff;
END;
$$ LANGUAGE plpgsql;

--- orders policies
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

CREATE POLICY "me or store staff for one of order products (select)" ON orders AS PERMISSIVE FOR
SELECT
    TO authenticated USING (
        is_me (user_id)
        OR is_store_staff_for_one_of_order_products (id)
    );

CREATE POLICY "me (insert)" ON orders AS PERMISSIVE FOR INSERT TO authenticated
WITH
    CHECK (is_me (user_id));

--- order_products policies
ALTER TABLE order_products ENABLE ROW LEVEL SECURITY;

CREATE POLICY "me or store staff (select)" ON order_products AS PERMISSIVE FOR
SELECT
    TO authenticated USING (
        is_me (user_id)
        OR is_store_staff (store_id)
    );

CREATE POLICY "me (insert)" ON order_products AS PERMISSIVE FOR INSERT TO authenticated
WITH
    CHECK (is_me (user_id));

--- order_product_statuses policies
ALTER TABLE order_product_statuses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "me or store staff (select)" ON order_product_statuses AS PERMISSIVE FOR
SELECT
    TO authenticated USING (
        is_me (user_id)
        OR is_store_staff (store_id)
    );

CREATE POLICY "store staff (insert)" ON order_product_statuses AS PERMISSIVE FOR INSERT TO authenticated
WITH
    CHECK (is_store_staff (store_id));