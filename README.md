# Hello World Web Framework Benchmark Suite

This repository contains a simple, Dockerized setup to benchmark a "Hello World" endpoint across 5 different web framework/runtime ecosystems:
1. **Laravel 11** (running on **Laravel Octane** with **FrankenPHP**)
2. **Hono v4** (running on **Bun**)
3. **ElysiaJS v1** (running on **Bun**)
4. **Go** (running on standard `net/http`)
5. **NestJS v10** (running on **Fastify** for peak Node.js performance)

All applications are containerized using optimized Dockerfiles and orchestrated using a single `docker-compose.yml` file.

---

## 🔌 Port Mapping & Allocations

When running, each framework binds to port `8000` inside its respective Docker container and is exposed to a distinct port on the host:

| Service | Port (Host) | Core Stack / Engine | Target URL |
| :--- | :--- | :--- | :--- |
| **Laravel** | `8001` | PHP 8.3 + Octane / FrankenPHP | `http://localhost:8001/` |
| **Hono** | `8002` | JavaScript / Bun | `http://localhost:8002/` |
| **ElysiaJS** | `8003` | JavaScript / Bun | `http://localhost:8003/` |
| **Go** | `8004` | Go (net/http standard library) | `http://localhost:8004/` |
| **NestJS** | `8005` | Node.js + NestJS / Fastify | `http://localhost:8005/` |

---

## 🚀 Getting Started on your VPS

### Prerequisites
Make sure your VPS has the following installed:
- **Docker** & **Docker Compose**
- **oha** (HTTP load generator)
  - Install `oha` on Debian/Ubuntu:
    ```bash
    curl -sSfL https://raw.githubusercontent.com/hatoo/oha/master/install.sh | sh
    ```
  - Install `oha` on macOS (via brew):
    ```bash
    brew install oha
    ```

### 1. Build and Run Containers
To pull/build the base images and spin up all 5 framework servers:
```bash
docker compose up -d --build
```

Verify that all containers are healthy and running:
```bash
docker compose ps
```

You can test them manually with `curl`:
```bash
curl http://localhost:8001/  # Should return: Hello World
curl http://localhost:8002/  # Should return: Hello World
curl http://localhost:8003/  # Should return: Hello World
curl http://localhost:8004/  # Should return: Hello World
curl http://localhost:8005/  # Should return: Hello World
```

---

## 📊 Running the Benchmark

We have provided a automated helper script `benchmark.sh` to run the load test. 

### 1. Make the script executable
```bash
chmod +x benchmark.sh
```

### 2. Run the Benchmarks
By default, the script runs the benchmark for `10s` with a concurrency of `100` connections:
```bash
./benchmark.sh
```

You can customize the concurrency (`-c`) and duration (`-d`) using arguments:
```bash
./benchmark.sh -d 30s -c 200
```

The script will warm up all services first and then run `oha` on each container, printing a comparison table at the end, for example:

```markdown
| Framework (Server Engine)       | Requests/sec | Avg Latency  | Success Rate |
| ------------------------------  | ------------ | ------------ | ------------ |
| Laravel 11 (Octane/FrankenPHP)  | 4251.12      | 0.0231s      | 100.00%      |
| Hono v4 (Bun)                   | 58210.45     | 0.0016s      | 100.00%      |
| ElysiaJS v1 (Bun)               | 63120.15     | 0.0015s      | 100.00%      |
| Go (net/http)                   | 75110.80     | 0.0012s      | 100.00%      |
| NestJS v10 (Fastify)            | 28540.90     | 0.0034s      | 100.00%      |
```

---

## 🛑 Stopping the Services
To stop and remove the containers once benchmarks are completed:
```bash
docker compose down
```
