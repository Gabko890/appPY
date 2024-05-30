FROM python:3.9-slim
WORKDIR ~/appPY
COPY . .
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5000
CMD ["python3", "src/app.py"]