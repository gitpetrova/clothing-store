# Rails + Vue starter

A split-stack starter kit:

- `api/` — Rails 8 API-only app (SQLite)
- `web/` — Vue 3 + Vite frontend

The Vue app proxies `/api` to Rails on port 3000. There is no auth yet.

## First-time setup

```bash
cd api
bundle install
bin/rails db:prepare db:seed

cd ../web
npm install
```

`db:setup` creates the database, runs migrations, and loads seed items.

## Run both apps

From the project root:

```bash
chmod +x bin/dev
./bin/dev
```

Or in two terminals:

```bash
cd api && bin/rails server -p 3000
cd web && npm run dev
```

Open [http://localhost:5173](http://localhost:5173). The UI lists, creates, edits, completes, and deletes items stored by the API.

## API

| Method | Path | Purpose |
| --- | --- | --- |
| GET | `/api/v1/items` | List items |
| POST | `/api/v1/items` | Create (`{ "item": { "title": "...", "description": "..." } }`) |
| GET | `/api/v1/items/:id` | Show one |
| PATCH | `/api/v1/items/:id` | Update |
| DELETE | `/api/v1/items/:id` | Delete |

Health check: `GET /up`

CORS allows `http://localhost:5173` so the frontend can also call Rails directly.

## Add another resource

1. Model + migration in `api/`
2. Controller under `app/controllers/api/v1/`
3. Route in the `api/v1` namespace
4. A fetch helper in `web/src/api/`
5. A Vue view that uses it
