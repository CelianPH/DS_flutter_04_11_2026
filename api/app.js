const express = require('express');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const users = require('./data/users.json');

const LOCAL_ORIGIN_REGEX = /^https?:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/;
const EMAIL_REGEX = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;
const MAX_EMAIL_LENGTH = 254;
const MAX_PASSWORD_BYTES = 72; // bcrypt ignore tout ce qui dépasse 72 octets

// Réponse d'erreur imposée par le contrat de l'API.
const ERROR_RESPONSE = { status: 400, message: 'Error' };

// Hash comparé quand l'email est inconnu : le temps de réponse reste le même
// que pour un email existant, ce qui évite de révéler quels comptes existent.
const DUMMY_HASH = bcrypt.hashSync('mot-de-passe-factice', 12);

function isValidInput(email, password) {
  return (
    typeof email === 'string' &&
    typeof password === 'string' &&
    email.length <= MAX_EMAIL_LENGTH &&
    EMAIL_REGEX.test(email) &&
    password.length > 0 &&
    Buffer.byteLength(password, 'utf8') <= MAX_PASSWORD_BYTES
  );
}

const app = express();

app.use(cors({ origin: LOCAL_ORIGIN_REGEX }));
// Accepte les deux formats courants : JSON et formulaire (celui du package http).
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.post('/login', async (req, res) => {
  const { email, password } = req.body ?? {};

  if (!isValidInput(email, password)) {
    return res.status(400).json(ERROR_RESPONSE);
  }

  const normalizedEmail = email.trim().toLowerCase();
  const user = users.find((candidate) => candidate.email === normalizedEmail);
  const passwordMatches = await bcrypt.compare(
    password,
    user ? user.passwordHash : DUMMY_HASH,
  );

  if (!user || !passwordMatches) {
    return res.status(400).json(ERROR_RESPONSE);
  }

  return res.status(200).json({
    status: 200,
    message: 'Success',
    id: user.id,
    firstName: user.firstName,
    lastName: user.lastName,
    email: user.email,
    role: user.role,
  });
});

// Route inconnue : on reste en JSON plutôt que de renvoyer une page HTML.
app.use((req, res) => {
  res.status(404).json({ status: 404, message: 'Not Found' });
});

// Corps de requête illisible (JSON mal formé, par exemple) ou erreur serveur.
app.use((err, req, res, next) => {
  if (err.status >= 400 && err.status < 500) {
    return res.status(400).json(ERROR_RESPONSE);
  }
  console.error(err);
  return res.status(500).json({ status: 500, message: 'Error' });
});

module.exports = app;
