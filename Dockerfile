# Use an official MapServer image
FROM mapserver/mapserver:latest

# Set UTF-8 locale environment variables
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Switch to root to install dependencies
USER root

# Install Python 3.8 and dependencies, including pip for Python 3.8
RUN apt-get update && apt-get install -y \
    python3.8 \
    python3.8-dev \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Set Python 3.8 as the default Python version
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1

# Upgrade pip, setuptools, and wheel to the latest versions
RUN python3.8 -m pip install --upgrade pip setuptools wheel

# Install FastAPI, Uvicorn, and MapScript with explicit Python 3.8 pip
RUN python3.8 -m pip install fastapi uvicorn mapscript

# Copy your FastAPI app code into the container
COPY app.py /app/app.py
WORKDIR /app

# Expose the port that FastAPI will run on
EXPOSE 8000

# Switch back to the default non-root user
USER www-data

# Command to run the FastAPI app
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
