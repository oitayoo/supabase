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
        product_price_id UUID NOT NULL REFERENCES product_prices (id),
        product_entity_id UUID NOT NULL REFERENCES product_entities (id),
        created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc', NOW()) NOT NULL,
        CONSTRAINT uq_order_products_product_entity UNIQUE (product_entity_id)
    );

CREATE TYPE order_product_status_type AS ENUM(
    'PAID',
    'PREPARING PRODUCT',
    'PREPARING DELIVERY',
    'DELIVERED',
    'CANCELED',
    'COMMENT'
);

CREATE TABLE
    order_product_statuses (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
        user_id UUID NULL REFERENCES auth.users (id),
        store_id UUID NOT NULL REFERENCES stores (id),
        order_id UUID NOT NULL REFERENCES orders (id),
        product_id UUID NOT NULL REFERENCES products (id),
        order_product_id UUID NOT NULL REFERENCES order_products (id),
        TYPE order_product_status_type NOT NULL DEFAULT 'COMMENT'::order_product_status_type,
        COMMENT TEXT,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc', NOW()) NOT NULL
    );

ALTER TABLE order_products
ADD COLUMN current_order_product_status_id UUID REFERENCES order_product_statuses (id);