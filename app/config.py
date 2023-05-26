import pydantic


class Settings(pydantic.BaseSettings):
    """Settings for the app"""
    
    ROOT_PATH = ""


settings = Settings()