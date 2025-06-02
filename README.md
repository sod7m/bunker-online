# Bunker Online

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]
[![Powered by Dart Frog](https://img.shields.io/endpoint?url=https://tinyurl.com/dartfrog-badge)](https://dartfrog.vgv.dev)

Full-stack authentication system built with Dart Frog backend and PostgreSQL database.

## Features

- ✅ User registration and login
- ✅ JWT token authentication
- ✅ bcrypt password hashing
- ✅ PostgreSQL database integration
- ✅ DigitalOcean hosting ready
- ✅ Protected routes middleware

## API Endpoints

### Authentication
- `POST /auth/register` - Register new user
- `POST /auth/login` - Login user

### Example Usage

```bash
# Register
curl -X POST http://localhost:8080/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password123"}'

# Login  
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password123"}'
```

## Setup

1. Clone the repository
```bash
git clone https://github.com/YOUR_USERNAME/bunker-online.git
cd bunker-online
```

2. Install dependencies
```bash
dart pub get
```

3. Create `.env` file with your database credentials
```env
DATABASE_HOST=your_database_host
DATABASE_PORT=5432
DATABASE_NAME=your_database_name
DATABASE_USER=your_username
DATABASE_PASSWORD=your_password
JWT_SECRET=your_jwt_secret
```

4. Run the server
```bash
dart_frog dev
```

## Tech Stack

- **Backend**: Dart Frog
- **Database**: PostgreSQL (DigitalOcean)
- **Authentication**: JWT + bcrypt
- **Hosting**: Ready for deployment

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis