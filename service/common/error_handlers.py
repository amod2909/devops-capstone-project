"""
Error handlers for the Account Service
"""
from flask import jsonify
from service import app
from service.common import status

@app.errorhandler(status.HTTP_400_BAD_REQUEST)
def bad_request(error):
    """Handles bad requests with 400_BAD_REQUEST"""
    return jsonify({
        "status_code": status.HTTP_400_BAD_REQUEST,
        "error": "Bad Request",
        "message": str(error)
    }), status.HTTP_400_BAD_REQUEST

@app.errorhandler(status.HTTP_404_NOT_FOUND)
def not_found(error):
    """Handles resources not found with 404_NOT_FOUND"""
    return jsonify({
        "status_code": status.HTTP_404_NOT_FOUND,
        "error": "Not Found",
        "message": str(error)
    }), status.HTTP_404_NOT_FOUND

@app.errorhandler(status.HTTP_405_METHOD_NOT_ALLOWED)
def method_not_supported(error):
    """Handles unsupported HTTP methods with 405_METHOD_NOT_ALLOWED"""
    return jsonify({
        "status_code": status.HTTP_405_METHOD_NOT_ALLOWED,
        "error": "Method Not Allowed",
        "message": str(error)
    }), status.HTTP_405_METHOD_NOT_ALLOWED

@app.errorhandler(status.HTTP_500_INTERNAL_SERVER_ERROR)
def internal_server_error(error):
    """Handles server errors with 500_INTERNAL_SERVER_ERROR"""
    return jsonify({
        "status_code": status.HTTP_500_INTERNAL_SERVER_ERROR,
        "error": "Internal Server Error",
        "message": str(error)
    }), status.HTTP_500_INTERNAL_SERVER_ERROR
