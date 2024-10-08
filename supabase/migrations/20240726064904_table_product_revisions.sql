CREATE TABLE
    product_revisions (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
        user_id UUID NOT NULL REFERENCES auth.users (id),
        store_id UUID NOT NULL REFERENCES stores (id),
        product_id UUID NOT NULL REFERENCES products (id),
        number BIGSERIAL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc', NOW()) NOT NULL,
        CONSTRAINT uq_product_revisions_number UNIQUE (number)
    );

ALTER TABLE products
ADD COLUMN current_product_revision_id UUID REFERENCES product_revisions (id);