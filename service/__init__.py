"""
Package: service
Package for the application models and service routes
This module initializes the Flask application, SQLAlchemy, CORS, and Talisman security headers.
"""
import sys
from flask import Flask
from flask_talisman import Talisman
from flask_cors import CORS
from service import config
from service.common import log_handlers

# Create Flask application
app = Flask(__name__)
app.config.from_object(config)

# Set up CORS (Cross-Origin Resource Sharing)
CORS(app)

# Set up Talisman with security headers
talisman = Talisman(
    app,
    content_security_policy=None,
    force_https=False
)

# Import routes and models
from service import routes, models  # noqa: E402, F401
from service.common import error_handlers  # noqa: E402

# Set up logging for production
log_handlers.init_app(app)

app.logger.info(70 * "*")
app.logger.info("  A C C O U N T   S E R V I C E   R U N N I N G  ".center(70, "*"))
app.logger.info(70 * "*")

try:
    models.init_db(app)
except Exception as error:
    app.logger.critical("%s: Cannot continue", error)
    sys.exit(4)

app.logger.info("Service initialized!")
