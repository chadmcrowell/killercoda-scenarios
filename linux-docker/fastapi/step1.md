create a python app from the FastAPI web framework

FastAPI is a modern, fast (high-performance), web framework for building APIs with Python 3.8+ based on standard Python type hints

We will use the built-in virtual environment manager known as `venv`.

Create a directory for our python code with the following command:
```
mkdir -p ~/dev/py/src/ && cd ~/dev/py
```{{exec}}

Create a virtual environment for our python project with the following command:
```
python3 -m venv venv 
```{{exec}}

Activate our new virtual environment with the following command:
```
source venv/bin/activate
```{{exec}}

Now that our virtual environment is activated, we can start installing our project’s third-party dependencies using the Python Package Manager (pip).

To install our dependencies, we'll use a feature in pip that allows us to reference a file full of packages to install.

Create our dependencies file with the following command:
```
cat > ./src/requirements.txt << EOL
fastapi
jinja2
uvicorn
gunicorn
EOL
```{{exec}}

Install all packages via the newly created requirements file with the following command:
```
python -m pip install -r src/requirements.txt
```{exec}

Now, let's start writing our FastAPI code!