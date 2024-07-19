export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  graphql_public: {
    Tables: {
      [_ in never]: never
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      graphql: {
        Args: {
          operationName?: string
          query?: string
          variables?: Json
          extensions?: Json
        }
        Returns: Json
      }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
  public: {
    Tables: {
      coupons: {
        Row: {
          amount: number
          amount_unit: Database["public"]["Enums"]["coupon_amount_unit"]
          created_at: string
          id: string
          name: string
          status: Database["public"]["Enums"]["coupon_status"]
        }
        Insert: {
          amount?: number
          amount_unit?: Database["public"]["Enums"]["coupon_amount_unit"]
          created_at?: string
          id?: string
          name?: string
          status?: Database["public"]["Enums"]["coupon_status"]
        }
        Update: {
          amount?: number
          amount_unit?: Database["public"]["Enums"]["coupon_amount_unit"]
          created_at?: string
          id?: string
          name?: string
          status?: Database["public"]["Enums"]["coupon_status"]
        }
        Relationships: []
      }
      delivery_addresses: {
        Row: {
          address_1: string
          address_2: string | null
          city: string
          country: string
          created_at: string
          id: string
          invoice_id: string
          latitude: number | null
          longitude: number | null
          purchasable_address_id: string | null
          purchasable_cart_id: string
          purchasable_id: string
          state: string
          zip: string
        }
        Insert: {
          address_1?: string
          address_2?: string | null
          city?: string
          country?: string
          created_at?: string
          id?: string
          invoice_id: string
          latitude?: number | null
          longitude?: number | null
          purchasable_address_id?: string | null
          purchasable_cart_id: string
          purchasable_id: string
          state?: string
          zip?: string
        }
        Update: {
          address_1?: string
          address_2?: string | null
          city?: string
          country?: string
          created_at?: string
          id?: string
          invoice_id?: string
          latitude?: number | null
          longitude?: number | null
          purchasable_address_id?: string | null
          purchasable_cart_id?: string
          purchasable_id?: string
          state?: string
          zip?: string
        }
        Relationships: [
          {
            foreignKeyName: "delivery_addresses_invoice_id_fkey"
            columns: ["invoice_id"]
            referencedRelation: "invoices"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "delivery_addresses_purchasable_address_id_fkey"
            columns: ["purchasable_address_id"]
            referencedRelation: "purchasable_addresses"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "delivery_addresses_purchasable_cart_id_fkey"
            columns: ["purchasable_cart_id"]
            referencedRelation: "purchasable_carts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "delivery_addresses_purchasable_id_fkey"
            columns: ["purchasable_id"]
            referencedRelation: "purchasables"
            referencedColumns: ["id"]
          }
        ]
      }
      invoices: {
        Row: {
          created_at: string
          id: string
          product_entity_ids: Database["public"]["CompositeTypes"]["product_entities_with_price"][]
          purchasable_cart_id: string
          purchasable_coupon_id: string | null
          purchasable_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          product_entity_ids?: Database["public"]["CompositeTypes"]["product_entities_with_price"][]
          purchasable_cart_id: string
          purchasable_coupon_id?: string | null
          purchasable_id: string
        }
        Update: {
          created_at?: string
          id?: string
          product_entity_ids?: Database["public"]["CompositeTypes"]["product_entities_with_price"][]
          purchasable_cart_id?: string
          purchasable_coupon_id?: string | null
          purchasable_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "invoices_purchasable_cart_id_fkey"
            columns: ["purchasable_cart_id"]
            referencedRelation: "purchasable_carts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "invoices_purchasable_coupon_id_fkey"
            columns: ["purchasable_coupon_id"]
            referencedRelation: "purchasable_coupons"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "invoices_purchasable_id_fkey"
            columns: ["purchasable_id"]
            referencedRelation: "purchasables"
            referencedColumns: ["id"]
          }
        ]
      }
      product_descriptions: {
        Row: {
          body: string
          created_at: string
          deleted_at: string | null
          id: string
          images: Database["public"]["CompositeTypes"]["product_image"][]
          product_id: string
          shop_id: string
        }
        Insert: {
          body?: string
          created_at?: string
          deleted_at?: string | null
          id?: string
          images?: Database["public"]["CompositeTypes"]["product_image"][]
          product_id: string
          shop_id: string
        }
        Update: {
          body?: string
          created_at?: string
          deleted_at?: string | null
          id?: string
          images?: Database["public"]["CompositeTypes"]["product_image"][]
          product_id?: string
          shop_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "product_descriptions_product_id_fkey"
            columns: ["product_id"]
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "product_descriptions_shop_id_fkey"
            columns: ["shop_id"]
            referencedRelation: "shops"
            referencedColumns: ["id"]
          }
        ]
      }
      product_entities: {
        Row: {
          code: string
          created_at: string
          deleted_at: string | null
          delivery_at: string | null
          delivery_status: Database["public"]["Enums"]["product_entity_delivery_status"]
          id: string
          memo: string | null
          product_feature_id: string
          product_id: string
          returned_at: string | null
          shop_id: string
        }
        Insert: {
          code?: string
          created_at?: string
          deleted_at?: string | null
          delivery_at?: string | null
          delivery_status?: Database["public"]["Enums"]["product_entity_delivery_status"]
          id?: string
          memo?: string | null
          product_feature_id: string
          product_id: string
          returned_at?: string | null
          shop_id: string
        }
        Update: {
          code?: string
          created_at?: string
          deleted_at?: string | null
          delivery_at?: string | null
          delivery_status?: Database["public"]["Enums"]["product_entity_delivery_status"]
          id?: string
          memo?: string | null
          product_feature_id?: string
          product_id?: string
          returned_at?: string | null
          shop_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "product_entities_product_feature_id_fkey"
            columns: ["product_feature_id"]
            referencedRelation: "product_features"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "product_entities_product_id_fkey"
            columns: ["product_id"]
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "product_entities_shop_id_fkey"
            columns: ["shop_id"]
            referencedRelation: "shops"
            referencedColumns: ["id"]
          }
        ]
      }
      product_features: {
        Row: {
          code: string | null
          created_at: string
          current_product_price_id: string | null
          deleted_at: string | null
          id: string
          name: string
          product_id: string
          shop_id: string
          status: Database["public"]["Enums"]["product_status"]
          type: Database["public"]["Enums"]["product_feature_type"]
        }
        Insert: {
          code?: string | null
          created_at?: string
          current_product_price_id?: string | null
          deleted_at?: string | null
          id?: string
          name?: string
          product_id: string
          shop_id: string
          status?: Database["public"]["Enums"]["product_status"]
          type?: Database["public"]["Enums"]["product_feature_type"]
        }
        Update: {
          code?: string | null
          created_at?: string
          current_product_price_id?: string | null
          deleted_at?: string | null
          id?: string
          name?: string
          product_id?: string
          shop_id?: string
          status?: Database["public"]["Enums"]["product_status"]
          type?: Database["public"]["Enums"]["product_feature_type"]
        }
        Relationships: [
          {
            foreignKeyName: "product_features_current_product_price_id_fkey"
            columns: ["current_product_price_id"]
            referencedRelation: "product_prices"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "product_features_product_id_fkey"
            columns: ["product_id"]
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "product_features_shop_id_fkey"
            columns: ["shop_id"]
            referencedRelation: "shops"
            referencedColumns: ["id"]
          }
        ]
      }
      product_prices: {
        Row: {
          amount: number
          created_at: string
          currency: Database["public"]["Enums"]["currency"]
          deleted_at: string | null
          id: string
          product_feature_id: string
          product_id: string
          shop_id: string
        }
        Insert: {
          amount?: number
          created_at?: string
          currency?: Database["public"]["Enums"]["currency"]
          deleted_at?: string | null
          id?: string
          product_feature_id?: string
          product_id: string
          shop_id: string
        }
        Update: {
          amount?: number
          created_at?: string
          currency?: Database["public"]["Enums"]["currency"]
          deleted_at?: string | null
          id?: string
          product_feature_id?: string
          product_id?: string
          shop_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "product_prices_product_id_fkey"
            columns: ["product_id"]
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "product_prices_shop_id_fkey"
            columns: ["shop_id"]
            referencedRelation: "shops"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "products_product_feature_id_fkey"
            columns: ["product_feature_id"]
            referencedRelation: "product_features"
            referencedColumns: ["id"]
          }
        ]
      }
      products: {
        Row: {
          code: string | null
          created_at: string
          current_product_description_id: string | null
          deleted_at: string | null
          id: string
          name: string
          shop_id: string
          status: Database["public"]["Enums"]["product_status"]
          updated_at: string | null
        }
        Insert: {
          code?: string | null
          created_at?: string
          current_product_description_id?: string | null
          deleted_at?: string | null
          id?: string
          name?: string
          shop_id: string
          status?: Database["public"]["Enums"]["product_status"]
          updated_at?: string | null
        }
        Update: {
          code?: string | null
          created_at?: string
          current_product_description_id?: string | null
          deleted_at?: string | null
          id?: string
          name?: string
          shop_id?: string
          status?: Database["public"]["Enums"]["product_status"]
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "products_current_product_description_id_fkey"
            columns: ["current_product_description_id"]
            referencedRelation: "product_descriptions"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "products_shop_id_fkey"
            columns: ["shop_id"]
            referencedRelation: "shops"
            referencedColumns: ["id"]
          }
        ]
      }
      purchasable_addresses: {
        Row: {
          address_1: string
          address_2: string | null
          city: string
          country: string
          created_at: string
          deleted_at: string | null
          display_order: number
          id: string
          latitude: number | null
          longitude: number | null
          purchasable_id: string
          state: string
          updated_at: string | null
          zip: string
        }
        Insert: {
          address_1?: string
          address_2?: string | null
          city?: string
          country?: string
          created_at?: string
          deleted_at?: string | null
          display_order?: number
          id?: string
          latitude?: number | null
          longitude?: number | null
          purchasable_id: string
          state?: string
          updated_at?: string | null
          zip?: string
        }
        Update: {
          address_1?: string
          address_2?: string | null
          city?: string
          country?: string
          created_at?: string
          deleted_at?: string | null
          display_order?: number
          id?: string
          latitude?: number | null
          longitude?: number | null
          purchasable_id?: string
          state?: string
          updated_at?: string | null
          zip?: string
        }
        Relationships: [
          {
            foreignKeyName: "purchasable_addresses_purchasable_id_fkey"
            columns: ["purchasable_id"]
            referencedRelation: "purchasables"
            referencedColumns: ["id"]
          }
        ]
      }
      purchasable_cart_items: {
        Row: {
          created_at: string
          deleted_at: string | null
          id: string
          product_feature_id: string
          product_id: string
          purchasable_cart_id: string
          purchasable_id: string
          qty: number
          updated_at: string | null
        }
        Insert: {
          created_at?: string
          deleted_at?: string | null
          id?: string
          product_feature_id: string
          product_id: string
          purchasable_cart_id: string
          purchasable_id: string
          qty?: number
          updated_at?: string | null
        }
        Update: {
          created_at?: string
          deleted_at?: string | null
          id?: string
          product_feature_id?: string
          product_id?: string
          purchasable_cart_id?: string
          purchasable_id?: string
          qty?: number
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "purchasable_cart_items_product_feature_id_fkey"
            columns: ["product_feature_id"]
            referencedRelation: "product_features"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "purchasable_cart_items_product_id_fkey"
            columns: ["product_id"]
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "purchasable_cart_items_purchasable_cart_id_fkey"
            columns: ["purchasable_cart_id"]
            referencedRelation: "purchasable_carts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "purchasable_cart_items_purchasable_id_fkey"
            columns: ["purchasable_id"]
            referencedRelation: "purchasables"
            referencedColumns: ["id"]
          }
        ]
      }
      purchasable_carts: {
        Row: {
          created_at: string
          id: string
          purchasable_id: string
          purchased_at: string | null
          status: Database["public"]["Enums"]["purchasable_cart_status"]
        }
        Insert: {
          created_at?: string
          id?: string
          purchasable_id: string
          purchased_at?: string | null
          status?: Database["public"]["Enums"]["purchasable_cart_status"]
        }
        Update: {
          created_at?: string
          id?: string
          purchasable_id?: string
          purchased_at?: string | null
          status?: Database["public"]["Enums"]["purchasable_cart_status"]
        }
        Relationships: [
          {
            foreignKeyName: "purchasable_carts_purchasable_id_fkey"
            columns: ["purchasable_id"]
            referencedRelation: "purchasables"
            referencedColumns: ["id"]
          }
        ]
      }
      purchasable_coupons: {
        Row: {
          coupon_id: string
          created_at: string
          expired_at: string | null
          id: string
          purchasable_id: string
          status: Database["public"]["Enums"]["purchasable_coupon_status"]
        }
        Insert: {
          coupon_id: string
          created_at?: string
          expired_at?: string | null
          id?: string
          purchasable_id: string
          status?: Database["public"]["Enums"]["purchasable_coupon_status"]
        }
        Update: {
          coupon_id?: string
          created_at?: string
          expired_at?: string | null
          id?: string
          purchasable_id?: string
          status?: Database["public"]["Enums"]["purchasable_coupon_status"]
        }
        Relationships: [
          {
            foreignKeyName: "purchasable_coupons_coupon_id_fkey"
            columns: ["coupon_id"]
            referencedRelation: "coupons"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "purchasable_coupons_purchasable_id_fkey"
            columns: ["purchasable_id"]
            referencedRelation: "purchasables"
            referencedColumns: ["id"]
          }
        ]
      }
      purchasables: {
        Row: {
          authorized_at: string | null
          created_at: string
          id: string
          type: Database["public"]["Enums"]["purchasable_type"]
          user_id: string | null
        }
        Insert: {
          authorized_at?: string | null
          created_at?: string
          id?: string
          type?: Database["public"]["Enums"]["purchasable_type"]
          user_id?: string | null
        }
        Update: {
          authorized_at?: string | null
          created_at?: string
          id?: string
          type?: Database["public"]["Enums"]["purchasable_type"]
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "purchasables_user_id_fkey"
            columns: ["user_id"]
            referencedRelation: "users"
            referencedColumns: ["id"]
          }
        ]
      }
      receipts: {
        Row: {
          created_at: string
          failure_log: Json | null
          id: string
          invoice_id: string
          purchasable_cart_id: string
          purchasable_id: string
          status: Database["public"]["Enums"]["receipt_status"]
          success_log: Json | null
        }
        Insert: {
          created_at?: string
          failure_log?: Json | null
          id?: string
          invoice_id: string
          purchasable_cart_id: string
          purchasable_id: string
          status?: Database["public"]["Enums"]["receipt_status"]
          success_log?: Json | null
        }
        Update: {
          created_at?: string
          failure_log?: Json | null
          id?: string
          invoice_id?: string
          purchasable_cart_id?: string
          purchasable_id?: string
          status?: Database["public"]["Enums"]["receipt_status"]
          success_log?: Json | null
        }
        Relationships: [
          {
            foreignKeyName: "receipts_invoice_id_fkey"
            columns: ["invoice_id"]
            referencedRelation: "invoices"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "receipts_purchasable_cart_id_fkey"
            columns: ["purchasable_cart_id"]
            referencedRelation: "purchasable_carts"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "receipts_purchasable_id_fkey"
            columns: ["purchasable_id"]
            referencedRelation: "purchasables"
            referencedColumns: ["id"]
          }
        ]
      }
      shop_employees: {
        Row: {
          created_at: string
          id: string
          roles: Database["public"]["Enums"]["shop_employee_role"][]
          shop_id: string
          user_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          roles?: Database["public"]["Enums"]["shop_employee_role"][]
          shop_id: string
          user_id: string
        }
        Update: {
          created_at?: string
          id?: string
          roles?: Database["public"]["Enums"]["shop_employee_role"][]
          shop_id?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "shop_employees_shop_id_fkey"
            columns: ["shop_id"]
            referencedRelation: "shops"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "shop_employees_user_id_fkey"
            columns: ["user_id"]
            referencedRelation: "users"
            referencedColumns: ["id"]
          }
        ]
      }
      shops: {
        Row: {
          created_at: string
          deleted_at: string | null
          id: string
          name: string
        }
        Insert: {
          created_at?: string
          deleted_at?: string | null
          id?: string
          name: string
        }
        Update: {
          created_at?: string
          deleted_at?: string | null
          id?: string
          name?: string
        }
        Relationships: []
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      invoice_from_that_purchasable: {
        Args: {
          target_purchasable_id: string
          target_invoice_id: string
        }
        Returns: boolean
      }
      invoice_paid: {
        Args: {
          target_invoice_id: string
        }
        Returns: boolean
      }
      me_or_anonymous: {
        Args: {
          target_purchasable_id: string
        }
        Returns: boolean
      }
      product_description_from_that_shop: {
        Args: {
          target_shop_id: string
          target_product_description_id: string
        }
        Returns: boolean
      }
      product_entity_from_that_shop: {
        Args: {
          target_shop_id: string
          target_product_entity_id: string
        }
        Returns: boolean
      }
      product_feature_from_that_shop: {
        Args: {
          target_shop_id: string
          target_product_feature_id: string
        }
        Returns: boolean
      }
      product_from_that_shop: {
        Args: {
          target_shop_id: string
          target_product_id: string
        }
        Returns: boolean
      }
      product_price_from_that_shop: {
        Args: {
          target_shop_id: string
          target_product_price_id: string
        }
        Returns: boolean
      }
      purchasable_address_from_that_purchasable: {
        Args: {
          target_purchasable_id: string
          target_purchasable_address_id: string
        }
        Returns: boolean
      }
      purchasable_cart_from_that_purchasable: {
        Args: {
          target_purchasable_id: string
          target_purchasable_cart_id: string
        }
        Returns: boolean
      }
      purchasable_cart_item_from_that_purchasable: {
        Args: {
          target_purchasable_id: string
          target_purchasable_cart_item_id: string
        }
        Returns: boolean
      }
      purchasable_cart_no_invoice: {
        Args: {
          target_purchasable_cart_id: string
        }
        Returns: boolean
      }
      purchasable_coupon_from_that_purchasable: {
        Args: {
          target_purchasable_id: string
          target_purchasable_coupon_id: string
        }
        Returns: boolean
      }
      shop_admin: {
        Args: {
          target_shop_id: string
        }
        Returns: boolean
      }
      shop_employee: {
        Args: {
          target_shop_id: string
        }
        Returns: boolean
      }
      shop_owner: {
        Args: {
          target_shop_id: string
        }
        Returns: boolean
      }
    }
    Enums: {
      coupon_amount_unit: "PERCENT" | "CURRENCY"
      coupon_status: "ENABLED" | "DISABLED"
      currency: "KRW" | "USD"
      product_entity_delivery_status:
        | "IN_STOCK"
        | "PURCHASED"
        | "DELIVERED"
        | "RETURNED"
      product_feature_type: "BASE" | "PARTS"
      product_status: "PREPARING" | "SALE" | "SOLD_OUT"
      purchasable_cart_status: "PUTTING" | "PURCHASED"
      purchasable_coupon_status: "UNUSED" | "USED"
      purchasable_type: "ANONYMOUS" | "AUTHORIZED"
      receipt_status: "PAID" | "FAILED"
      shop_employee_role: "OWNER" | "ADMIN" | "EMPLOYEE"
    }
    CompositeTypes: {
      product_entities_with_price: {
        product_entity_id: string
        product_price_id: string
      }
      product_image: {
        product_feature_id: string
        storage_path: string
        alt: string
        representative: boolean
        display_order: number
      }
    }
  }
  storage: {
    Tables: {
      buckets: {
        Row: {
          allowed_mime_types: string[] | null
          avif_autodetection: boolean | null
          created_at: string | null
          file_size_limit: number | null
          id: string
          name: string
          owner: string | null
          owner_id: string | null
          public: boolean | null
          updated_at: string | null
        }
        Insert: {
          allowed_mime_types?: string[] | null
          avif_autodetection?: boolean | null
          created_at?: string | null
          file_size_limit?: number | null
          id: string
          name: string
          owner?: string | null
          owner_id?: string | null
          public?: boolean | null
          updated_at?: string | null
        }
        Update: {
          allowed_mime_types?: string[] | null
          avif_autodetection?: boolean | null
          created_at?: string | null
          file_size_limit?: number | null
          id?: string
          name?: string
          owner?: string | null
          owner_id?: string | null
          public?: boolean | null
          updated_at?: string | null
        }
        Relationships: []
      }
      migrations: {
        Row: {
          executed_at: string | null
          hash: string
          id: number
          name: string
        }
        Insert: {
          executed_at?: string | null
          hash: string
          id: number
          name: string
        }
        Update: {
          executed_at?: string | null
          hash?: string
          id?: number
          name?: string
        }
        Relationships: []
      }
      objects: {
        Row: {
          bucket_id: string | null
          created_at: string | null
          id: string
          last_accessed_at: string | null
          metadata: Json | null
          name: string | null
          owner: string | null
          owner_id: string | null
          path_tokens: string[] | null
          updated_at: string | null
          version: string | null
        }
        Insert: {
          bucket_id?: string | null
          created_at?: string | null
          id?: string
          last_accessed_at?: string | null
          metadata?: Json | null
          name?: string | null
          owner?: string | null
          owner_id?: string | null
          path_tokens?: string[] | null
          updated_at?: string | null
          version?: string | null
        }
        Update: {
          bucket_id?: string | null
          created_at?: string | null
          id?: string
          last_accessed_at?: string | null
          metadata?: Json | null
          name?: string | null
          owner?: string | null
          owner_id?: string | null
          path_tokens?: string[] | null
          updated_at?: string | null
          version?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "objects_bucketId_fkey"
            columns: ["bucket_id"]
            referencedRelation: "buckets"
            referencedColumns: ["id"]
          }
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      can_insert_object: {
        Args: {
          bucketid: string
          name: string
          owner: string
          metadata: Json
        }
        Returns: undefined
      }
      extension: {
        Args: {
          name: string
        }
        Returns: string
      }
      filename: {
        Args: {
          name: string
        }
        Returns: string
      }
      foldername: {
        Args: {
          name: string
        }
        Returns: unknown
      }
      get_size_by_bucket: {
        Args: Record<PropertyKey, never>
        Returns: {
          size: number
          bucket_id: string
        }[]
      }
      search: {
        Args: {
          prefix: string
          bucketname: string
          limits?: number
          levels?: number
          offsets?: number
          search?: string
          sortcolumn?: string
          sortorder?: string
        }
        Returns: {
          name: string
          id: string
          updated_at: string
          created_at: string
          last_accessed_at: string
          metadata: Json
        }[]
      }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

