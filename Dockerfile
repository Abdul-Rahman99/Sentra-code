# Use the official Python slim image
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install system dependencies required for Wapiti and other packages
RUN apt-get update && \
    apt-get install -y nmap python3-venv gcc libffi-dev libxml2-dev libxslt1-dev libssl-dev && \
    apt-get clean

# Copy requirements and install dependencies
COPY requirements.txt .

# Create venv and install packages
RUN python -m venv env && \
    ./env/bin/pip install --upgrade pip && \
    ./env/bin/pip install -r requirements.txt && \
    # Fix the wapiti crash on 'codeset'
    sed -i "s/codeset/#codeset/" env/lib/python3.12/site-packages/wapitiCore/language/language.py || true

# Copy the rest of the app
COPY . .

# Expose port for Uvicorn
EXPOSE 8080

# Run the app
CMD ["./env/bin/uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
