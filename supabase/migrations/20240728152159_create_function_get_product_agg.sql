CREATE
OR REPLACE FUNCTION get_products_by_active (target_product_ids UUID[]) RETURNS product_aggregation LANGUAGE plpgsql AS $function$
DECLARE
    product_record product_aggregation;
BEGIN
    SELECT array_agg(products), array_agg(product_details), array_agg(product_prices)
    INTO product_record.products, product_record.product_details, product_record.product_prices
    FROM public.products
    LEFT JOIN public.product_details ON products.active_product_revision_id = product_details.product_revision_id
    LEFT JOIN public.product_prices ON products.id = product_prices.product_id AND product_details.product_revision_id = product_prices.product_revision_id
    WHERE products.id = ANY(target_product_ids)
    GROUP BY products.id;

    RETURN product_record;
END;
$function$;