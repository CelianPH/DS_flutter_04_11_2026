const { test, before, after } = require('node:test');
const assert = require('node:assert/strict');
const app = require('../app');

const ERROR_BODY = { status: 400, message: 'Error' };

let server;
let baseUrl;

before(async () => {
  await new Promise((resolve) => {
    server = app.listen(0, '127.0.0.1', resolve); // port libre choisi par le système
  });
  baseUrl = `http://127.0.0.1:${server.address().port}`;
});

after(() => {
  server.close();
});

function postJson(body) {
  return fetch(`${baseUrl}/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: typeof body === 'string' ? body : JSON.stringify(body),
  });
}

test('identifiants corrects : renvoie le profil complet', async () => {
  const response = await postJson({ email: 'jean@example.com', password: 'userpass' });

  assert.equal(response.status, 200);
  assert.deepEqual(await response.json(), {
    status: 200,
    message: 'Success',
    id: 1,
    firstName: 'Jean',
    lastName: 'Dupont',
    email: 'jean@example.com',
    role: 2,
  });
});

test('accepte aussi un formulaire (format envoyé par le package http)', async () => {
  const response = await fetch(`${baseUrl}/login`, {
    method: 'POST',
    body: new URLSearchParams({ email: 'julie@example.com', password: 'adminpass' }),
  });

  assert.equal(response.status, 200);
  assert.equal((await response.json()).firstName, 'Julie');
});

test('ne renvoie jamais le hash du mot de passe', async () => {
  const response = await postJson({ email: 'jean@example.com', password: 'userpass' });

  assert.equal('passwordHash' in (await response.json()), false);
});

test('mauvais mot de passe : erreur 400', async () => {
  const response = await postJson({ email: 'jean@example.com', password: 'mauvais' });

  assert.equal(response.status, 400);
  assert.deepEqual(await response.json(), ERROR_BODY);
});

test('email inconnu : même erreur que pour un mauvais mot de passe', async () => {
  const response = await postJson({ email: 'inconnu@example.com', password: 'userpass' });

  assert.equal(response.status, 400);
  assert.deepEqual(await response.json(), ERROR_BODY);
});

test('entrées invalides : erreur 400', async () => {
  const invalidBodies = [
    {},
    { email: 'jean@example.com' },
    { password: 'userpass' },
    { email: 'pas-un-email', password: 'userpass' },
    { email: 'jean@example.com', password: '' },
    { email: 'jean@example.com', password: 'a'.repeat(73) },
    { email: ['jean@example.com'], password: 'userpass' },
    { email: 'jean@example.com', password: { $ne: null } },
  ];

  for (const body of invalidBodies) {
    const response = await postJson(body);
    assert.equal(response.status, 400, JSON.stringify(body));
    assert.deepEqual(await response.json(), ERROR_BODY);
  }
});

test('JSON mal formé : erreur 400 en JSON', async () => {
  const response = await postJson('{ pas du json');

  assert.equal(response.status, 400);
  assert.deepEqual(await response.json(), ERROR_BODY);
});

test('route inconnue : erreur 404 en JSON', async () => {
  const response = await fetch(`${baseUrl}/inconnue`);

  assert.equal(response.status, 404);
  assert.deepEqual(await response.json(), { status: 404, message: 'Not Found' });
});
