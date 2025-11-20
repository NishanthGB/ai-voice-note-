# Dockerfile for AI Voice Note Backend
# Node 18 LTS image with a lightweight base
FROM node:18-slim

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies (production only to keep image small)
COPY package*.json ./
RUN npm ci --only=production

# Copy source
COPY . .

# Ensure uploads dir exists
RUN mkdir -p /usr/src/app/uploads

# Use PORT env var (Cloud Run sets this). Default to 8080.
ENV PORT 8080
EXPOSE 8080

# Start the server
CMD ["node", "server.js"]
