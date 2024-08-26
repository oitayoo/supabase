CREATE TYPE profile_image AS (PATH TEXT, alt TEXT);

CREATE TABLE
    profiles (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
        user_id UUID NOT NULL REFERENCES auth.users (id),
        NAME TEXT NOT NULL,
        image profile_image,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc', NOW()) NOT NULL,
        updated_at TIMESTAMP WITH TIME ZONE
    );

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "me or store staff (select)" ON profiles AS PERMISSIVE FOR
SELECT
    TO authenticated USING (
        is_me (user_id)
        OR is_any_store_staff ()
    );

CREATE POLICY "me (insert)" ON profiles AS PERMISSIVE FOR INSERT TO authenticated
WITH
    CHECK (is_me (user_id));

CREATE POLICY "me (update)" ON profiles AS PERMISSIVE FOR
UPDATE TO authenticated USING (is_me (user_id))
WITH
    CHECK (is_me (user_id));