CREATE
OR REPLACE FUNCTION me_or_anonymous (target_purchasable_id UUID) RETURNS BOOLEAN LANGUAGE plpgsql AS $$
BEGIN
  RETURN EXISTS (
    select 1 from purchasables
    where ((purchasables.user_id = auth.uid() and type = 'AUTHORIZED') or (purchasables.user_id is null and type = 'ANONYMOUS')) and purchasables.id = target_purchasable_id
  );
END;
$$;

CREATE
OR REPLACE FUNCTION purchasable_cart_no_invoice (target_purchasable_cart_id UUID) RETURNS BOOLEAN LANGUAGE plpgsql AS $$
BEGIN
  RETURN NOT EXISTS (
    select 1 from invoices
    where purchasable_cart_id = target_purchasable_cart_id
  );
END;
$$;

CREATE
OR REPLACE FUNCTION purchasable_cart_from_that_purchasable (
  target_purchasable_id UUID,
  target_purchasable_cart_id UUID
) RETURNS BOOLEAN LANGUAGE plpgsql AS $$
BEGIN
  IF target_purchasable_cart_id IS NULL THEN RETURN TRUE; END IF;

  RETURN EXISTS (
    select 1 from purchasable_carts
    where purchasable_id = target_purchasable_id and id = target_purchasable_cart_id
  );
END;
$$;

CREATE
OR REPLACE FUNCTION purchasable_cart_item_from_that_purchasable (
  target_purchasable_id UUID,
  target_purchasable_cart_item_id UUID
) RETURNS BOOLEAN LANGUAGE plpgsql AS $$
BEGIN
  IF target_purchasable_cart_item_id IS NULL THEN RETURN TRUE; END IF;

  RETURN EXISTS (
    select 1 from purchasable_cart_items
    where purchasable_id = target_purchasable_id and id = target_purchasable_cart_item_id
  );
END;
$$;

CREATE
OR REPLACE FUNCTION purchasable_address_from_that_purchasable (
  target_purchasable_id UUID,
  target_purchasable_address_id UUID
) RETURNS BOOLEAN LANGUAGE plpgsql AS $$
BEGIN
  IF target_purchasable_address_id IS NULL THEN RETURN TRUE; END IF;

  RETURN EXISTS (
    select 1 from purchasable_addresses
    where purchasable_id = target_purchasable_id and id = target_purchasable_address_id
  );
END;
$$;

CREATE
OR REPLACE FUNCTION purchasable_coupon_from_that_purchasable (
  target_purchasable_id UUID,
  target_purchasable_coupon_id UUID
) RETURNS BOOLEAN LANGUAGE plpgsql AS $$
BEGIN
  IF target_purchasable_coupon_id IS NULL THEN RETURN TRUE; END IF;

  RETURN EXISTS (
    select 1 from purchasable_coupons
    where purchasable_id = target_purchasable_id and id = target_purchasable_coupon_id
  );
END;
$$;

-- 구매자
CREATE TYPE purchasable_type AS ENUM('ANONYMOUS', 'AUTHORIZED');

CREATE TABLE
  purchasables (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    user_id UUID REFERENCES auth.users NULL,
    TYPE purchasable_type DEFAULT 'ANONYMOUS' NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc'::TEXT, NOW()) NOT NULL,
    authorized_at TIMESTAMP WITH TIME ZONE NULL
  );

ALTER TABLE purchasables ENABLE ROW LEVEL SECURITY;

CREATE POLICY "all: mains_admin" ON purchasables TO authenticated USING (TRUE)
WITH
  CHECK (TRUE);

CREATE POLICY "insert: me, anonymous" ON purchasables FOR INSERT TO authenticated,
anon
WITH
  CHECK (
    (
      auth.uid () = user_id
      AND
      TYPE = 'AUTHORIZED'
      AND authorized_at IS NOT NULL
    )
    OR (
      user_id IS NULL
      AND
      TYPE = 'ANONYMOUS'
      AND authorized_at IS NULL
    )
  );

CREATE POLICY "update: me, anonymous" ON purchasables FOR
UPDATE TO authenticated,
anon USING (
  (
    auth.uid () = user_id
    AND
    TYPE = 'AUTHORIZED'
    AND authorized_at IS NOT NULL
  )
  OR (
    user_id IS NULL
    AND
    TYPE = 'ANONYMOUS'
    AND authorized_at IS NULL
  )
)
WITH
  CHECK (
    (
      auth.uid () = user_id
      AND
      TYPE = 'AUTHORIZED'
      AND authorized_at IS NOT NULL
    )
    OR (
      user_id IS NULL
      AND
      TYPE = 'ANONYMOUS'
      AND authorized_at IS NULL
    )
  );

CREATE POLICY "select: me, anonymous" ON purchasables FOR
SELECT
  TO authenticated,
  anon USING (
    (
      auth.uid () = user_id
      AND
      TYPE = 'AUTHORIZED'
      AND authorized_at IS NOT NULL
    )
    OR (
      user_id IS NULL
      AND
      TYPE = 'ANONYMOUS'
      AND authorized_at IS NULL
    )
  );

-- 장바구니
CREATE TYPE purchasable_cart_status AS ENUM('PUTTING', 'PURCHASED');

CREATE TABLE
  purchasable_carts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    purchasable_id UUID REFERENCES purchasables NOT NULL,
    status purchasable_cart_status DEFAULT 'PUTTING' NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc'::TEXT, NOW()) NOT NULL,
    purchased_at TIMESTAMP WITH TIME ZONE NULL
  );

