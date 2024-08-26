CREATE TYPE currency AS ENUM('USD', 'EUR', 'JPY', 'GBP', 'KRW');

CREATE TABLE
    product_prices (
        id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
        store_id UUID NOT NULL REFERENCES stores (id),
        product_id UUID NOT NULL REFERENCES products (id),
        product_revision_id UUID NOT NULL REFERENCES product_revisions (id),
        currency currency NOT NULL DEFAULT 'KRW'::currency,
        amount NUMERIC(10, 2) NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc', NOW()) NOT NULL,
        CONSTRAINT uq_product_prices_currency_per_revision UNIQUE (product_revision_id, currency)
    );