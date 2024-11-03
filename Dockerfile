# Use an official MapServer image as the base
FROM mapserver/mapserver:latest

# Set UTF-8 locale environment variables
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Switch to root to install dependencies and build tools
USER root

# Install Python, build dependencies, and MapScript requirements
RUN apt-get update && apt-get install -y \
    python3.8 \
    python3.8-dev \
    python3-pip \
    git \
    build-essential \
    cmake \
    libmapserver-dev \
    && rm -rf /var/lib/apt/lists/*

# Set Python 3.8 as the default Python version
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1

# Upgrade pip, setuptools, and wheel
RUN python3.8 -m pip install --upgrade pip setuptools wheel

# Clone MapServer repository and build MapScript from source
RUN git clone https://github.com/MapServer/MapServer.git /mapserver-src \
    && cd /mapserver-src \
    && mkdir build \
    && cd build \
    && cmake .. -DWITH_PYTHON=ON -DPYTHON_EXECUTABLE=/usr/bin/python3.8 \
    && make \
    && make install

# Install FastAPI and Uvicorn
RUN python3.8 -m pip install fastapi uvicorn

# Copy your FastAPI app code into the container
COPY app.py /app/app.py
WORKDIR /app

# Expose the port that FastAPI will run on
EXPOSE 8000

# Switch back to the default non-root user
USER www-data

# Command to run the FastAPI app
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]

