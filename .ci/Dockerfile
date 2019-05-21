FROM python:3.6.8-stretch

RUN apt-get update && \
    apt-get install -y \
    git \
    openssl \
    python3-enchant && \
    pip install --no-cache-dir flake8 flake8-docstrings pylint pyenchant black pytest

