CREATE TABLE
    orders (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
        user_id UUID NOT NULL REFERENCES auth.users (id),
        code TEXT NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc', NOW()) NOT NULL,
        CONSTRAINT uq_orders_code UNIQUE (code)
    );

CREATE TABLE
    order_products (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
        user_id UUID NOT NULL REFERENCES auth.users (id),
        store_id UUID NOT NULL REFERENCES stores (id),
        order_id UUID NOT NULL REFERENCES orders (id),
        product_id UUID NOT NULL REFERENCES products (id),
        product_price_id UUID NOT NULL REFERENCES product_procies (id),
        product_entity_id UUID NOT NULL REFERENCES product_entities (id),
        created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc', NOW()) NOT NULL,
        CONSTRAINT uq_product_entities_order_product UNIQUE (order_product_id)
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
