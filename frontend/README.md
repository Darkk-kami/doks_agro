# Frontend - ReactJS with ChakraUI

This directory contains the frontend of the application built with ReactJS and ChakraUI.

## Prerequisites

- Node.js (version 14.x or higher)
- npm (version 6.x or higher)

## Setup Instructions

1. **Navigate to the frontend directory**:
    ```sh
    cd frontend
    ```

2. **Install dependencies**:
    ```sh
    npm install
    ```

3. **Run the development server**:
    ```sh
    npm run dev
    ```

4. **Configure API URL**:
   Ensure the API URL is correctly set in the `.env` file.

## Running with Docker

### To Deploy the frontend using Docker:
1. **Build the application image:**:
    ```bash
    sudo docker build  -t frontend . 
    ```
2. **Run the container based on this image:**:
    ```bash
    sudo docker run -d -p 5173:5173 frontend
    ```
