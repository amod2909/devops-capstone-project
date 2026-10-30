"""
Account API Service Test Suite
"""
from unittest import TestCase
from service import app
from service.models import Account, db
from service.common import status

BASE_URL = "/accounts"

class TestAccountService(TestCase):
    """Account Server Tests"""

    @classmethod
    def setUpClass(cls):
        """Run once before all tests"""
        app.config["TESTING"] = True
        app.config["DEBUG"] = False
        app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///:memory:"
        db.create_all()

    @classmethod
    def tearDownClass(cls):
        """Runs once after test suite"""
        db.session.close()

    def setUp(self):
        """Runs before each test"""
        self.client = app.test_client()
        db.session.query(Account).delete()
        db.session.commit()

    def tearDown(self):
        """Runs after each test"""
        db.session.remove()

    def test_health(self):
        """Test Health Check endpoint"""
        response = self.client.get("/health")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        data = response.get_json()
        self.assertEqual(data["status"], "OK")

    def test_index(self):
        """Test Root endpoint"""
        response = self.client.get("/")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_create_account(self):
        """Create an Account"""
        account_data = {
            "name": "John Doe",
            "email": "john@example.com",
            "address": "123 Main St",
            "phone_number": "555-1234"
        }
        response = self.client.post(BASE_URL, json=account_data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        new_account = response.get_json()
        self.assertEqual(new_account["name"], account_data["name"])

    def test_read_account(self):
        """Read an Account"""
        account = Account(name="Alice", email="alice@example.com", address="Road 1")
        account.create()
        response = self.client.get(f"{BASE_URL}/{account.id}")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.get_json()["name"], "Alice")

    def test_update_account(self):
        """Update an Account"""
        account = Account(name="Bob", email="bob@example.com", address="Road 2")
        account.create()
        update_data = {"name": "Robert", "email": "bob@example.com", "address": "Road 2"}
        response = self.client.put(f"{BASE_URL}/{account.id}", json=update_data)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.get_json()["name"], "Robert")

    def test_delete_account(self):
        """Delete an Account"""
        account = Account(name="Charlie", email="charlie@example.com", address="Road 3")
        account.create()
        response = self.client.delete(f"{BASE_URL}/{account.id}")
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)

    def test_list_accounts(self):
        """List all Accounts"""
        for i in range(2):
            acc = Account(name=f"User{i}", email=f"user{i}@example.com", address="Road")
            acc.create()
        response = self.client.get(BASE_URL)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.get_json()), 2)

    def test_query_by_name(self):
        """Query Accounts by Name"""
        account = Account(name="UniqueName", email="unique@example.com", address="Road")
        account.create()
        response = self.client.get(f"{BASE_URL}?name=UniqueName")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.get_json()), 1)

    def test_not_found(self):
        """Test 404 Not Found error handler"""
        response = self.client.get(f"{BASE_URL}/0")
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_method_not_allowed(self):
        """Test 405 Method Not Allowed error handler"""
        response = self.client.post("/health")
        self.assertEqual(response.status_code, status.HTTP_405_METHOD_NOT_ALLOWED)

    def test_cors_headers(self):
        """Test CORS headers present"""
        response = self.client.get("/", headers={"Origin": "http://localhost"})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.headers.get("Access-Control-Allow-Origin"), "*")

    def test_security_headers(self):
        """Test Security headers present"""
        response = self.client.get("/")
        self.assertEqual(response.headers.get("X-Frame-Options"), "SAMEORIGIN")
        self.assertEqual(response.headers.get("X-Content-Type-Options"), "nosniff")
