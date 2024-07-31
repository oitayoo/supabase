CREATE
OR REPLACE FUNCTION create_product_entities (
    target_store_id UUID,
    target_product_id UUID,
    status product_entity_status,
    quantity INT
) RETURNS SETOF product_entities AS $$
DECLARE
    new_product_entity product_entities;
    i INT := 1;
BEGIN
    WHILE i <= quantity LOOP
        -- Create a new product entity
        INSERT INTO product_entities (store_id, product_id, created_at)
        VALUES (target_store_id, target_product_id, timezone('utc', NOW()))
        RETURNING * INTO new_product_entity;

        -- Create a new product entity status
        INSERT INTO product_entity_statuses (store_id, product_id, product_entity_id, status, created_at)
        VALUES (target_store_id, target_product_id, new_product_entity.id, status, timezone('utc', NOW()));

        -- Update current product entity status id in product_entities table
        UPDATE product_entities
        SET current_product_entity_status_id = new_product_entity.id
        WHERE id = new_product_entity.id;

        RETURN NEXT new_product_entity;
        i := i + 1;
    END LOOP;

    RETURN;
END;
$$ LANGUAGE plpgsql;