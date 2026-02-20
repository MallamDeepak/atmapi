FROM node:18-alpine

WORKDIR /app

# Copy backend files only
COPY backend/package*.json ./

# Install dependencies
RUN npm install --production

# Copy backend source code
COPY backend/ .

# Expose port
EXPOSE 3000

# Start server
CMD ["npm", "start"]
