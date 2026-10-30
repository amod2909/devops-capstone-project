FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application source code
COPY service/ ./service/

# Create a non-root user and change ownership
RUN useradd --uid 1000 theia && chown -R theia:theia /app
USER theia

# Expose port 8080
EXPOSE 8080

# Run gunicorn server
CMD ["gunicorn", "--bind=0.0.0.0:8080", "--log-level=info", "service:app"]
