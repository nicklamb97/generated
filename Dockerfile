FROM us-docker.pkg.dev/colab-images/public/runtime:latest

# Set environment variables
ENV CUDA_HOME="/usr/local/cuda"

# Install system dependencies
RUN apt-get update && apt-get install -y cmake git

# Set Python version to 3.10.0
RUN pyenv install 3.10.0 && \
    pyenv global 3.10.0

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip uninstall -y torch && \
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