const ALLOWED_ENDPOINTS = new Set(['top-headlines', 'everything']);
const ALLOWED_PARAMS = new Set([
  'country',
  'category',
  'q',
  'pageSize',
  'sortBy',
]);

module.exports = async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method !== 'GET') {
    return res.status(405).json({ status: 'error', message: 'Method not allowed' });
  }

  const apiKey = (process.env.NEWS_API_KEY || '').trim();
  if (!apiKey) {
    return res.status(500).json({
      status: 'error',
      message: 'NEWS_API_KEY belum diatur di environment variable server.',
    });
  }

  const endpoint = String(req.query.endpoint || 'top-headlines');
  if (!ALLOWED_ENDPOINTS.has(endpoint)) {
    return res.status(400).json({
      status: 'error',
      message: 'Endpoint tidak valid.',
    });
  }

  const targetUrl = new URL(`https://newsapi.org/v2/${endpoint}`);
  for (const [key, value] of Object.entries(req.query)) {
    if (ALLOWED_PARAMS.has(key) && typeof value === 'string' && value.trim()) {
      targetUrl.searchParams.set(key, value.trim());
    }
  }

  try {
    const upstream = await fetch(targetUrl.toString(), {
      headers: {
        'X-Api-Key': apiKey,
        'User-Agent': 'NewsAppFlutterProxy/1.0',
      },
    });

    const data = await upstream.json();
    return res.status(upstream.status).json(data);
  } catch (err) {
    return res.status(502).json({
      status: 'error',
      message: 'Gagal menghubungi NewsAPI dari server proxy.',
    });
  }
}
