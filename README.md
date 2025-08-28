# BreadNotes 🍞

A bread journaling application where users can document their bread baking experiences, upload images, and share their creations with the community.

## Architecture

### Frontend
- **React** with TypeScript
- **Vite** for build tooling
- **TailwindCSS** for styling
- **React Router** for navigation
- **TanStack Query** for data fetching
- **Axios** for API calls

### Backend
- **FastAPI** with Python
- **SQLAlchemy** for ORM
- **Alembic** for database migrations
- **Google OAuth** for authentication
- **AWS Lambda** via Mangum for serverless deployment
- **PostgreSQL** on RDS for database
- **S3** for image storage
- **CloudFront** for CDN

### Infrastructure
- **Terraform** for Infrastructure as Code
- **AWS VPC** with public/private subnets
- **AWS Lambda** behind API Gateway
- **RDS PostgreSQL** in private subnets
- **S3** + CloudFront for static assets and images
- **GitHub Actions** for CI/CD

## Local Development

### Prerequisites
- Python 3.11+
- Node.js 20+
- uv (Python package manager)
- PostgreSQL (for local development)

### Backend Setup

1. Navigate to the API directory:
   ```bash
   cd api
   ```

2. Copy environment file:
   ```bash
   cp .env.example .env
   ```

3. Update `.env` with your configuration:
   - Database URL
   - Google OAuth credentials
   - AWS credentials (for S3)
   - Secret key

4. Install dependencies:
   ```bash
   uv sync
   ```

5. Run database migrations:
   ```bash
   uv run alembic upgrade head
   ```

6. Start the development server:
   ```bash
   uv run python main.py
   ```

The API will be available at `http://localhost:8000`

### Frontend Setup

1. Navigate to the web directory:
   ```bash
   cd web
   ```

2. Copy environment file:
   ```bash
   cp .env.example .env.local
   ```

3. Install dependencies:
   ```bash
   npm install
   ```

4. Start the development server:
   ```bash
   npm run dev
   ```

The frontend will be available at `http://localhost:3000`

## Local Development with Docker

The easiest way to run BreadNotes locally is using Docker:

```bash
# Start the development environment
make dev
```

This will start:
- PostgreSQL database
- FastAPI backend
- React frontend  

See [DOCKER_README.md](DOCKER_README.md) for detailed Docker setup instructions.

## Production Deployment

For production deployment, use the Terraform infrastructure and GitHub Actions workflow:

1. **Infrastructure**: Use Terraform to deploy AWS resources (see `terraform/` directory)
2. **Application**: Use GitHub Actions workflow for automated deployment
3. **Configuration**: Set up required secrets and environment variables

## Features

- **User Authentication**: Google OAuth integration
- **Bread Entries**: Create, view, edit, and delete bread baking entries
- **Image Upload**: Upload and display bread photos via S3
- **Community Feed**: View recent entries from all users
- **Personal Dashboard**: Manage your own bread entries
- **Responsive Design**: Works on desktop and mobile devices

## API Endpoints

### Authentication
- `GET /api/auth/login` - Initiate Google OAuth login
- `GET /api/auth/callback` - OAuth callback handler
- `GET /api/auth/logout` - Logout user
- `GET /api/auth/me` - Get current user info

### Bread Entries
- `GET /api/bread-entries/` - Get user's bread entries
- `POST /api/bread-entries/` - Create new bread entry
- `GET /api/bread-entries/recent` - Get recent entries from all users
- `GET /api/bread-entries/{id}` - Get specific bread entry
- `PUT /api/bread-entries/{id}` - Update bread entry
- `DELETE /api/bread-entries/{id}` - Delete bread entry

### Health Check
- `GET /api/health` - API health check

## Database Schema

### Users Table
- `id` (UUID, Primary Key)
- `email` (String, Unique)
- `name` (String)
- `google_id` (String, Unique)
- `profile_picture` (String, Optional)
- `created_at` (DateTime)
- `updated_at` (DateTime)

### Bread Entries Table
- `id` (UUID, Primary Key)
- `title` (String)
- `notes` (Text, Optional)
- `image_url` (String, Optional)
- `user_id` (UUID, Foreign Key)
- `created_at` (DateTime)
- `updated_at` (DateTime)

## Security

- All API endpoints require authentication (except public feed and health check)
- CORS configured for frontend domain
- CSRF protection enabled
- Session-based authentication
- Secure S3 bucket policies
- VPC isolation for database and Lambda functions
- Encrypted storage for RDS and S3

## License

MIT License - see LICENSE file for details