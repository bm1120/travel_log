FROM python:3.9
LABEL description = "Analytics Environment python 3.9"

RUN mkdir -p /notebooks

WORKDIR /notebooks

RUN pip install --upgrade pip
COPY requirements.txt requirements.txt

RUN pip3 install -r requirements.txt