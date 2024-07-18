FROM us-docker.pkg.dev/colab-images/public/runtime:latest

# Set environment variables
ENV CUDA_HOME="/usr/local/cuda"

# Install system dependencies and Python 3.10
RUN apt-get update && apt-get install -y cmake git python3.10 python3.10-venv python3-pip

# Set Python 3.10 as the default python version
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1 && \
    update-alternatives --set python3 /usr/bin/python3.10 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1 && \
    update-alternatives --set python /usr/bin/python3.10

# Upgrade pip
RUN python -m pip install --upgrade pip

# Install Python dependencies
RUN pip uninstall -y torch && \
    pip cache purge && \
    pip install torch --index-url https://download.pytorch.org/whl/cu118

# Install llama-cpp-python with CUDA support
RUN pip uninstall -y llama-cpp-python && \
    pip cache remove llama_cpp_python && \
    CMAKE_ARGS="-DLLAMA_CUBLAS=on" FORCE_CMAKE=1 pip install llama-cpp-python==0.2.75 --no-cache-dir

# Install other dependencies
RUN pip install instructlab --no-cache-dir

# Install Hugging Face Hub
RUN pip install huggingface_hub

# Set working directory
WORKDIR /root