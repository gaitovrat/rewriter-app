FROM python:3.10 AS build
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

COPY pyproject.toml uv.lock ./

RUN uv sync --locked

FROM python:3.10 AS runtime

RUN addgroup --system app && adduser --system --ingroup app app

WORKDIR /app

USER app
COPY --chown=app:app app .
COPY --chown=app:app --from=build /app/.venv ./.venv

ENV PATH="/app/.venv/bin:$PATH"

EXPOSE 8000

ENTRYPOINT [ "fastapi" ]
CMD [ "run", "main.py", "--port", "8000" ]
