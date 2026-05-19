FROM docker.io/astral/uv:python3.11-trixie AS builder

WORKDIR /app

# Copy project files
COPY . .

# Install project dependencies into a local venv
RUN uv sync --no-dev

FROM python:3.11-slim

WORKDIR /app
ENV PATH="/app/.venv/bin:${PATH}"

# Copy venv and app from builder
COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app/src /app/src

EXPOSE 9001

CMD ["python", "src/server.py", "--host", "0.0.0.0", "--transport", "sse"]
