# Full-Stack Assessment — Flask + MySQL

A complete sign-up/login/dashboard app with file upload & download, built with
Flask (backend), MySQL (database), and HTML/CSS/JS (frontend).

## Features
- Sign-up page (Name, Age, Address, Email, Mobile, Password) → stored in MySQL
- Login page → validated against MySQL, redirects to dashboard
- Dashboard with:
  - Test file download
  - File upload (2 fields, restricted to PDF/PNG/JPEG)
  - List of previously uploaded files (with metadata)
- Uploaded files saved to disk with the user's name in the filename
- File metadata (filename, type, timestamp, user) stored in MySQL
- Passwords hashed with Werkzeug (never stored in plain text)

## Project Structure
```
fullstack_app/
├── app.py                 # Flask backend (all routes)
├── schema.sql              # MySQL database + table creation script
├── requirements.txt        # Python dependencies
├── .env                     # DB credentials (already filled with your password)
├── templates/
│   ├── signup.html
│   ├── login.html
│   ├── dashboard.html
│   └── 404.html
├── static/
│   ├── css/style.css       # Dark theme styling
│   └── downloads/          # Sample file generated here automatically
└── uploads/                 # Uploaded user files stored here
```

## Setup Steps

### 1. Install MySQL Server (if not already installed)
Make sure MySQL is running locally and you know the root password.
Your `.env` file is already set up with:
```
MYSQL_PASSWORD=vengat@123
```
If your actual root password is different, edit `.env` before running.

### 2. Create the database
```bash
mysql -u root -p < schema.sql
```
Enter your MySQL password (`vengat@123`) when prompted. This creates the
`fullstack_app` database with `users` and `uploaded_files` tables.

### 3. Create a virtual environment & install dependencies
```bash
cd fullstack_app
python -m venv venv
source venv/bin/activate        # On Windows: venv\Scripts\activate
pip install -r requirements.txt
```

> Note: `mysqlclient` requires MySQL development headers.
> - On Windows: usually installs fine via pip with a prebuilt wheel.
> - On Ubuntu/Debian: `sudo apt install python3-dev default-libmysqlclient-dev build-essential` before `pip install`.
> - On Mac: `brew install mysql-client` then set `PATH`/`LDFLAGS` as instructed by brew.

### 4. Run the app
```bash
python app.py
```
Visit: **http://localhost:5000**

### 5. Test the flow
1. Go to `/signup`, create an account.
2. You'll be redirected to `/login`.
3. Log in with your email/password → redirected to `/dashboard`.
4. Download the sample test file.
5. Upload 1–2 files (PDF/PNG/JPEG only) and see them listed below.

## Database Schema

**users**
| Column | Type | Notes |
|---|---|---|
| id | INT, PK, AUTO_INCREMENT | |
| name | VARCHAR(100) | |
| age | INT | |
| address | VARCHAR(255) | |
| email | VARCHAR(120) | UNIQUE |
| mobile_number | VARCHAR(15) | UNIQUE |
| password_hash | VARCHAR(255) | hashed, never plain text |
| created_at | TIMESTAMP | default now |

**uploaded_files**
| Column | Type | Notes |
|---|---|---|
| id | INT, PK, AUTO_INCREMENT | |
| user_id | INT, FK → users.id | cascades on delete |
| filename | VARCHAR(255) | saved filename on disk |
| file_type | VARCHAR(10) | pdf / png / jpg / jpeg |
| upload_time | TIMESTAMP | default now |

## Deployment Notes (for hosting)
- For production, set `debug=False` in `app.py` and use a WSGI server like
  **gunicorn** (Linux) or **waitress** (Windows):
  ```bash
  pip install gunicorn
  gunicorn -w 4 -b 0.0.0.0:5000 app:app
  ```
- Set a strong, random `SECRET_KEY` in `.env` for production.
- Make sure the `uploads/` directory has write permissions on the server.
- If hosting MySQL remotely, update `MYSQL_HOST` in `.env` accordingly.

## Security Notes
- Passwords are hashed using `werkzeug.security.generate_password_hash`.
- File uploads are validated both by extension and saved with `secure_filename`.
- Session-based auth — dashboard and upload routes require login (`@login_required`).
- Max upload size capped at 5 MB per request (`MAX_CONTENT_LENGTH`).
