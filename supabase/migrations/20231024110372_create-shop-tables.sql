CREATE SCHEMA IF NOT EXISTS mains;

CREATE
OR REPLACE FUNCTION mains.admin () RETURNS BOOLEAN LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN

  RETURN EXISTS (
    select 1 from mains.employees
    where auth.uid() = user_id and 'ADMIN'::mains.employee_role = any(roles)
  );
END;
$$;

CREATE
OR REPLACE FUNCTION mains.employee () RETURNS BOOLEAN LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  RETURN EXISTS (
    select 1 from mains.employees
    where auth.uid() = user_id and ('ADMIN'::mains.employee_role = any(roles) OR 'EMPLOYEE'::mains.employee_role = any(roles))
  );
END;
$$;

CREATE
OR REPLACE FUNCTION shop_owner (target_shop_id UUID) RETURNS BOOLEAN LANGUAGE plpgsql AS $$
BEGIN
  RETURN EXISTS (
    select 1 from shop_employees
    where shop_employees.shop_id = target_shop_id and shop_employees.user_id = auth.uid() and 'OWNER'::shop_employee_role = any(shop_employees.roles)
  );
END;
$$;

CREATE
OR REPLACE FUNCTION shop_admin (target_shop_id UUID) RETURNS BOOLEAN LANGUAGE plpgsql AS $$
BEGIN
  RETURN EXISTS (
    select 1 from shop_employees
    where shop_employees.shop_id = target_shop_id and shop_employees.user_id = auth.uid()
    and ('OWNER'::shop_employee_role = any(shop_employees.roles) or 'ADMIN'::shop_employee_role = any(shop_employees.roles))
  );
END;
$$;

CREATE
OR REPLACE FUNCTION shop_employee (target_shop_id UUID) RETURNS BOOLEAN LANGUAGE plpgsql AS $$
BEGIN
  RETURN EXISTS (
    select 1 from shop_employees
    where shop_employees.shop_id = target_shop_id and shop_employees.user_id = auth.uid()
    and ('OWNER'::shop_employee_role = any(shop_employees.roles) or 'ADMIN'::shop_employee_role = any(shop_employees.roles) or 'EMPLOYEE'::shop_employee_role = any(shop_employees.roles))
  );
END;
$$;

-- 구성원
CREATE TYPE mains.employee_role AS ENUM('ADMIN', 'EMPLOYEE');

CREATE TABLE
  mains.employees (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    user_id UUID REFERENCES auth.users NOT NULL,
    roles mains.employee_role[] DEFAULT '{EMPLOYEE}' NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc'::TEXT, NOW()) NOT NULL
  );

-- 상점
CREATE TABLE
  shops (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    NAME TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc'::TEXT, NOW()) NOT NULL,
    deleted_at TIMESTAMP WITH TIME ZONE NULL
  );

ALTER TABLE shops ENABLE ROW LEVEL SECURITY;

CREATE POLICY "all: mains_admin" ON shops TO authenticated USING (mains.admin ())
WITH
  CHECK (mains.admin ());

CREATE POLICY "update: shop_owner" ON shops FOR
UPDATE TO authenticated USING (shop_owner (id))
WITH
  CHECK (shop_owner (id));

CREATE POLICY "select: all" ON shops FOR
SELECT
  TO authenticated,
  anon USING (TRUE);

CREATE TYPE shop_employee_role AS ENUM('OWNER', 'ADMIN', 'EMPLOYEE');

CREATE TABLE
  shop_employees (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    shop_id UUID REFERENCES shops NOT NULL,
    user_id UUID REFERENCES auth.users NOT NULL,
    roles shop_employee_role[] DEFAULT '{EMPLOYEE}' NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone ('utc'::TEXT, NOW()) NOT NULL
  );

ALTER TABLE shop_employees ENABLE ROW LEVEL SECURITY;

CREATE UNIQUE INDEX shop_employees_udx_shop_id_user_id ON shop_employees (shop_id, user_id);

CREATE POLICY "all: mains_admin" ON shop_employees TO authenticated USING (mains.admin ())
WITH
  CHECK (mains.admin ());

CREATE POLICY "insert: shop_owner, shop_admin" ON shop_employees FOR INSERT TO authenticated
WITH
  CHECK (
    shop_owner (shop_id)
    OR (
      shop_admin (shop_id)
      AND 'OWNER'::shop_employee_role != ANY (roles) -- OWNER 역할 지정은 상점 오너 또는 시스템 관리자만 가능하다.
    )
  );

CREATE POLICY "update: shop_owner, shop_admin" ON shop_employees FOR
UPDATE TO authenticated USING (
  shop_owner (shop_id)
  OR (
    shop_admin (shop_id)
    AND 'OWNER'::shop_employee_role != ANY (roles)
  )
)
WITH
  CHECK (
    shop_owner (shop_id)
    OR (
      shop_admin (shop_id)
      AND 'OWNER'::shop_employee_role != ANY (roles)
    )
  );

CREATE POLICY "delete: shop_owner, shop_admin" ON shop_employees FOR DELETE TO authenticated USING (
  shop_owner (shop_id)
  OR (
    shop_admin (shop_id)
    AND 'OWNER'::shop_employee_role != ANY (roles) -- OWNER 역할 해제는 상점 오너 또는 시스템 관리자만 가능하다.
  )
);

CREATE POLICY "select: all" ON shop_employees FOR
SELECT
  TO authenticated,
  anon USING (TRUE);