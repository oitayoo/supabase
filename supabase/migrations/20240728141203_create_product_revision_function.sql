CREATE TYPE product_price_creatable AS (currency public.currency, amount NUMERIC(10, 2));

CREATE
OR REPLACE FUNCTION create_product_revision (
    target_store_id UUID,
    target_product_id UUID,
    new_name TEXT,
    new_description TEXT,
    new_product_prices product_price_creatable[],
    new_product_images product_image[]
) RETURNS public.product_revisions LANGUAGE plpgsql AS $function$
DECLARE
    new_revision public.product_revisions;
    price_record product_price_creatable;
BEGIN
    -- Create a new row in product_revisions table
    INSERT INTO public.product_revisions (user_id, store_id, product_id)
    VALUES (auth.uid(), target_store_id, target_product_id)
    RETURNING * INTO new_revision;

    -- Create corresponding rows in product_prices table
    FOREACH price_record IN ARRAY new_product_prices
    LOOP
        INSERT INTO public.product_prices (store_id, product_id, product_revision_id, currency, amount)
        VALUES (target_store_id, target_product_id, new_revision.id, price_record.currency, price_record.amount);
    END LOOP;

    -- Create a new row in product_details table
    INSERT INTO public.product_details (store_id, product_id, product_revision_id, name, description, images)
    VALUES (target_store_id, target_product_id, new_revision.id, new_name, new_description, new_product_images);

    -- Update active_product_revision_id in products table
    UPDATE public.products
    SET active_product_revision_id = new_revision.id
    WHERE id = target_product_id;

    RETURN new_revision;
END;
$function$;