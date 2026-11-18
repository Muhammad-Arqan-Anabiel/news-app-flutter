const ALLOWED_ENDPOINTS = new Set(['top-headlines', 'everything']);
const ALLOWED_PARAMS = new Set([
  'country',
  'category',
  'q',
  'pageSize',
  'sortBy',
]);

const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
};

export default {
  async fetch(request, env) {
    if (request.method === 'OPTIONS') {
      return new Response(null, { status: 204, headers: CORS_HEADERS });
    }

    if (request.method !== 'GET') {
      return Response.json(
        { status: 'error', message: 'Method not allowed' },
        { status: 405, headers: CORS_HEADERS },
      );
    }

    if (!env.NEWS_API_KEY) {
      return Response.json(
        {
          status: 'error',
          message: 'NEWS_API_KEY belum diatur di Cloudflare Worker Secret.',
        },
        { status: 500, headers: CORS_HEADERS },
      );
    }

    const reqUrl = new URL(request.url);
    const endpoint = reqUrl.searchParams.get('endpoint') || 'top-headlines';

    if (!ALLOWED_ENDPOINTS.has(endpoint)) {
      return Response.json(
        { status: 'error', message: 'Endpoint tidak valid.' },
        { status: 400, headers: CORS_HEADERS },
      );
    }

    const targetUrl = new URL(`https://newsapi.org/v2/${endpoint}`);
    for (const [key, value] of reqUrl.searchParams.entries()) {
      if (ALLOWED_PARAMS.has(key) && value.trim()) {
        targetUrl.searchParams.set(key, value.trim());
      }
    }

    const upstream = await fetch(targetUrl.toString(), {
      headers: {
        'X-Api-Key': env.NEWS_API_KEY,
        'User-Agent': 'NewsAppFlutterProxy/1.0',
      },
    });

    const body = await upstream.text();
    return new Response(body, {
      status: upstream.status,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        ...CORS_HEADERS,
      },
    });
  },
};
