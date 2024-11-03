# Use an official MapServer image
FROM mapserver/mapserver:latest

# Switch to root to install dependencies
USER root

# Install necessary packages and dependencies
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Install FastAPI and Uvicorn
RUN pip3 install fastapi uvicorn mapscript

# Copy your FastAPI app code into the container
COPY app.py /app/app.py
WORKDIR /app

# Expose the port that FastAPI will run on
EXPOSE 8000

# Switch back to the default non-root user
USER www-data

# Command to run the FastAPI app
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
