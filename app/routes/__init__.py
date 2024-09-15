from flask import Blueprint

bp = Blueprint('main', __name__)

from . import users, projects

def register_routes(app):
    app.register_blueprint(users.bp)
    app.register_blueprint(projects.bp)
