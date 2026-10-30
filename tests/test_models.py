"""
Test Models for Account
"""
from unittest import TestCase
from datetime import date
from service import app
from service.models import Account, db, DataValidationError

class TestAccountModel(TestCase):
    """Test Cases for Account Model"""

    @classmethod
    def setUpClass(cls):
        """This runs once before the entire test suite"""
        app.config["TESTING"] = True
        app.config["DEBUG"] = False
        app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///:memory:"
        db.create_all()

    @classmethod
    def tearDownClass(cls):
        """This runs once after the entire test suite"""
        db.session.close()

    def setUp(self):
        """This runs before each test"""
        db.session.query(Account).delete()
        db.session.commit()

    def tearDown(self):
        """This runs after each test"""
        db.session.remove()

    def test_create_an_account(self):
        """Create an account and assert that it exists"""
        account = Account(
            name="John Doe",
            email="john@example.com",
            address="123 Main St",
            phone_number="555-1234",
            date_joined=date.today()
        )
        self.assertTrue(account is not None)
        self.assertEqual(account.id, None)

    def test_add_an_account(self):
        """Add an account to the database"""
        accounts = Account.all()
        self.assertEqual(accounts, [])
        account = Account(
            name="John Doe",
            email="john@example.com",
            address="123 Main St",
            phone_number="555-1234",
            date_joined=date.today()
        )
        account.create()
        self.assertIsNotNone(account.id)
        accounts = Account.all()
        self.assertEqual(len(accounts), 1)

    def test_read_an_account(self):
        """Read an account from the database"""
        account = Account(
            name="Jane Smith",
            email="jane@example.com",
            address="456 Elm St",
            phone_number="555-5678",
            date_joined=date.today()
        )
        account.create()
        self.assertIsNotNone(account.id)
        found_account = Account.find(account.id)
        self.assertEqual(found_account.id, account.id)
        self.assertEqual(found_account.name, "Jane Smith")

    def test_update_an_account(self):
        """Update an account in the database"""
        account = Account(
            name="Bob Brown",
            email="bob@example.com",
            address="789 Pine Ave",
            phone_number="555-9012",
            date_joined=date.today()
        )
        account.create()
        self.assertIsNotNone(account.id)
        account.name = "Robert Brown"
        account.update()
        found_account = Account.find(account.id)
        self.assertEqual(found_account.name, "Robert Brown")

    def test_delete_an_account(self):
        """Delete an account from the database"""
        account = Account(
            name="Alice White",
            email="alice@example.com",
            address="101 Oak Blvd",
            phone_number="555-3456",
            date_joined=date.today()
        )
        account.create()
        self.assertEqual(len(Account.all()), 1)
        account.delete()
        self.assertEqual(len(Account.all()), 0)

    def test_list_all_accounts(self):
        """List all accounts in the database"""
        self.assertEqual(Account.all(), [])
        for i in range(3):
            account = Account(
                name=f"User{i}",
                email=f"user{i}@example.com",
                address="Address",
                date_joined=date.today()
            )
            account.create()
        self.assertEqual(len(Account.all()), 3)

    def test_find_by_name(self):
        """Find an account by Name"""
        account = Account(
            name="Unique User",
            email="unique@example.com",
            address="Unique Road",
            date_joined=date.today()
        )
        account.create()
        accounts = Account.find_by_name("Unique User")
        self.assertEqual(len(accounts), 1)
        self.assertEqual(accounts[0].email, "unique@example.com")

    def test_serialize_account(self):
        """Serialize an account into a dictionary"""
        account = Account(
            name="John Doe",
            email="john@example.com",
            address="123 Main St",
            phone_number="555-1234",
            date_joined=date.today()
        )
        data = account.serialize()
        self.assertEqual(data["name"], "John Doe")
        self.assertEqual(data["email"], "john@example.com")

    def test_deserialize_account(self):
        """Deserialize an account from a dictionary"""
        data = {
            "name": "Jane Smith",
            "email": "jane@example.com",
            "address": "456 Elm St",
            "phone_number": "555-5678",
            "date_joined": "2023-10-30"
        }
        account = Account()
        account.deserialize(data)
        self.assertEqual(account.name, "Jane Smith")
        self.assertEqual(account.email, "jane@example.com")

    def test_deserialize_invalid_data(self):
        """Deserialize an account with invalid data"""
        data = {"name": "Jane"}
        account = Account()
        self.assertRaises(DataValidationError, account.deserialize, data)

    def test_representation_string(self):
        """Representation string of an Account"""
        account = Account(name="Test", id=1)
        self.assertEqual(str(account), "<Account Test id=[1]>")
