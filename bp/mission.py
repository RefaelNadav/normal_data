

from flask import Blueprint, jsonify, request
from services.mission import get_all_missions


mission_bp = Blueprint("mission", __name__)

@mission_bp.route('/', methods=['GET'])
def find_all():
    result, missions = get_all_missions()
    if result is True:
        return jsonify({"missions": missions}), 200
    else:
        return jsonify({"result": result}), 400