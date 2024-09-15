from flask import Blueprint, jsonify, request
from ..models import Project, db

bp = Blueprint('projects', __name__, url_prefix='/projects')

@bp.route("", methods=["GET"])
def get_projects():
    projects = Project.query.all()
    project_list = [{"id": p.project_id, "name": p.project_name, "description": p.description} for p in projects]
    return jsonify(project_list)

@bp.route("/create", methods=["POST"])
def create_project():
    data = request.get_json()

    # Validate incoming data
    if not data or 'project_name' not in data or 'user_id' not in data:
        return jsonify({"error": "Invalid input"}), 400
    
    # Create new project
    new_project = Project(
        project_name = data['project_name'],
        user_id = data['user_id'],
        description = data['description']
    )

    try:
        db.session.add(new_project)
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500
    
    # Successful user creation
    return jsonify({
        "project_name": new_project.project_name,
        "project_id": new_project.project_id,
    }), 201