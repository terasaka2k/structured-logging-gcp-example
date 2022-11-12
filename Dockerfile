# syntax=docker/dockerfile:1
FROM python:alpine

ENV PORT=8080
ENV PYTHONUNBUFFERED=1

WORKDIR /app
COPY requirements.txt ./
RUN pip install -r requirements.txt

COPY .env.dev ./
COPY *.py ./

CMD exec python -m flask --app=main run --host=0.0.0.0 --port=$PORT
