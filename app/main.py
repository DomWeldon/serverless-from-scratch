"""Hello World FastAPI App
-----------------------

An example FastAPI that we'll put in the serverless cloud.
"""
import fastapi
import mangum

from .config import settings

app = fastapi.FastAPI(
    root_path=settings.ROOT_PATH,
)


@app.get("/")
async def hello_world():
    """Index route."""

    return fastapi.Response("Hello world!")


# handler for AWS Lambda
handler = mangum.Mangum(app)


__all__ = [
    "handler",
]