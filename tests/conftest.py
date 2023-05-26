"""Useful fixtures etc. for tests"""
import fastapi
import pytest
from fastapi.testclient import TestClient

from app.main import app as app_


@pytest.fixture(scope="function")
async def app() -> fastapi.FastAPI:
    """Main app being tested"""

    return app_


@pytest.fixture(scope="function")
async def test_client(app: fastapi.FastAPI) -> TestClient:
    """Test client to make requests to the app."""

    return TestClient(app)
