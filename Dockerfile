# 1. Use a specific version for consistency
FROM node:23-slim

# 2. Install system dependencies (Fixes the libatomic crash)
# We combine these and clean the cache to keep the image slim
RUN apt-get update && \
    apt-get install -y libatomic1 && \
    rm -rf /var/lib/apt/lists/*

# 3. Set working directory
WORKDIR /app

# 4. Copy only package files first (This optimizes Docker layer caching)
COPY package*.json ./

# 5. Install dependencies
# Using --omit=dev keeps the image smaller for production
RUN npm install --omit=dev

# 6. Copy the rest of the code
COPY . .

# 7. Build the app (if it's a React/Frontend app)
RUN npm run build --if-present

# 8. Set environment to production
ENV NODE_ENV=production

# 9. Expose port
EXPOSE 3000

# 10. Use a non-root user for security (Best Practice!)
USER node

# Start the application
CMD ["npm", "start"]
