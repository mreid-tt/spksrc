#!/usr/bin/env node

const http = require('http');
const httpProxy = require('http-proxy');

const PROXY_PORT = parseInt(process.env.PROXY_PORT || '5055', 10);
const SEERR_PORT = parseInt(process.env.SEERR_PORT || '5056', 10);
const SEERR_HOST = '127.0.0.1';
const PROXY_HOST = '0.0.0.0';

const proxy = httpProxy.createProxyServer({
  target: `http://${SEERR_HOST}:${SEERR_PORT}`,
  ws: true
});

proxy.on('error', (err, req, res) => {
  console.error('Proxy error:', err.message);
  if (res && !res.headersSent) {
    res.writeHead(502);
    res.end('Bad Gateway');
  }
});

const server = http.createServer((req, res) => {
  proxy.web(req, res);
});

server.on('upgrade', (req, socket, head) => {
  proxy.ws(req, socket, head);
});

server.listen(PROXY_PORT, PROXY_HOST, () => {
  console.log(`Proxy on ${PROXY_HOST}:${PROXY_PORT} -> ${SEERR_HOST}:${SEERR_PORT}`);
});
