CREATE TABLE
    stores (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
        provisionable_user_id UUID NOT NULL REFERENCES auth.users (id),
        NAME TEXT NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc', NOW()) NOT NULL,
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc', NOW()) NOT NULL,
        deleted_at TIMESTAMP WITH TIME ZONE,
        provisioned_at TIMESTAMP WITH TIME ZONE,
        CONSTRAINT uq_stores_name UNIQUE (NAME)
    );