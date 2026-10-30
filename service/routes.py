"""
Account Service Routes

This service implements a REST API that provides the following operations:
- CREATE an Account
- READ an Account
- UPDATE an Account
- DELETE an Account
- LIST all Accounts
- HEALTH check
"""
from flask import jsonify, request, make_response, abort
from service import app
from service.models import Account
from service.common import status

######################################################################
# HEALTH CHECK
######################################################################
@app.route("/health")
def health():
    """Health check endpoint"""
    return jsonify({
        "status": "OK",
        "name": "Account REST API Service",
        "version": "1.0.0",
        "url": "/accounts"
    }), status.HTTP_200_OK

######################################################################
# ROOT ENDPOINT
######################################################################
@app.route("/")
def index():
    """Root URL response"""
    return jsonify({
        "name": "Account REST API Service",
        "status": "OK",
        "url": "/accounts",
        "version": "1.0.0"
    }), status.HTTP_200_OK

######################################################################
# CREATE AN ACCOUNT
######################################################################
@app.route("/accounts", methods=["POST"])
def create_accounts():
    """Creates a new Account"""
    app.logger.info("Request to create an Account")
    check_content_type("application/json")
    account = Account()
    account.deserialize(request.get_json())
    account.create()
    message = account.serialize()
    location_url = f"/accounts/{account.id}"
    return make_response(
        jsonify(message), status.HTTP_201_CREATED, {"Location": location_url}
    )

######################################################################
# LIST ALL ACCOUNTS
######################################################################
@app.route("/accounts", methods=["GET"])
def list_accounts():
    """List all accounts or query by name"""
    app.logger.info("Request to list Accounts")
    name = request.args.get("name")
    if name:
        accounts = Account.find_by_name(name)
    else:
        accounts = Account.all()
    results = [account.serialize() for account in accounts]
    return jsonify(results), status.HTTP_200_OK

######################################################################
# READ AN ACCOUNT
######################################################################
@app.route("/accounts/<int:account_id>", methods=["GET"])
def get_accounts(account_id):
    """Reads a single Account by ID"""
    app.logger.info("Request to read an Account with id: %s", account_id)
    account = Account.find(account_id)
    if not account:
        abort(status.HTTP_404_NOT_FOUND, f"Account with id [{account_id}] could not be found.")
    return jsonify(account.serialize()), status.HTTP_200_OK

######################################################################
# UPDATE AN ACCOUNT
######################################################################
@app.route("/accounts/<int:account_id>", methods=["PUT"])
def update_accounts(account_id):
    """Updates an existing Account"""
    app.logger.info("Request to update an Account with id: %s", account_id)
    check_content_type("application/json")
    account = Account.find(account_id)
    if not account:
        abort(status.HTTP_404_NOT_FOUND, f"Account with id [{account_id}] could not be found.")
    account.deserialize(request.get_json())
    account.update()
    return jsonify(account.serialize()), status.HTTP_200_OK

######################################################################
# DELETE AN ACCOUNT
######################################################################
@app.route("/accounts/<int:account_id>", methods=["DELETE"])
def delete_accounts(account_id):
    """Deletes an Account"""
    app.logger.info("Request to delete an Account with id: %s", account_id)
    account = Account.find(account_id)
    if account:
        account.delete()
    return make_response("", status.HTTP_204_NO_CONTENT)

######################################################################
# UTILITY FUNCTIONS
######################################################################
def check_content_type(media_type):
    """Checks that the media type is correct"""
    content_type = request.headers.get("Content-Type")
    if content_type and content_type.startswith(media_type):
        return
    app.logger.error("Invalid Content-Type: %s", content_type)
    abort(
        status.HTTP_415_UNSUPPORTED_MEDIA_TYPE,
        f"Content-Type must be {media_type}"
    )
