CREATE
OR REPLACE FUNCTION is_me (user_id UUID) RETURNS BOOLEAN AS $$
BEGIN
    RETURN user_id = auth.uid();
END;
$$ LANGUAGE plpgsql;