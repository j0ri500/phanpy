# ==========================================
# Stage 1: Build the application
# ==========================================
FROM node:20-alpine AS builder

WORKDIR /app

# 1. Copy package files
COPY package*.json ./

# 2. Copy the scripts folder specifically, because the postinstall hook needs it
COPY scripts/ ./scripts/

# 3. Install dependencies (postinstall will now succeed!)
RUN npm install

# 4. Copy the rest of the application source code
COPY . .

# Set the environment variables required for the build
ENV PHANPY_DEFAULT_INSTANCE=hachyderm.io
ENV PHANPY_DEFAULT_INSTANCE_REGISTRATION_URL=https://hachyderm.io/auth/sign_up
ENV PHANPY_PRIVACY_POLICY_URL=https://hachyderm.io/privacy-policy

# Build the application
RUN npm run build

# ==========================================
# Stage 2: Serve the application
# ==========================================
FROM nginx:alpine

# Copy the built files from the builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
