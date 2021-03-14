FROM alpine:latest

RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip flask requests

ENV exposed_port=5000

EXPOSE $exposed_port

WORKDIR /app

COPY *.py ./

ARG FLASK_APP=app.py

CMD python3 -m flask run --host=0.0.0.0 --port=$exposed_port
