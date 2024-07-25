CREATE TABLE
    store_staffs (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
        user_id UUID NOT NULL REFERENCES auth.users (id),
        store_id UUID NOT NULL REFERENCES stores (id),
        created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc', NOW()) NOT NULL,
        deleted_at TIMESTAMP WITH TIME ZONE,
        CONSTRAINT uq_user_id_store_id UNIQUE (user_id, store_id)
    );

ALTER TABLE store_staffs ENABLE ROW LEVEL SECURITY;