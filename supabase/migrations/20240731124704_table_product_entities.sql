CREATE TYPE product_entity_status_type AS ENUM(
    'REQUEST',
    'IN PRODUCTION',
    'COMPLETE PRODUCTION',
    'COMMENT'
);

CREATE TABLE
    product_entities (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
        user_id UUID NOT NULL REFERENCES auth.users (id),
        store_id UUID NOT NULL REFERENCES stores (id),
        product_id UUID NOT NULL REFERENCES products (id),
        NAME TEXT,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc', NOW()) NOT NULL,
        deleted_at TIMESTAMP WITH TIME ZONE
    );

CREATE TYPE product_entity_status_image AS (PATH TEXT, alt TEXT, INDEX INT);

CREATE TABLE
    product_entity_statuses (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
        user_id UUID NOT NULL REFERENCES auth.users (id),
        store_id UUID NOT NULL REFERENCES stores (id),
        product_id UUID NOT NULL REFERENCES products (id),
        product_entity_id UUID NOT NULL REFERENCES product_entities (id),
        TYPE product_entity_status_type NOT NULL DEFAULT 'COMMENT'::product_entity_status_type,
        COMMENT TEXT NULL,
        images product_entity_status_image[] NOT NULL DEFAULT '{}'::product_entity_status_image[],
        created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc', NOW()) NOT NULL,
        updated_at TIMESTAMP WITH TIME ZONE,
        deleted_at TIMESTAMP WITH TIME ZONE
    );

ALTER TABLE product_entities
ADD COLUMN current_product_entity_status_id UUID REFERENCES product_entity_statuses (id);