FROM recsys:py309

# Install build dependencies
WORKDIR /app

COPY requirements.txt /app/
RUN pip install --upgrade pip

RUN pip install -r requirements.txt
COPY streamlit_app.py /app/

EXPOSE 8501

HEALTHCHECK CMD curl --fail http://localhost:8501/_stcore/HEALTHCHECK

ENTRYPOINT ["streamlit", "run", "streamlit_app.py", "--server.port=8501", "--server.address=0.0.0.0"]