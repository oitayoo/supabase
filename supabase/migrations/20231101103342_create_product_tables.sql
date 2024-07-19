CREATE TYPE currency AS ENUM('KRW', 'USD');

CREATE
OR REPLACE FUNCTION product_from_that_shop (target_shop_id UUID, target_product_id UUID) RETURNS BOOLEAN LANGUAGE plpgsql AS $$
BEGIN
  IF target_product_id IS NULL THEN RETURN TRUE; END IF;

  RETURN EXISTS (
    select 1 from products
    where id = target_product_id and shop_id = target_shop_id
  );
END;
$$;

CREATE
OR REPLACE FUNCTION product_feature_from_that_shop (
    target_shop_id UUID,
    target_product_feature_id UUID
) RETURNS BOOLEAN LANGUAGE plpgsql AS $$
BEGIN
  IF target_product_feature_id IS NULL THEN RETURN TRUE; END IF;

  RETURN EXISTS (
    select 1 from product_features
    where id = target_product_feature_id and shop_id = target_shop_id
  );
END;
$$;

CREATE
OR REPLACE FUNCTION product_description_from_that_shop (
    target_shop_id UUID,
    target_product_description_id UUID
) RETURNS BOOLEAN LANGUAGE plpgsql AS $$
BEGIN
  IF target_product_description_id IS NULL THEN RETURN TRUE; END IF;

  RETURN EXISTS (
    select 1 from product_descriptions
    where id = target_product_description_id and shop_id = target_shop_id
  );
END;
$$;

CREATE
OR REPLACE FUNCTION product_price_from_that_shop (target_shop_id UUID, target_product_price_id UUID) RETURNS BOOLEAN LANGUAGE plpgsql AS $$
BEGIN
  IF target_product_price_id IS NULL THEN RETURN TRUE; END IF;

  RETURN EXISTS (
    select 1 from product_prices
    where id = target_product_price_id and shop_id = target_shop_id
  );
END;
$$;

CREATE
OR REPLACE FUNCTION product_entity_from_that_shop (
    target_shop_id UUID,
    target_product_entity_id UUID
) RETURNS BOOLEAN LANGUAGE plpgsql AS $$
BEGIN
  IF target_product_entity_id IS NULL THEN RETURN TRUE; END IF;

  RETURN EXISTS (
    select 1 from product_entities
    where id = target_product_entity_id and shop_id = target_shop_id
  );
END;
$$;

-- 제품
CREATE TYPE product_status AS ENUM('PREPARING', 'SALE', 'SOLD_OUT');

CREATE TABLE
    products (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        shop_id UUID REFERENCES shops NOT NULL,
        current_product_description_id UUID NULL,
        status product_status DEFAULT 'PREPARING' NOT NULL,
        code TEXT NULL,
        NAME TEXT DEFAULT '' NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc'::TEXT, NOW()) NOT NULL,
        deleted_at TIMESTAMP WITH TIME ZONE NULL,
        updated_at TIMESTAMP WITH TIME ZONE NULL
    );

CREATE UNIQUE INDEX products_udx_shop_id_code ON products (shop_id, code);

ALTER TABLE products ENABLE ROW LEVEL SECURITY;

CREATE POLICY "all: mains_admin" ON products TO authenticated USING (mains.admin ())
WITH
    CHECK (mains.admin ());

CREATE POLICY "insert: shop_employee" ON products FOR INSERT TO authenticated
WITH
    CHECK (
        shop_employee (shop_id)
        AND product_description_from_that_shop (shop_id, current_product_description_id)
    );

CREATE POLICY "update: shop_employee" ON products FOR
UPDATE TO authenticated USING (
    shop_employee (shop_id)
    AND product_description_from_that_shop (shop_id, current_product_description_id)
)
WITH
    CHECK (
        shop_employee (shop_id)
        AND product_description_from_that_shop (shop_id, current_product_description_id)
    );

CREATE POLICY "select: all" ON products FOR
SELECT
    TO authenticated,
    anon USING (TRUE);

-- 제품 가격
CREATE TABLE
    product_prices (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        shop_id UUID REFERENCES shops NOT NULL,
        product_id UUID REFERENCES products NOT NULL,
        product_feature_id UUID DEFAULT gen_random_uuid () NOT NULL,
        currency currency DEFAULT 'KRW' NOT NULL,
        amount DECIMAL DEFAULT 0 NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc'::TEXT, NOW()) NOT NULL,
        deleted_at TIMESTAMP WITH TIME ZONE NULL
    );

ALTER TABLE product_prices ENABLE ROW LEVEL SECURITY;

CREATE POLICY "all: mains_admin" ON product_prices TO authenticated USING (mains.admin ())
WITH
    CHECK (mains.admin ());

CREATE POLICY "insert: shop_employee" ON product_prices FOR INSERT TO authenticated
WITH
    CHECK (
        shop_employee (shop_id)
        AND product_from_that_shop (shop_id, product_id)
        AND product_feature_from_that_shop (shop_id, product_feature_id)
    );

CREATE POLICY "update: shop_employee" ON product_prices FOR
UPDATE TO authenticated USING (
    shop_employee (shop_id)
    AND product_from_that_shop (shop_id, product_id)
    AND product_feature_from_that_shop (shop_id, product_feature_id)
)
WITH
    CHECK (
        shop_employee (shop_id)
        AND product_from_that_shop (shop_id, product_id)
        AND product_feature_from_that_shop (shop_id, product_feature_id)
    );

CREATE POLICY "select: all" ON product_prices FOR
SELECT
    TO authenticated,
    anon USING (TRUE);

-- 제품 피처
CREATE TYPE product_feature_type AS ENUM('BASE', 'PARTS');

