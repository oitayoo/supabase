CREATE TABLE
    orders (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
        user_id UUID NOT NULL REFERENCES auth.users (id),
        created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc', NOW()) NOT NULL
    );

CREATE TABLE
    order_products (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
        user_id UUID NOT NULL REFERENCES auth.users (id),
        store_id UUID NOT NULL REFERENCES stores (id),
        order_id UUID NOT NULL REFERENCES orders (id),
        product_id UUID NOT NULL REFERENCES products (id),
        created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc', NOW()) NOT NULL
    );

CREATE TYPE order_product_status_type AS ENUM(
    'PAID',
    'PREPARING PRODUCT',
    'PREPARING FOR DELIVERY',
    'DELIVERED',
    'CANCELED'
);

CREATE TABLE
    order_product_statuses (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
        user_id UUID NULL REFERENCES auth.users (id),
        store_id UUID NOT NULL REFERENCES stores (id),
        order_id UUID NOT NULL REFERENCES orders (id),
        product_id UUID NOT NULL REFERENCES products (id),
        order_product_id UUID NOT NULL REFERENCES order_products (id),
        TYPE order_product_status_type NOT NULL DEFAULT 'PAID'::order_product_status_type,
        COMMENT TEXT,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc', NOW()) NOT NULL
    );

ALTER TABLE order_products
ADD COLUMN current_order_product_status_id UUID REFERENCES order_product_statuses (id);

ALTER TABLE product_entities
ADD COLUMN order_product_id UUID REFERENCES order_products (id);