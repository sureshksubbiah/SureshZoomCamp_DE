FROM python:3.9.1
# We need to install curl to download the file from url
RUN apt-get install curl
# psycopg2 is a postgres db adapter for python: sqlalchemy needs it
RUN pip install pandas sqlalchemy psycopg2

WORKDIR /app

COPY Ingest_Data_csv.py Ingest_Data_csv.py

ENTRYPOINT ["python","Ingest_Data_csv.py"]