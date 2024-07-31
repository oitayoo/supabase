CREATE
OR REPLACE FUNCTION create_product_entity (
    target_store_id UUID,
    target_product_id UUID,
    status product_entity_status
) RETURNS product_entities AS $$
DECLARE
    new_product_entity product_entities;
BEGIN
    -- Create a new product entity
    INSERT INTO product_entities (store_id, product_id, created_at)
    VALUES (target_store_id, target_product_id, timezone('utc', now()))
    RETURNING * INTO new_product_entity;

    -- Create a new product entity status
    INSERT INTO product_entity_statuses (store_id, product_id, product_entity_id, value, created_at)
    VALUES (target_store_id, target_product_id, new_product_entity.id, status, timezone('utc', now()));

    -- Update current product entity status id in product_entities table
    UPDATE product_entities
    SET current_product_entity_status_id = new_product_entity.id
    WHERE id = new_product_entity.id;

    RETURN new_product_entity;
END;
$$ LANGUAGE plpgsql;