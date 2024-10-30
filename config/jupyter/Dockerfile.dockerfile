FROM recsys:py309
LABEL description = "Test Environment for modeling & analysis"

RUN mkdir -p /notebooks

WORKDIR /notebooks

RUN pip install --upgrade pip
COPY requirements.txt requirements.txt

RUN pip install jupyter -U && pip install jupyterlab
RUN pip3 install -r requirements.txt

EXPOSE 8888

ENTRYPOINT ["jupyter", "lab","--ip=0.0.0.0","--allow-root", "--NotebookApp.token=''"]