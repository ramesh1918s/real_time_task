# ----------------------
# Stage 1: Build stage
# ----------------------
FROM python:3.10-slim as builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y gcc libpq-dev && rm -rf /var/lib/apt/lists/*

# Install Python dependencies into a temp folder
COPY requirements.txt .
RUN pip install --user -r requirements.txt

# ----------------------
# Stage 2: Runtime stage
# ----------------------
FROM python:3.10-slim

WORKDIR /app

# Copy only installed dependencies from builder
COPY --from=builder /root/.local /root/.local

# Update PATH for installed packages
ENV PATH=/root/.local/bin:$PATH

# Copy application code
COPY app.py .

# Run the app
CMD ["python", "app.py"]
