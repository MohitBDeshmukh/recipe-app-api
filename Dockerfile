FROM python:3.9-alpine3.13
LABEL maintainer="mohit9"

ENV PYTHONUNBUFFERED=1

# Copy the requirements files
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Copy the app to the container
COPY ./app /app

# Set the working directory
WORKDIR /app
EXPOSE 8000

# Add an argument for development mode and pass it to the environment
ARG dev=false
ENV DEV=$dev

# Install dependencies and ensure development requirements are installed
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip --no-cache-dir && \
    /py/bin/pip install -r /tmp/requirements.txt --no-cache-dir && \
    if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt --no-cache-dir; fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Add the virtual environment binaries to PATH
ENV PATH="/py/bin:$PATH"

# Switch to the non-root user
USER django-user
