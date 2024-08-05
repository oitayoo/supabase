CREATE TABLE
    store_staffs (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
        user_id UUID NOT NULL REFERENCES auth.users (id),
        store_id UUID NOT NULL REFERENCES stores (id),
        created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc', NOW()) NOT NULL,
        deleted_at TIMESTAMP WITH TIME ZONE,
        CONSTRAINT uq_store_staffs_user_per_store UNIQUE (store_id, user_id)
    );