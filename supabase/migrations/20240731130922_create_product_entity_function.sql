CREATE
OR REPLACE FUNCTION create_product_entities (
    target_store_id UUID,
    target_product_id UUID,
    target_type product_entity_status_type,
    target_name TEXT,
    quantity INT
) RETURNS SETOF product_entities AS $$
DECLARE
    new_product_entity product_entities;
    new_product_entity_status product_entity_statuses;
    i INT := 1;
BEGIN
    WHILE i <= quantity LOOP
        -- Create a new product entity
        INSERT INTO product_entities (user_id, store_id, product_id, target_name)
        VALUES (auth.uid(), target_store_id, target_product_id, target_name || ' ' || i)
        RETURNING * INTO new_product_entity;

        -- Create a new product entity status
        INSERT INTO product_entity_statuses (user_id, store_id, product_id, product_entity_id, target_type)
        VALUES (auth.uid(), target_store_id, target_product_id, new_product_entity.id, target_type)
        RETURNING * INTO new_product_entity_status;

        -- Update current product entity status id in product_entities table
        UPDATE product_entities
        SET current_product_entity_status_id = new_product_entity_status.id
        WHERE id = new_product_entity.id;

        RETURN NEXT new_product_entity;
        i := i + 1;
    END LOOP;

    RETURN;
END;
$$ LANGUAGE plpgsql;