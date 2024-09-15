from flask import Blueprint, jsonify, request
from ..models import User, db

bp = Blueprint('users', __name__, url_prefix='/users')

@bp.route("", methods=["GET"])
def get_users():
    users = User.query.all()
    users_list = [{"id": u.user_id, "username": u.username, "email": u.email} for u in users]
    return jsonify(users_list)

@bp.route("/create", methods=["POST"])
def create_user():
    data = request.get_json()

    # Validate incoming data
    if not data or 'username' not in data or 'email' not in data or 'password' not in data:
        return jsonify({"error": "Invalid input"}), 400
    
    # Create new user
    new_user = User(
        username = data['username'],
        email = data['email'],
        password = data['password']
    )

    try:
        db.session.add(new_user)
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500
    
    # Successful user creation
    return jsonify({
        "id": new_user.user_id,
        "username": new_user.username,
        "email": new_user.email
    }), 201
