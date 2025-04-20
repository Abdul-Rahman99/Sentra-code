FROM python:3.12-slim

WORKDIR /app

RUN apt-get update && \
    apt-get install -y nmap python3-venv gcc libffi-dev libxml2-dev libxslt1-dev libssl-dev && \
    apt-get clean

COPY requirements.txt .

RUN python -m venv env && \
    ./env/bin/pip install --upgrade pip && \
    ./env/bin/pip install -r requirements.txt && \
    sed -i "s/codeset/#codeset/" env/lib/python3.12/site-packages/wapitiCore/language/language.py || true

COPY . .

EXPOSE 8080

CMD ["./env/bin/uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
