CREATE
OR REPLACE FUNCTION search_products_by_code_or_name (target_store_id UUID, query TEXT) RETURNS SETOF products LANGUAGE plpgsql AS $function$
BEGIN
    RETURN QUERY
    SELECT
        p.*
    FROM products p
    LEFT JOIN product_revisions pr ON p.active_product_revision_id = pr.id
    LEFT JOIN product_details pd ON pr.id = pd.product_revision_id
    WHERE p.store_id = target_store_id
    AND (p.code LIKE '%' || query || '%' OR pd.name LIKE '%' || query || '%');
END;
$function$;