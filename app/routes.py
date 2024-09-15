from flask import Blueprint, jsonify
from .models import User, Project

bp = Blueprint('main', __name__)

@bp.route("/users", methods=["GET"])
def get_users():
    users = User.query.all()
    users_list = [{"id": u.user_id, "username": u.username, "email": u.email} for u in users]
    return jsonify(users_list)

@bp.route("/projects", methods=["GET"])
def get_projects():
    projects = Project.query.all()
    project_list = [{"id": p.project_id, "name": p.project_name, "description": p.description} for p in projects]
    return jsonify(project_list)
