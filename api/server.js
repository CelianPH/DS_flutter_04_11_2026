// api/server.js
// Point d'entrée : démarre l'API en HTTPS sur la machine locale.

const fs = require('fs');
const https = require('https');
const path = require('path');
const app = require('./app');

const HOST = process.env.HOST || '127.0.0.1';
const PORT = Number(process.env.PORT) || 3000;
const CERT_DIR = path.join(__dirname, 'certs');

let tlsOptions;
try {
  tlsOptions = {
    key: fs.readFileSync(path.join(CERT_DIR, 'localhost-key.pem')),
    cert: fs.readFileSync(path.join(CERT_DIR, 'localhost.pem')),
  };
} catch {
  console.error('Certificat introuvable : lancez "npm run cert" (voir le README).');
  process.exit(1);
}

https.createServer(tlsOptions, app).listen(PORT, HOST, () => {
  console.log(`API démarrée sur https://${HOST}:${PORT}`);
});
