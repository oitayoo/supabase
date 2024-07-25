CREATE TABLE
    products (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
        code CHAR(6) CONSTRAINT english_chars_only CHECK (code ~ '^[a-zA-Z]{6}$') NOT NULL,
        store_id UUID NOT NULL REFERENCES stores (id),
        created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc', NOW()) NOT NULL,
        deleted_at TIMESTAMP WITH TIME ZONE,
        CONSTRAINT uq_code UNIQUE (code)
    );

ALTER TABLE products ENABLE ROW LEVEL SECURITY;