# Use Python 3.13 slim image
FROM python:3.13-slim

# Create user
#ARG DOCKER_USER=sieve
#RUN groupadd -r $DOCKER_USER && useradd -r -M $DOCKER_USER -g $DOCKER_USER

# Install required tools: curl, unzip, jq
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Set user
#USER $DOCKER_USER:$DOCKER_USER

# Set the working directory
WORKDIR /opt/sieve

# Create a virtual environment
#RUN python -m venv /opt/sieve
#ENV PATH="/opt/sieve/bin:$PATH"

# Try to fetch the latest release, fallback to 0.6.1 if it fails
RUN set -e; \
    FALLBACK_URL="https://github.com/thsmi/sieve/releases/download/0.6.1/sieve-0.6.1-web.zip"; \
    RELEASE_URL=$(curl -s https://api.github.com/repos/thsmi/sieve/releases/latest \
        | jq -r '.assets[] | select(.name | test("web\\.zip$")) | .browser_download_url') \
        || RELEASE_URL="$FALLBACK_URL"; \
    echo "Using release URL: $RELEASE_URL"; \
    mkdir /tmp/sieve_extract; \
    curl -L -o /tmp/sieve.zip "$RELEASE_URL"; \
    unzip /tmp/sieve.zip -d /tmp/sieve_extract; \
    rm /tmp/sieve.zip; \
    CONTENTS=$(find /tmp/sieve_extract -mindepth 1 -maxdepth 1); \
    COUNT=$(echo "$CONTENTS" | wc -l); \
    if [ "$COUNT" -eq 1 ] && [ -d "$CONTENTS" ]; then \
        echo "Detected top-level directory: $CONTENTS"; \
        cp -r "$CONTENTS"/* /opt/sieve/; \
    else \
        echo "No top-level directory, copying all contents."; \
        cp -r /tmp/sieve_extract/* /opt/sieve/; \
    fi; \
    rm -rf /tmp/sieve_extract

# Expose app port
EXPOSE 8765

# Start the app
CMD ["python", "main.py"]