ALTER TABLE purchasable_carts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "insert: me, anonymous" ON purchasable_carts FOR INSERT TO authenticated,
anon
WITH
  CHECK (
    me_or_anonymous (purchasable_id)
    AND purchasable_cart_no_invoice (id)
  );

CREATE POLICY "update: me, anonymous" ON purchasable_carts FOR
UPDATE TO authenticated,
anon USING (
  me_or_anonymous (purchasable_id)
  AND purchasable_cart_no_invoice (id)
)
WITH
  CHECK (
    me_or_anonymous (purchasable_id)
    AND purchasable_cart_no_invoice (id)
  );

CREATE POLICY "select: me, anonymous" ON purchasable_carts FOR
SELECT
  TO authenticated,
  anon USING (me_or_anonymous (purchasable_id));

-- 카트 항목
CREATE TABLE
  purchasable_cart_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    product_id UUID REFERENCES products NOT NULL,
    product_feature_id UUID REFERENCES product_features NOT NULL,
    purchasable_id UUID REFERENCES purchasables NOT NULL,
    purchasable_cart_id UUID REFERENCES purchasable_carts NOT NULL,
    qty INT DEFAULT 1 NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc'::TEXT, NOW()) NOT NULL,
    deleted_at TIMESTAMP WITH TIME ZONE NULL,
    updated_at TIMESTAMP WITH TIME ZONE NULL
  );

CREATE UNIQUE INDEX purchasable_cart_items_udx_purchasable_cart_id_product_feature_id ON purchasable_cart_items (purchasable_cart_id, product_feature_id);

ALTER TABLE purchasable_cart_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "insert: me, anonymous" ON purchasable_cart_items FOR INSERT TO authenticated,
anon
WITH
  CHECK (
    me_or_anonymous (purchasable_id)
    AND purchasable_cart_no_invoice (purchasable_cart_id)
  );

CREATE POLICY "update: me, anonymous" ON purchasable_cart_items FOR
UPDATE TO authenticated,
anon USING (
  me_or_anonymous (purchasable_id)
  AND purchasable_cart_no_invoice (purchasable_cart_id)
)
WITH
  CHECK (
    me_or_anonymous (purchasable_id)
    AND purchasable_cart_no_invoice (purchasable_cart_id)
  );

CREATE POLICY "select: me, anonymous" ON purchasable_cart_items FOR
SELECT
  TO authenticated,
  anon USING (me_or_anonymous (purchasable_id));

-- 구매자 주소
CREATE TABLE
  purchasable_addresses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    purchasable_id UUID REFERENCES purchasables NOT NULL,
    country TEXT DEFAULT 'KR' NOT NULL,
    state TEXT DEFAULT '' NOT NULL,
    city TEXT DEFAULT '' NOT NULL,
    zip TEXT DEFAULT '' NOT NULL,
    address_1 TEXT DEFAULT '' NOT NULL,
    address_2 TEXT NULL,
    latitude DOUBLE PRECISION NULL,
    longitude DOUBLE PRECISION NULL,
    display_order INTEGER DEFAULT 0 NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc'::TEXT, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE NULL,
    deleted_at TIMESTAMP WITH TIME ZONE NULL
  );

ALTER TABLE purchasable_addresses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "insert: me, anonymous" ON purchasable_addresses FOR INSERT TO authenticated,
anon
WITH
  CHECK (me_or_anonymous (purchasable_id));

CREATE POLICY "update: me, anonymous" ON purchasable_addresses FOR
UPDATE TO authenticated,
anon USING (me_or_anonymous (purchasable_id))
WITH
  CHECK (me_or_anonymous (purchasable_id));

CREATE POLICY "select: me, anonymous" ON purchasable_addresses FOR
SELECT
  TO authenticated,
  anon USING (me_or_anonymous (purchasable_id));

-- 쿠폰
CREATE TYPE coupon_status AS ENUM('ENABLED', 'DISABLED');

CREATE TYPE coupon_amount_unit AS ENUM('PERCENT', 'CURRENCY');

CREATE TABLE
  coupons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    status coupon_status DEFAULT 'ENABLED' NOT NULL,
    NAME TEXT DEFAULT '' NOT NULL,
    amount DECIMAL DEFAULT 0 NOT NULL,
    amount_unit coupon_amount_unit DEFAULT 'PERCENT' NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc'::TEXT, NOW()) NOT NULL
  );

ALTER TABLE coupons ENABLE ROW LEVEL SECURITY;

CREATE POLICY "all: mains_admin" ON coupons TO authenticated USING (mains.admin ())
WITH
  CHECK (mains.admin ());

-- 구매자 쿠폰
CREATE TYPE purchasable_coupon_status AS ENUM('UNUSED', 'USED');

CREATE TABLE
  purchasable_coupons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    coupon_id UUID REFERENCES coupons NOT NULL,
    purchasable_id UUID REFERENCES purchasables NOT NULL,
    status purchasable_coupon_status DEFAULT 'UNUSED' NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc'::TEXT, NOW()) NOT NULL,
    expired_at TIMESTAMP WITH TIME ZONE NULL
  );

ALTER TABLE purchasable_coupons ENABLE ROW LEVEL SECURITY;

CREATE POLICY "all: mains_admin" ON purchasable_coupons TO authenticated USING (mains.admin ())
WITH
  CHECK (mains.admin ());

CREATE POLICY "select: me, anonymous" ON purchasable_coupons FOR
SELECT
  TO authenticated,
  anon USING (me_or_anonymous (purchasable_id));

CREATE POLICY "update: me, anonymous" ON purchasable_coupons FOR
SELECT
  TO authenticated,
  anon USING (
    me_or_anonymous (purchasable_id)
    AND status = 'UNUSED'
    AND expired_at < NOW()
  );