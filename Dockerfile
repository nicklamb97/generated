FROM us-docker.pkg.dev/colab-images/public/runtime:latest

# Set environment variables
ENV CUDA_HOME="/usr/local/cuda"

# Add retry mechanism for apt-get and configure for IPv4
RUN echo 'Acquire::Retries "3";' > /etc/apt/apt.conf.d/80-retries && \
    echo 'Acquire::ForceIPv4 "true";' > /etc/apt/apt.conf.d/99force-ipv4

# Update package lists and install system dependencies
RUN apt-get update -o Acquire::CompressionTypes::Order::=gz || true
RUN apt-get install -y --no-install-recommends --fix-missing cmake git || true
RUN apt-get install -y --no-install-recommends --fix-missing python3-pip || true

# Clean up apt cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN python3 -m pip install --no-cache-dir --upgrade pip

# Install Python dependencies
RUN pip3 install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cu118 || true

# Install llama-cpp-python with CUDA support
RUN CMAKE_ARGS="-DLLAMA_CUBLAS=on" FORCE_CMAKE=1 pip3 install --no-cache-dir llama-cpp-python==0.2.75 || true

# Install other dependencies
RUN pip3 install --no-cache-dir instructlab huggingface_hub || true

# Set working directory
WORKDIR /root