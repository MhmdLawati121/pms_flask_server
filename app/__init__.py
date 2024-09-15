from flask import Flask
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

def create_app():
    app = Flask(__name__)
    CORS(app)
    
    app.config.from_object('app.config.Config')
    
    db.init_app(app)
    
    with app.app_context():
        from . import models
        from .routes import register_routes
        register_routes(app)
    
    return app
