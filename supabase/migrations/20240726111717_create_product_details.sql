CREATE TYPE product_image AS (id UUID, main BOOLEAN, INDEX INT);

CREATE TABLE
    product_details (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
        store_id UUID NOT NULL REFERENCES stores (id),
        product_id UUID NOT NULL REFERENCES products (id),
        product_revision_id UUID NOT NULL REFERENCES product_revisions (id),
        NAME TEXT NOT NULL,
        description TEXT NOT NULL,
        images product_image[] NOT NULL DEFAULT '{}'::product_image[],
        explorable BOOLEAN NOT NULL DEFAULT FALSE,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc', NOW()) NOT NULL,
        CONSTRAINT uq_product_per_revision UNIQUE (product_revision_id, product_id)
    );