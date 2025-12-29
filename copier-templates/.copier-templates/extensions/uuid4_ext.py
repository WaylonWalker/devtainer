from jinja2.ext import Extension
import uuid


class UUID4Extension(Extension):
    def __init__(self, environment):
        super().__init__(environment)
        environment.globals["uuid4"] = lambda: str(uuid.uuid4())
