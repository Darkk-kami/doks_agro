# Backend - FastAPI with PostgreSQL

This directory contains the backend of the application built with FastAPI and a PostgreSQL database.

## Prerequisites

- Python 3.8 or higher
- Poetry (for dependency management)
- PostgreSQL (ensure the database server is running)

### Installing Poetry

To install Poetry, follow these steps:

```sh
curl -sSL https://install.python-poetry.org | python3 -
```

Add Poetry to your PATH (if not automatically added):

## Setup Instructions

1. **Navigate to the backend directory**:
    ```sh
    cd backend
    ```

2. **Install dependencies using Poetry**:
    ```sh
    poetry install
    ```

3. **Set up the database with the necessary tables**:
    ```sh
    poetry run bash ./prestart.sh
    ```

4. **Run the backend server**:
    ```sh
    poetry run uvicorn app.main:app --reload
    ```

5. **Update configuration**:
   Ensure you update the necessary configurations in the `.env` file, particularly the database configuration.

## Running with Docker

### Deploying the backend using Docker:

1. **Build the application image:**:
    ```bash
    sudo docker build  -t backend . 
    ```
2. **Run the container based on this image(Note: a postgres container must be running)**:
    ```bash
    sudo docker run -d -p 8000:8000 backend
    ```
