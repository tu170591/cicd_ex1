ARG PYTHON_VERSION=3.8.19
FROM python:${PYTHON_VERSION}-alpine3.20 as base

ENV PYTHONDONTWRITEBYTECODE=1

ENV PYTHONUNBUFFERED=1

WORKDIR /app

ARG UID=10001

RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    toandn

RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=bind,source=requirements.txt,target=requirements.txt \
    python -m pip install -r requirements.txt

USER toandn

COPY counter-service.py .

EXPOSE 8080

CMD ["gunicorn", "counter-service:app", "--bind", "0.0.0.0:8080", "--access-logfile", "-", "--error-logfile", "-"]
