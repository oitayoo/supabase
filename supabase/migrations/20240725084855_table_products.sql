CREATE TYPE product_status AS ENUM('UNDER REVIEW', 'SALE', 'SOLD OUT');

CREATE TABLE
    products (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
        store_id UUID NOT NULL REFERENCES stores (id),
        status product_status NOT NULL DEFAULT 'UNDER REVIEW'::product_status,
        code TEXT NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc', NOW()) NOT NULL,
        deleted_at TIMESTAMP WITH TIME ZONE,
        CONSTRAINT uq_products_code UNIQUE (code)
    );