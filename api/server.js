const app = require('./app');

const HOST = process.env.HOST || '127.0.0.1';
const PORT = Number(process.env.PORT) || 3000;

app.listen(PORT, HOST, () => {
  console.log(`API démarrée sur http://${HOST}:${PORT}`);
});
