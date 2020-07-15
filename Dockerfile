FROM python:3.8-alpine

ENV PUPPETBOARD_PORT 8088
EXPOSE 8088

ENV PUPPETBOARD_SETTINGS docker_settings.py
RUN mkdir -p /usr/src/app/
WORKDIR /usr/src/app/

# Workaround for https://github.com/benoitc/gunicorn/issues/2160
RUN apk --update --no-cache add libc-dev binutils

COPY requirements*.txt /usr/src/app/
RUN pip install --no-cache-dir -r requirements-docker.txt

COPY . /usr/src/app

# Use entrypoint.sh to stop running processes as root
#  - CMD gunicorn -b 0.0.0.0:${PUPPETBOARD_PORT} --workers="${PUPPETBOARD_WORKERS:-1}" -e SCRIPT_NAME="${PUPPETBOARD_URL_PREFIX:-}" --access-logfile=- puppetboard.app:app

COPY entrypoint.sh /
RUN  chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
