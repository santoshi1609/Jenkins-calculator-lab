FROM python:3.14-slim

WORKDIR /app

COPY calculator.py .
COPY test_calculator.py .

RUN pip install pytest

CMD ["python", "-m", "pytest", "-v"]
