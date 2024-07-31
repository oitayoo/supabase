CREATE TYPE product_entity_status AS ENUM(
    'REQUEST PRODUCTION',
    'IN PRODUCTION',
    'AVAILABLE FOR SALE',
    'SOLD',
    'DISPOSED'
);

CREATE TABLE
    product_entities (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
        store_id UUID NOT NULL REFERENCES stores (id),
        product_id UUID NOT NULL REFERENCES products (id),
        created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc', NOW()) NOT NULL
    );

CREATE TABLE
    product_entity_statuses (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
        store_id UUID NOT NULL REFERENCES stores (id),
        product_id UUID NOT NULL REFERENCES products (id),
        product_entity_id UUID NOT NULL REFERENCES product_entities (id),
        status product_entity_status NOT NULL DEFAULT 'AVAILABLE FOR SALE'::product_entity_status,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc', NOW()) NOT NULL
    );

ALTER TABLE product_entities
ADD COLUMN current_product_entity_status_id UUID NOT NULL REFERENCES product_entity_statuses (id);