CREATE TABLE
    product_features (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        shop_id UUID REFERENCES shops NOT NULL,
        product_id UUID REFERENCES products NOT NULL,
        current_product_price_id UUID REFERENCES product_prices NULL,
        TYPE product_feature_type DEFAULT 'BASE' NOT NULL,
        status product_status DEFAULT 'PREPARING' NOT NULL,
        code TEXT NULL,
        NAME TEXT DEFAULT '' NOT NULL,
        amount INT DEFAULT 0 NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc'::TEXT, NOW()) NOT NULL,
        deleted_at TIMESTAMP WITH TIME ZONE NULL
    );

CREATE UNIQUE INDEX product_features_udx_shop_id_product_id_code ON product_features (shop_id, product_id, code);

ALTER TABLE product_features ENABLE ROW LEVEL SECURITY;

ALTER TABLE product_prices
ADD CONSTRAINT products_product_feature_id_fkey FOREIGN KEY (product_feature_id) REFERENCES product_features (id);

CREATE POLICY "all: mains_admin" ON product_features TO authenticated USING (mains.admin ())
WITH
    CHECK (mains.admin ());

CREATE POLICY "insert: shop_employee" ON product_features FOR INSERT TO authenticated
WITH
    CHECK (
        shop_employee (shop_id)
        AND product_from_that_shop (shop_id, product_id)
        AND product_price_from_that_shop (shop_id, current_product_price_id)
    );

CREATE POLICY "update: shop_employee" ON product_features FOR
UPDATE TO authenticated USING (
    shop_employee (shop_id)
    AND product_from_that_shop (shop_id, product_id)
    AND product_price_from_that_shop (shop_id, current_product_price_id)
)
WITH
    CHECK (
        shop_employee (shop_id)
        AND product_from_that_shop (shop_id, product_id)
        AND product_price_from_that_shop (shop_id, current_product_price_id)
    );

CREATE POLICY "select: all" ON product_features FOR
SELECT
    TO authenticated,
    anon USING (TRUE);

CREATE TYPE product_image AS (
    product_feature_id UUID,
    storage_path TEXT,
    alt TEXT,
    representative BOOLEAN,
    display_order INTEGER
);

-- 제품 설명
CREATE TABLE
    product_descriptions (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        shop_id UUID REFERENCES shops NOT NULL,
        product_id UUID REFERENCES products NOT NULL,
        body TEXT DEFAULT '' NOT NULL,
        images product_image[] DEFAULT '{}'::product_image[] NOT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc'::TEXT, NOW()) NOT NULL,
        deleted_at TIMESTAMP WITH TIME ZONE NULL
    );

ALTER TABLE product_descriptions ENABLE ROW LEVEL SECURITY;

ALTER TABLE products
ADD CONSTRAINT products_current_product_description_id_fkey FOREIGN KEY (current_product_description_id) REFERENCES product_descriptions (id) ON DELETE SET NULL;

CREATE POLICY "all: mains_admin" ON product_descriptions TO authenticated USING (mains.admin ())
WITH
    CHECK (mains.admin ());

CREATE POLICY "insert: shop_employee" ON product_descriptions FOR INSERT TO authenticated
WITH
    CHECK (
        shop_employee (shop_id)
        AND product_from_that_shop (shop_id, product_id)
    );

CREATE POLICY "update: shop_employee" ON product_descriptions FOR
UPDATE TO authenticated USING (
    shop_employee (shop_id)
    AND product_from_that_shop (shop_id, product_id)
)
WITH
    CHECK (
        shop_employee (shop_id)
        AND product_from_that_shop (shop_id, product_id)
    );

CREATE POLICY "select: all" ON product_descriptions FOR
SELECT
    TO authenticated,
    anon USING (TRUE);

-- 제품 재고
CREATE TYPE product_entity_status AS ENUM('PURCHASED', 'DELIVERED', 'RETURNED');

CREATE TABLE
    product_entities (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        shop_id UUID REFERENCES shops NOT NULL,
        product_id UUID REFERENCES products NOT NULL,
        product_feature_id UUID REFERENCES product_features NOT NULL,
        code TEXT DEFAULT '' NOT NULL,
        status product_entity_status DEFAULT 'PURCHASED' NOT NULL,
        memo TEXT NULL,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc'::TEXT, NOW()) NOT NULL,
        deleted_at TIMESTAMP WITH TIME ZONE NULL,
        delivery_at TIMESTAMP WITH TIME ZONE NULL,
        returned_at TIMESTAMP WITH TIME ZONE NULL
    );

CREATE UNIQUE INDEX product_entities_udx_shop_id_code ON product_entities (shop_id, code);

ALTER TABLE product_entities ENABLE ROW LEVEL SECURITY;

CREATE POLICY "all: mains_admin" ON product_entities TO authenticated USING (mains.admin ())
WITH
    CHECK (mains.admin ());

CREATE POLICY "insert: shop_employee" ON product_entities FOR INSERT TO authenticated
WITH
    CHECK (
        shop_employee (shop_id)
        AND product_from_that_shop (shop_id, product_id)
        AND product_feature_from_that_shop (shop_id, product_feature_id)
    );

CREATE POLICY "update: shop_employee" ON product_entities FOR
UPDATE TO authenticated USING (
    shop_employee (shop_id)
    AND product_from_that_shop (shop_id, product_id)
    AND product_feature_from_that_shop (shop_id, product_feature_id)
)
WITH
    CHECK (
        shop_employee (shop_id)
        AND product_from_that_shop (shop_id, product_id)
        AND product_feature_from_that_shop (shop_id, product_feature_id)
    );