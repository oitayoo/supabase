import cors from '../_shared/cors.ts'

interface ResponseOptions {
	status?: number
	headers?: { [key: string]: string }
}

// deno-lint-ignore no-explicit-any
export const create = (body: any, options?: ResponseOptions) => {
	const { status = 200, headers = {} } = options || {}

	return new Response(JSON.stringify(body), {
		status,
		headers: { 'Content-Type': 'application/json', ...cors.headers, ...headers },
	})
}

export const ok = () => create('ok')

export const methodNotAllowed = () => create('method not allowed', { status: 405 })

export const badRequest = (error: string | undefined = 'bad request') =>
	create({ error, data: null }, { status: 400 })

export const notFound = (error: string | undefined = 'not found') =>
	create({ error, data: null }, { status: 404 })

export const unauthorized = (error: string | undefined = 'unauthorized') =>
	create({ error, data: null }, { status: 401 })

export default { create, ok, methodNotAllowed }
