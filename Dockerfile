
# Use the official Python image from the Docker Hub
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file to the working directory
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your application code to the container
COPY . .

# Expose port 8000 to the outside world
EXPOSE 8000

# Use gunicorn to run your app (instead of python app.py)
CMD ["gunicorn", "-b", "0.0.0.0:8000", "app:app"]
