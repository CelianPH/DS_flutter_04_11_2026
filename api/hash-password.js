const bcrypt = require('bcryptjs');

const password = process.argv[2];

if (!password) {
  console.error('Utilisation : npm run hash -- "monMotDePasse"');
  process.exit(1);
}

console.log(bcrypt.hashSync(password, 12));
