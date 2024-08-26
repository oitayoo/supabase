export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
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
      order_product_statuses: {
        Row: {
          comment: string | null
          created_at: string
          id: string
          order_id: string
          order_product_id: string
          product_id: string
          store_id: string
          type: Database["public"]["Enums"]["order_product_status_type"]
          user_id: string | null
        }
        Insert: {
          comment?: string | null
          created_at?: string
          id?: string
          order_id: string
          order_product_id: string
          product_id: string
          store_id: string
          type?: Database["public"]["Enums"]["order_product_status_type"]
          user_id?: string | null
        }
        Update: {
          comment?: string | null
          created_at?: string
          id?: string
          order_id?: string
          order_product_id?: string
          product_id?: string
          store_id?: string
          type?: Database["public"]["Enums"]["order_product_status_type"]
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "order_product_statuses_order_id_fkey"
            columns: ["order_id"]
            isOneToOne: false
            referencedRelation: "orders"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "order_product_statuses_order_product_id_fkey"
            columns: ["order_product_id"]
            isOneToOne: false
            referencedRelation: "order_products"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "order_product_statuses_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "order_product_statuses_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "order_product_statuses_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      order_products: {
        Row: {
          created_at: string
          current_order_product_status_id: string | null
          id: string
          order_id: string
          product_id: string
          store_id: string
          user_id: string
        }
        Insert: {
          created_at?: string
          current_order_product_status_id?: string | null
          id?: string
          order_id: string
          product_id: string
          store_id: string
          user_id: string
        }
        Update: {
          created_at?: string
          current_order_product_status_id?: string | null
          id?: string
          order_id?: string
          product_id?: string
          store_id?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "order_products_current_order_product_status_id_fkey"
            columns: ["current_order_product_status_id"]
            isOneToOne: false
            referencedRelation: "order_product_statuses"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "order_products_order_id_fkey"
            columns: ["order_id"]
            isOneToOne: false
            referencedRelation: "orders"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "order_products_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "order_products_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "order_products_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      orders: {
        Row: {
          code: string
          created_at: string
          id: string
          user_id: string
        }
        Insert: {
          code: string
          created_at?: string
          id?: string
          user_id: string
        }
        Update: {
          code?: string
          created_at?: string
          id?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "orders_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      product_details: {
        Row: {
          created_at: string
          description: string
          explorable: boolean
          id: string
          images: Database["public"]["CompositeTypes"]["product_image"][]
          name: string
          product_id: string
          product_revision_id: string
          store_id: string
        }
        Insert: {
          created_at?: string
          description: string
          explorable?: boolean
          id?: string
          images?: Database["public"]["CompositeTypes"]["product_image"][]
          name: string
          product_id: string
          product_revision_id: string
          store_id: string
        }
        Update: {
          created_at?: string
          description?: string
          explorable?: boolean
          id?: string
          images?: Database["public"]["CompositeTypes"]["product_image"][]
          name?: string
          product_id?: string
          product_revision_id?: string
          store_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "product_details_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "product_details_product_revision_id_fkey"
            columns: ["product_revision_id"]
            isOneToOne: false
            referencedRelation: "product_revisions"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "product_details_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["id"]
          },
        ]
      }
      product_entities: {
        Row: {
          created_at: string
          current_product_entity_status_id: string | null
          deleted_at: string | null
          id: string
          name: string | null
          order_product_id: string | null
          product_id: string
          store_id: string
          user_id: string
        }
        Insert: {
          created_at?: string
          current_product_entity_status_id?: string | null
          deleted_at?: string | null
          id?: string
          name?: string | null
          order_product_id?: string | null
          product_id: string
          store_id: string
          user_id: string
        }
        Update: {
          created_at?: string
          current_product_entity_status_id?: string | null
          deleted_at?: string | null
          id?: string
          name?: string | null
          order_product_id?: string | null
          product_id?: string
          store_id?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "product_entities_current_product_entity_status_id_fkey"
            columns: ["current_product_entity_status_id"]
            isOneToOne: false
            referencedRelation: "product_entity_statuses"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "product_entities_order_product_id_fkey"
            columns: ["order_product_id"]
            isOneToOne: false
            referencedRelation: "order_products"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "product_entities_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "product_entities_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "product_entities_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      product_entity_statuses: {
        Row: {
          comment: string | null
          created_at: string
          deleted_at: string | null
          id: string
          images: Database["public"]["CompositeTypes"]["product_entity_status_image"][]
          product_entity_id: string
          product_id: string
          store_id: string
          type: Database["public"]["Enums"]["product_entity_status_type"]
          updated_at: string | null
          user_id: string | null
        }
        Insert: {
          comment?: string | null
          created_at?: string
          deleted_at?: string | null
          id?: string
          images?: Database["public"]["CompositeTypes"]["product_entity_status_image"][]
          product_entity_id: string
          product_id: string
          store_id: string
          type?: Database["public"]["Enums"]["product_entity_status_type"]
          updated_at?: string | null
          user_id?: string | null
        }
        Update: {
          comment?: string | null
          created_at?: string
          deleted_at?: string | null
          id?: string
          images?: Database["public"]["CompositeTypes"]["product_entity_status_image"][]
          product_entity_id?: string
          product_id?: string
          store_id?: string
          type?: Database["public"]["Enums"]["product_entity_status_type"]
          updated_at?: string | null
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "product_entity_statuses_product_entity_id_fkey"
            columns: ["product_entity_id"]
            isOneToOne: false
            referencedRelation: "product_entities"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "product_entity_statuses_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "product_entity_statuses_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "product_entity_statuses_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      product_prices: {
        Row: {
          amount: number
          created_at: string
          currency: Database["public"]["Enums"]["currency"]
          id: string
          product_id: string
          product_revision_id: string
          store_id: string
        }
        Insert: {
          amount: number
          created_at?: string
          currency?: Database["public"]["Enums"]["currency"]
          id?: string
          product_id: string
          product_revision_id: string
          store_id: string
        }
        Update: {
          amount?: number
          created_at?: string
          currency?: Database["public"]["Enums"]["currency"]
          id?: string
          product_id?: string
          product_revision_id?: string
          store_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "product_prices_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "product_prices_product_revision_id_fkey"
            columns: ["product_revision_id"]
            isOneToOne: false
            referencedRelation: "product_revisions"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "product_prices_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["id"]
          },
        ]
      }
      product_revisions: {
        Row: {
          created_at: string
          id: string
          number: number
          product_id: string
          store_id: string
          user_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          number?: number
          product_id: string
          store_id: string
          user_id: string
        }
        Update: {
          created_at?: string
          id?: string
          number?: number
          product_id?: string
          store_id?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "product_revisions_product_id_fkey"
            columns: ["product_id"]
            isOneToOne: false
            referencedRelation: "products"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "product_revisions_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "product_revisions_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      products: {
        Row: {
          code: string
          created_at: string
          current_product_revision_id: string | null
          deleted_at: string | null
          id: string
          status: Database["public"]["Enums"]["product_status"]
          store_id: string
        }
        Insert: {
          code: string
          created_at?: string
          current_product_revision_id?: string | null
          deleted_at?: string | null
          id?: string
          status?: Database["public"]["Enums"]["product_status"]
          store_id: string
        }
        Update: {
          code?: string
          created_at?: string
          current_product_revision_id?: string | null
          deleted_at?: string | null
          id?: string
          status?: Database["public"]["Enums"]["product_status"]
          store_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "products_current_product_revision_id_fkey"
            columns: ["current_product_revision_id"]
            isOneToOne: false
            referencedRelation: "product_revisions"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "products_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["id"]
          },
        ]
      }
      profiles: {
        Row: {
          created_at: string
          id: string
          image: Database["public"]["CompositeTypes"]["profile_image"] | null
          name: string
          updated_at: string | null
          user_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          image?: Database["public"]["CompositeTypes"]["profile_image"] | null
          name: string
          updated_at?: string | null
          user_id: string
        }
        Update: {
          created_at?: string
          id?: string
          image?: Database["public"]["CompositeTypes"]["profile_image"] | null
          name?: string
          updated_at?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "profiles_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      store_staffs: {
        Row: {
          created_at: string
          deleted_at: string | null
          id: string
          store_id: string
          user_id: string
        }
        Insert: {
          created_at?: string
          deleted_at?: string | null
          id?: string
          store_id: string
          user_id: string
        }
        Update: {
          created_at?: string
          deleted_at?: string | null
          id?: string
          store_id?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "store_staffs_store_id_fkey"
            columns: ["store_id"]
            isOneToOne: false
            referencedRelation: "stores"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "store_staffs_user_id_fkey"
            columns: ["user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
      stores: {
        Row: {
          created_at: string
          deleted_at: string | null
          id: string
          name: string
          provisionable_user_id: string
          provisioned_at: string | null
          updated_at: string
        }
        Insert: {
          created_at?: string
          deleted_at?: string | null
          id?: string
          name: string
          provisionable_user_id: string
          provisioned_at?: string | null
          updated_at?: string
        }
        Update: {
          created_at?: string
          deleted_at?: string | null
          id?: string
          name?: string
          provisionable_user_id?: string
          provisioned_at?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "stores_provisionable_user_id_fkey"
            columns: ["provisionable_user_id"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      create_product_revision: {
        Args: {
          target_store_id: string
          target_product_id: string
          new_name: string
          new_description: string
          new_product_prices: Database["public"]["CompositeTypes"]["product_price_creatable"][]
          new_product_images: Database["public"]["CompositeTypes"]["product_image"][]
        }
        Returns: {
          created_at: string
          id: string
          number: number
          product_id: string
          store_id: string
          user_id: string
        }
      }
      get_stores: {
        Args: Record<PropertyKey, never>
        Returns: {
          created_at: string
          deleted_at: string | null
          id: string
          name: string
          provisionable_user_id: string
          provisioned_at: string | null
          updated_at: string
        }[]
      }
      is_any_store_staff: {
        Args: Record<PropertyKey, never>
        Returns: boolean
      }
      is_me: {
        Args: {
          user_id: string
        }
        Returns: boolean
      }
      is_store_staff: {
        Args: {
          target_store_id: string
        }
        Returns: boolean
      }
      is_store_staff_for_one_of_order_products: {
        Args: {
          order_id: string
        }
        Returns: boolean
      }
      store_provisioning: {
        Args: {
          target_store_id: string
        }
        Returns: {
          created_at: string
          deleted_at: string | null
          id: string
          name: string
          provisionable_user_id: string
          provisioned_at: string | null
          updated_at: string
        }
      }
    }
    Enums: {
      currency: "USD" | "EUR" | "JPY" | "GBP" | "KRW"
      order_product_status_type:
        | "PAID"
        | "PREPARING PRODUCT"
        | "PREPARING FOR DELIVERY"
        | "DELIVERED"
        | "CANCELED"
      product_entity_status_type:
        | "REQUEST"
        | "IN PRODUCTION"
        | "COMPLETE PRODUCTION"
        | "COMMENT"
      product_status: "UNDER REVIEW" | "SALE" | "SOLD OUT"
    }
    CompositeTypes: {
      product_entity_status_image: {
        path: string | null
        alt: string | null
        index: number | null
      }
      product_image: {
        path: string | null
        main: boolean | null
        alt: string | null
        index: number | null
      }
      product_price_creatable: {
        currency: Database["public"]["Enums"]["currency"] | null
        amount: number | null
      }
      profile_image: {
        path: string | null
        alt: string | null
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
            isOneToOne: false
            referencedRelation: "buckets"
            referencedColumns: ["id"]
          },
        ]
      }
      s3_multipart_uploads: {
        Row: {
          bucket_id: string
          created_at: string
          id: string
          in_progress_size: number
          key: string
          owner_id: string | null
          upload_signature: string
          version: string
        }
        Insert: {
          bucket_id: string
          created_at?: string
          id: string
          in_progress_size?: number
          key: string
          owner_id?: string | null
          upload_signature: string
          version: string
        }
        Update: {
          bucket_id?: string
          created_at?: string
          id?: string
          in_progress_size?: number
          key?: string
          owner_id?: string | null
          upload_signature?: string
          version?: string
        }
        Relationships: [
          {
            foreignKeyName: "s3_multipart_uploads_bucket_id_fkey"
            columns: ["bucket_id"]
            isOneToOne: false
            referencedRelation: "buckets"
            referencedColumns: ["id"]
          },
        ]
      }
      s3_multipart_uploads_parts: {
        Row: {
          bucket_id: string
          created_at: string
          etag: string
          id: string
          key: string
          owner_id: string | null
          part_number: number
          size: number
          upload_id: string
          version: string
        }
        Insert: {
          bucket_id: string
          created_at?: string
          etag: string
          id?: string
          key: string
          owner_id?: string | null
          part_number: number
          size?: number
          upload_id: string
          version: string
        }
        Update: {
          bucket_id?: string
          created_at?: string
          etag?: string
          id?: string
          key?: string
          owner_id?: string | null
          part_number?: number
          size?: number
          upload_id?: string
          version?: string
        }
        Relationships: [
          {
            foreignKeyName: "s3_multipart_uploads_parts_bucket_id_fkey"
            columns: ["bucket_id"]
            isOneToOne: false
            referencedRelation: "buckets"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "s3_multipart_uploads_parts_upload_id_fkey"
            columns: ["upload_id"]
            isOneToOne: false
            referencedRelation: "s3_multipart_uploads"
            referencedColumns: ["id"]
          },
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
        Returns: string[]
      }
      get_size_by_bucket: {
        Args: Record<PropertyKey, never>
        Returns: {
          size: number
          bucket_id: string
        }[]
      }
      list_multipart_uploads_with_delimiter: {
        Args: {
          bucket_id: string
          prefix_param: string
          delimiter_param: string
          max_keys?: number
          next_key_token?: string
          next_upload_token?: string
        }
        Returns: {
          key: string
          id: string
          created_at: string
        }[]
      }
      list_objects_with_delimiter: {
        Args: {
          bucket_id: string
          prefix_param: string
          delimiter_param: string
          max_keys?: number
          start_after?: string
          next_token?: string
        }
        Returns: {
          name: string
          id: string
          metadata: Json
          updated_at: string
        }[]
      }
      operation: {
        Args: Record<PropertyKey, never>
        Returns: string
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

type PublicSchema = Database[Extract<keyof Database, "public">]

export type Tables<
  PublicTableNameOrOptions extends
    | keyof (PublicSchema["Tables"] & PublicSchema["Views"])
    | { schema: keyof Database },
  TableName extends PublicTableNameOrOptions extends { schema: keyof Database }
    ? keyof (Database[PublicTableNameOrOptions["schema"]]["Tables"] &
        Database[PublicTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = PublicTableNameOrOptions extends { schema: keyof Database }
  ? (Database[PublicTableNameOrOptions["schema"]]["Tables"] &
      Database[PublicTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : PublicTableNameOrOptions extends keyof (PublicSchema["Tables"] &
        PublicSchema["Views"])
    ? (PublicSchema["Tables"] &
        PublicSchema["Views"])[PublicTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  PublicTableNameOrOptions extends
    | keyof PublicSchema["Tables"]
    | { schema: keyof Database },
  TableName extends PublicTableNameOrOptions extends { schema: keyof Database }
    ? keyof Database[PublicTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = PublicTableNameOrOptions extends { schema: keyof Database }
  ? Database[PublicTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : PublicTableNameOrOptions extends keyof PublicSchema["Tables"]
    ? PublicSchema["Tables"][PublicTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  PublicTableNameOrOptions extends
    | keyof PublicSchema["Tables"]
    | { schema: keyof Database },
  TableName extends PublicTableNameOrOptions extends { schema: keyof Database }
    ? keyof Database[PublicTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = PublicTableNameOrOptions extends { schema: keyof Database }
  ? Database[PublicTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : PublicTableNameOrOptions extends keyof PublicSchema["Tables"]
    ? PublicSchema["Tables"][PublicTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  PublicEnumNameOrOptions extends
    | keyof PublicSchema["Enums"]
    | { schema: keyof Database },
  EnumName extends PublicEnumNameOrOptions extends { schema: keyof Database }
    ? keyof Database[PublicEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = PublicEnumNameOrOptions extends { schema: keyof Database }
  ? Database[PublicEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : PublicEnumNameOrOptions extends keyof PublicSchema["Enums"]
    ? PublicSchema["Enums"][PublicEnumNameOrOptions]
    : never

