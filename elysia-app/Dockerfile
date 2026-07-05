FROM oven/bun:1.1-alpine

WORKDIR /app

# Copy dependencies definitions
COPY package.json ./

# Install dependencies using Bun
RUN bun install

# Copy application files
COPY . .

EXPOSE 8000

CMD ["bun", "run", "index.ts"]
