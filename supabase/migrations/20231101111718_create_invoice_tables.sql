CREATE
OR REPLACE FUNCTION invoice_from_that_purchasable (
    target_purchasable_id UUID,
    target_invoice_id UUID
) RETURNS BOOLEAN LANGUAGE plpgsql AS $$
BEGIN
  IF target_invoice_id IS NULL THEN RETURN TRUE; END IF;

  RETURN EXISTS (
    select 1 from invoices
    where purchasables.id = target_purchasable_id and id = target_invoice_id
  );
END;
$$;

CREATE
OR REPLACE FUNCTION invoice_paid (target_invoice_id UUID) RETURNS BOOLEAN LANGUAGE plpgsql AS $$
BEGIN
  RETURN EXISTS (
    select 1 from invoices, receipts
    where invoices.id = target_invoice_id and invoices.id = receipts.invoice_id and receipts.status = 'PAID'
  );
END;
$$;

-- 인보이스
CREATE TYPE product_entities_with_price AS (product_entity_id UUID, product_price_id UUID);

CREATE TABLE
    invoices (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        purchasable_id UUID REFERENCES purchasables NOT NULL,
        purchasable_cart_id UUID REFERENCES purchasable_carts NOT NULL,
        purchasable_coupon_id UUID REFERENCES purchasable_coupons NULL,
        product_entity_ids product_entities_with_price[] DEFAULT '{}' NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc'::TEXT, NOW()) NOT NULL
    );

CREATE UNIQUE INDEX invoices_udx_purchasable_cart_id ON invoices (purchasable_cart_id);

ALTER TABLE invoices ENABLE ROW LEVEL SECURITY;

CREATE POLICY "all: mains_admin" ON invoices TO authenticated USING (mains.admin ())
WITH
    CHECK (mains.admin ());

CREATE POLICY "insert: me, anonymous" ON invoices FOR INSERT TO authenticated,
anon
WITH
    CHECK (
        me_or_anonymous (purchasable_id)
        AND purchasable_cart_from_that_purchasable (purchasable_id, purchasable_cart_id)
        AND purchasable_coupon_from_that_purchasable (purchasable_id, purchasable_coupon_id)
    );

CREATE POLICY "select: me, anonymous" ON invoices FOR
SELECT
    TO authenticated,
    anon USING (me_or_anonymous (purchasable_id));

-- 영수증
CREATE TYPE receipt_status AS ENUM('PAID', 'FAILED');

CREATE TABLE
    receipts (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        invoice_id UUID REFERENCES invoices NOT NULL,
        purchasable_id UUID REFERENCES purchasables NOT NULL,
        purchasable_cart_id UUID REFERENCES purchasable_carts NOT NULL,
        status receipt_status DEFAULT 'FAILED' NOT NULL,
        success_log JSONB NULL,
        failure_log JSONB NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc'::TEXT, NOW()) NOT NULL
    );

ALTER TABLE receipts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "all: mains_admin" ON receipts TO authenticated USING (mains.admin ())
WITH
    CHECK (mains.admin ());

CREATE POLICY "select: me, anonymous" ON receipts FOR
SELECT
    TO authenticated,
    anon USING (
        me_or_anonymous (purchasable_id)
        AND invoice_from_that_purchasable (purchasable_id, invoice_id)
        AND purchasable_cart_from_that_purchasable (purchasable_id, purchasable_cart_id)
    );

-- 배송지
CREATE TABLE
    delivery_addresses (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        invoice_id UUID REFERENCES invoices NOT NULL,
        purchasable_id UUID REFERENCES purchasables NOT NULL,
        purchasable_cart_id UUID REFERENCES purchasable_carts NOT NULL,
        purchasable_address_id UUID REFERENCES purchasable_addresses NULL,
        country TEXT DEFAULT 'KR' NOT NULL,
        state TEXT DEFAULT '' NOT NULL,
        city TEXT DEFAULT '' NOT NULL,
        zip TEXT DEFAULT '' NOT NULL,
        address_1 TEXT DEFAULT '' NOT NULL,
        address_2 TEXT NULL,
        latitude DOUBLE PRECISION NULL,
        longitude DOUBLE PRECISION NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc'::TEXT, NOW()) NOT NULL
    );

CREATE UNIQUE INDEX delivery_addresses_udx_invoice_id ON delivery_addresses (invoice_id);

ALTER TABLE delivery_addresses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "all: mains_admin" ON delivery_addresses TO authenticated USING (mains.admin ())
WITH
    CHECK (mains.admin ());

CREATE POLICY "insert: me, anonymous" ON delivery_addresses FOR INSERT TO authenticated,
anon
WITH
    CHECK (
        me_or_anonymous (purchasable_id)
        AND invoice_from_that_purchasable (purchasable_id, invoice_id)
        AND purchasable_cart_from_that_purchasable (purchasable_id, purchasable_cart_id)
        AND purchasable_address_from_that_purchasable (purchasable_id, purchasable_address_id)
    );

CREATE POLICY "update: me, anonymous" ON delivery_addresses FOR
UPDATE TO authenticated,
anon USING (
    me_or_anonymous (purchasable_id)
    AND NOT invoice_paid (invoice_id)
    AND invoice_from_that_purchasable (purchasable_id, invoice_id)
    AND purchasable_cart_from_that_purchasable (purchasable_id, purchasable_cart_id)
    AND purchasable_address_from_that_purchasable (purchasable_id, purchasable_address_id)
)
WITH
    CHECK (
        me_or_anonymous (purchasable_id)
        AND NOT invoice_paid (invoice_id)
        AND invoice_from_that_purchasable (purchasable_id, invoice_id)
        AND purchasable_cart_from_that_purchasable (purchasable_id, purchasable_cart_id)
        AND purchasable_address_from_that_purchasable (purchasable_id, purchasable_address_id)
    );

CREATE POLICY "select: me, anonymous" ON delivery_addresses FOR
SELECT
    TO authenticated,
    anon USING (me_or_anonymous (purchasable_id));