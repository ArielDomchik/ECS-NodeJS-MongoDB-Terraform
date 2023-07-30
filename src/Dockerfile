FROM public.ecr.aws/docker/library/python:3.12.0b4-alpine
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
RUN adduser -D myuser && chown -R myuser /templates/index.html /templates/error.html app.py /templates
USER myuser
EXPOSE 8080
CMD ["python3", "app.py"]
