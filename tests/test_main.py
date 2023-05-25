"""Tests for hello world example"""
from fastapi.testclient import TestClient


async def test_main_ok(test_client: TestClient):
    """Does it return 200?"""
    response = test_client.get("/")

    assert response.status_code == 200
