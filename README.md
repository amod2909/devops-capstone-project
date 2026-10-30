# Capstone_project
<<<<<<< HEAD
=======

[![CI Build](https://github.com/amod2909/Capstone_project/actions/workflows/ci-build.yaml/badge.svg)](https://github.com/amod2909/Capstone_project/actions/workflows/ci-build.yaml)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Python 3.9](https://img.shields.io/badge/python-3.9-blue.svg)](https://www.python.org/downloads/release/python-390/)

## Overview
This repository contains the complete codebase and pipeline artifacts for the **DevOps Capstone Project**. It includes the RESTful `accounts` microservice built using Python Flask, SQLAlchemy, CORS, and Talisman security headers, along with comprehensive CI/CD automation using GitHub Actions and Tekton Pipelines on OpenShift/Kubernetes.

---

## 📁 Repository Structure

```text
Capstone_project/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   └── user-story.md       # User story issue template for agile sprint planning
│   └── workflows/
│       └── ci-build.yaml       # GitHub Actions CI workflow (linting, tests, coverage)
├── deploy/
│   ├── deployment.yaml         # Kubernetes deployment manifest (with IMAGE_NAME_HERE)
│   └── service.yaml            # Kubernetes service manifest for accounts microservice
├── service/
│   ├── __init__.py             # Flask app initialization with Talisman & CORS
│   ├── config.py               # Database configuration
│   ├── models.py               # Account database model
│   ├── routes.py               # REST API endpoints (CRUD operations)
│   └── common/
│       ├── error_handlers.py   # HTTP error handlers (400, 404, 405, 500)
│       ├── log_handlers.py     # Production logger setup
│       └── status.py           # HTTP status constants
├── tekton/
│   ├── pvc.yaml                # PersistentVolumeClaim for Tekton workspace
│   ├── tasks.yaml              # Custom Tekton tasks (nose test runner task)
│   └── pipeline.yaml           # Complete 5-stage Tekton CD pipeline
├── tests/
│   ├── test_models.py          # Unit tests for Account data model
│   └── test_routes.py          # Unit tests for REST API endpoints
├── submission/
│   ├── screenshots/            # All 16 submission screenshots (.png)
│   ├── text_files/             # All 11 submission cURL, log, and output files
│   └── AI_GRADED_SUBMISSION_GUIDE.md # Step-by-step submission guide
├── Dockerfile                  # Production container Dockerfile
├── setup.cfg                   # Flake8, nosetests, pylint, and coverage configuration
├── requirements.txt            # Python dependencies
└── README.md                   # Repository documentation with CI badge
```

---

## 🚀 REST API Endpoints

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `POST` | `/accounts` | Create a new account |
| `GET` | `/accounts` | List all accounts |
| `GET` | `/accounts/{id}` | Read a single account by ID |
| `PUT` | `/accounts/{id}` | Update an existing account |
| `DELETE` | `/accounts/{id}` | Delete an account |
| `GET` | `/health` | Health check endpoint |

---

## 🔄 CI/CD Automation

- **CI Pipeline (GitHub Actions)**: Automatically triggers on push and pull requests to `main`, validating linting with Flake8 and running unit tests with Nose and 95%+ test coverage.
- **CD Pipeline (Tekton & OpenShift)**: Clones the repository, runs linting and unit tests in parallel, builds the container image using Buildah, pushes to the OpenShift registry, and deploys the microservice using OpenShift CLI.
>>>>>>> c3de1e7 (Initial commit of full DevOps Capstone Project and submission artifacts)
