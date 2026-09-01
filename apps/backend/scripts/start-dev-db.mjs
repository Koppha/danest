import EmbeddedPostgres from 'embedded-postgres';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';

const __dirname = dirname(fileURLToPath(import.meta.url));

const pg = new EmbeddedPostgres({
  databaseDir: join(__dirname, '..', '.pgdata'),
  user: 'de_nest',
  password: 'de_nest_dev_password',
  port: 5432,
  persistent: true,
});

const alreadyInitialised = await import('node:fs').then((fs) =>
  fs.existsSync(join(__dirname, '..', '.pgdata', 'PG_VERSION')),
);

if (!alreadyInitialised) {
  console.log('Initialising local Postgres cluster...');
  await pg.initialise();
}

console.log('Starting local Postgres...');
await pg.start();

try {
  await pg.createDatabase('de_nest');
  console.log('Created database "de_nest".');
} catch (err) {
  console.log('Database "de_nest" already exists, continuing.');
}

console.log('Local Postgres is up on port 5432 (user=de_nest, db=de_nest).');
console.log('Press Ctrl+C to stop.');

process.on('SIGINT', async () => {
  console.log('Stopping local Postgres...');
  await pg.stop();
  process.exit(0);
});
