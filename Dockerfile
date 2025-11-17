# -----------------------------
# 1️⃣ BUILD STAGE (dependencies + build)
# -----------------------------
FROM node:22-alpine AS builder

# Set working directory
WORKDIR /app

# Install libc6-compat for some npm packages (optional but recommended)
RUN apk add --no-cache libc6-compat

# Copy package.json and package-lock.json first (for Docker caching)
COPY package*.json ./

# Install only production dependencies
RUN npm ci --omit=dev

# Copy source code
COPY . .

# -----------------------------
# 2️⃣ RUNTIME STAGE (clean, small, secure)
# -----------------------------
FROM node:22-alpine AS runner

WORKDIR /app

# Copy only necessary files from builder stage
COPY --from=builder /app /app

# Expose the application port
EXPOSE 3000

# Set node environment
ENV NODE_ENV=production

# Run the application
CMD ["node", "index.js"]
