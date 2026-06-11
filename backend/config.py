# config.py – Central configuration for Diethive backend

import os
import secrets

class Config:
    # Flask secret key – used for session signing
    SECRET_KEY = os.getenv("FLASK_SECRET_KEY", secrets.token_urlsafe(32))

    # JWT secret key – used by Flask-JWT-Extended
    JWT_SECRET_KEY = os.getenv("JWT_SECRET_KEY", secrets.token_urlsafe(32))

    # Mail server configuration (environment variables recommended)
    MAIL_SERVER = os.getenv("MAIL_SERVER", "smtp.gmail.com")
    MAIL_PORT = int(os.getenv("MAIL_PORT", "587"))
    MAIL_USE_TLS = os.getenv("MAIL_USE_TLS", "True").lower() == "true"
    MAIL_USERNAME = os.getenv("MAIL_USERNAME")  # Must be set in production
    MAIL_PASSWORD = os.getenv("MAIL_PASSWORD")  # Must be set in production

    # Database connection defaults – can be overridden via env vars
    DB_HOST = os.getenv("DB_HOST", "127.0.0.1")
    DB_PORT = int(os.getenv("DB_PORT", "3307"))
    DB_USER = os.getenv("DB_USER", "root")
    DB_PASSWORD = os.getenv("DB_PASSWORD", "")
    DB_NAME = os.getenv("DB_NAME", "diethive")
