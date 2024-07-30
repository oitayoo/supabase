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
    -- product_revisions 테이블에 새로운 행 생성
    INSERT INTO public.product_revisions (user_id, store_id, product_id, created_at)
    VALUES (auth.uid(), target_store_id, target_product_id, timezone('utc', now()))
    RETURNING * INTO new_revision;

    -- product_prices 테이블에 해당하는 행 생성
    FOREACH price_record IN ARRAY new_product_prices
    LOOP
        INSERT INTO public.product_prices (store_id, product_id, product_revision_id, currency, amount, created_at)
        VALUES (target_store_id, target_product_id, new_revision.id, price_record.currency, price_record.amount, timezone('utc', now()));
    END LOOP;

    -- product_details 테이블에 새로운 행 생성
    INSERT INTO public.product_details (store_id, product_id, product_revision_id, name, description, images, created_at)
    VALUES (target_store_id, target_product_id, new_revision.id, new_name, new_description, new_product_images, timezone('utc', now()));

    -- products 테이블에서 active_product_revision_id 업데이트
    UPDATE public.products
    SET active_product_revision_id = new_revision.id
    WHERE id = target_product_id;

    RETURN new_revision;
END;
$function$;