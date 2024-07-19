import { createClient, SupabaseClient } from '@supabase/supabase-js'
import { Database } from '../../../types/supabase.ts'

export let supabase: SupabaseClient<Database> | undefined

export const get = (req: Request) => {
	const supabaseUrl = Deno.env.get('SUPABASE_URL')!
	const supabaseKey = Deno.env.get('SUPABASE_ANON_KEY')!

	if (supabase === undefined)
		supabase = createClient<Database>(supabaseUrl, supabaseKey, {
			global: { headers: { Authorization: req.headers.get('Authorization')! } },
		})

	return supabase
}
