FROM alpine:latest

RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip flask 
WORKDIR /app

COPY *.py ./
COPY servers.json ./

EXPOSE 8001

ARG FLASK_APP=app.py

CMD python3 -m flask run --host=0.0.0.0 --port=8001