CREATE
OR REPLACE FUNCTION get_stores () RETURNS SETOF stores AS $$
BEGIN
    RETURN QUERY
    SELECT s.*
    FROM stores s
    LEFT JOIN store_staffs ss ON s.id = ss.store_id
    WHERE ss.user_id = auth.uid() OR s.provisionable_user_id = auth.uid();
END;
$$ LANGUAGE plpgsql;