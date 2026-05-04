# ==========================================
# Stage 1: Build the application
# ==========================================
FROM node:20-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application source code
COPY . .

# Set the environment variables required for the build
ENV PHANPY_DEFAULT_INSTANCE=gts.enby.gay

# Build the application (outputs to the /app/dist folder)
RUN npm run build

# ==========================================
# Stage 2: Serve the application
# ==========================================
FROM nginx:alpine

# Copy the built files from the builder stage into Nginx's default serving directory
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80 to the host
EXPOSE 80

# Start Nginx and keep it running in the foreground
CMD ["nginx", "-g", "daemon off;"]
