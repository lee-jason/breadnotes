# Docker Development Setup

This guide explains how to set up and run BreadNotes using Docker for local development.

## Quick Start

**Start the entire development environment with one command:**

```bash
make dev
```

That's it! This will:
- Build all Docker images
- Start PostgreSQL, API, Web, and MinIO services
- Run database migrations
- Display access URLs

## Services

The development environment includes:

- **PostgreSQL** (port 5432): Database
- **FastAPI** (port 8000): Backend API
- **React** (port 3000): Frontend application  
- **MinIO** (ports 9000/9001): Local S3-compatible storage

## Access Points

After running `make dev`:

- **Frontend**: http://localhost:3000
- **API**: http://localhost:8000
- **API Docs**: http://localhost:8000/docs
- **MinIO Console**: http://localhost:9001 (minioadmin/minioadmin123)

## Available Commands

Run `make help` to see all available commands:

### Development
- `make dev` - Start complete development environment
- `make up` - Start services without building
- `make down` - Stop all services
- `make restart` - Restart all services
- `make build` - Build all Docker images
- `make rebuild` - Rebuild and restart services

### Logs & Debugging
- `make logs` - Show logs for all services
- `make logs-api` - Show API logs only
- `make logs-web` - Show web logs only
- `make logs-db` - Show database logs only

### Shell Access
- `make shell-api` - Access API container shell
- `make shell-web` - Access web container shell
- `make shell-db` - Access database shell

### Database Operations
- `make migrate` - Run database migrations
- `make migrate-create MSG="description"` - Create new migration
- `make migrate-down` - Downgrade by one migration
- `make migrate-reset` - Reset database (WARNING: deletes all data)

### Health & Status
- `make health` - Check service health
- `make status` - Show service status

### Cleanup
- `make clean` - Clean up Docker resources
- `make clean-all` - Clean up everything (images, containers, volumes)

## Environment Configuration

### Automatic Setup
Run `make env-setup` to create environment files from examples.

### Manual Setup
1. Copy environment files:
   ```bash
   cp .env.example .env
   cp api/.env.example api/.env
   cp web/.env.example web/.env.local
   ```

2. Update the files with your configuration (Google OAuth, AWS credentials, etc.)

### Google OAuth Setup (Optional for Development)

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable Google+ API
4. Create OAuth 2.0 credentials
5. Add authorized redirect URIs:
   - `http://localhost:8000/api/auth/callback`
6. Update `.env` with your `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET`

### AWS S3 Setup (Optional for Development)

For local development, you can use the included MinIO service instead of AWS S3.

To use AWS S3:
1. Update `.env` with your AWS credentials
2. Create an S3 bucket
3. Update `S3_BUCKET_NAME` in your environment

## Development Workflow

### Making Code Changes

The development setup includes hot reloading:

- **API changes**: Automatically reloaded via uvicorn `--reload`
- **Frontend changes**: Automatically reloaded via Vite HMR
- **Database changes**: Create migrations with `make migrate-create MSG="description"`

### Adding Dependencies

**For API (Python):**
```bash
# Access API container
make shell-api

# Add dependency
uv add package-name

# Or for dev dependencies
uv add --dev package-name
```

**For Web (Node.js):**
```bash
# Access web container
make shell-web

# Add dependency
npm install package-name

# Or for dev dependencies  
npm install --save-dev package-name
```

### Database Operations

**View database:**
```bash
make shell-db
# Now you're in psql
\dt  # List tables
\d users  # Describe users table
SELECT * FROM users;  # Query users
```

**Create migration:**
```bash
make migrate-create MSG="add new field to users"
```

**Apply migrations:**
```bash
make migrate
```

## Troubleshooting

### Services won't start
```bash
# Check service status
make status

# View logs
make logs

# Rebuild everything
make rebuild
```

### Database connection issues
```bash
# Check database health
make health

# Reset database
make migrate-reset
```

### Port conflicts
If ports 3000, 8000, 5432, or 9000/9001 are in use:

1. Stop conflicting services
2. Or modify ports in `docker-compose.yml`

### Permission issues
```bash
# Clean everything and start fresh
make clean-all
make dev
```

### Container rebuild needed
```bash
# After changing Dockerfile or dependencies
make rebuild
```


## File Structure

```
├── api/
│   ├── Dockerfile             # API development image
│   ├── .dockerignore          # API Docker ignore
│   └── ...
├── web/
│   ├── Dockerfile             # Web development image
│   ├── .dockerignore          # Web Docker ignore
│   └── ...
├── scripts/
│   └── init-db.sql            # Database initialization
├── docker-compose.yml         # Development compose file
├── Makefile                   # Development commands
└── .env.example               # Environment template
```