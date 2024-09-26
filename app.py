
from flask import Flask

from bp.mission import mission_bp

from db import connection_pool


app = Flask(__name__)


app.register_blueprint(mission_bp, url_prefix="/api/mission")
# app.register_blueprint(worker_bp, url_prefix="/worker")


# Closing the connection pool when app shuts down
# @app.teardown_appcontext
# def close_pool(exception=None):
#     if connection_pool:
#         connection_pool.closeall()


if __name__ == "__main__":
    app.run(debug=True)
