Let's create our FastAPI application! 

To create our app, we'll specify a few imports, initialize a class, and define functions that map to HTTP URL routes and HTTP Methods. 

Let's craete a Python module named `main.py` in our Python project’s src folder we created earlier with the following command:
```bash
cat > ./src/main.py << EOL
# Import the FastAPI class from the fastapi module.
from fastapi import FastAPI

# Declare an instance of the FastAPI class.
app = FastAPI()

# use the app instance as a decorator to handle an 
# HTTP route and HTTP method.
@app.get("/")
def read_index():
    """
    Return a Python Dictionary that supports JSON serialization.
    """
    return {"Hello": "World"}
EOL
```{{exec}}

Now, let’s run it as web server with uvicorn using the following command:
```bash
uvicorn src.main:app --reload --port 80
```{{exec}}

With our web server running, open the app in a new tab:
[click here]({{TRAFFIC_HOST1_80}})