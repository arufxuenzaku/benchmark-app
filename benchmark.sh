#!/usr/bin/env bash

# Check if oha is installed
if ! command -v oha &> /dev/null
then
    echo "Error: oha is not installed. Please install it first."
    echo "On Debian/Ubuntu: curl -sSfL https://raw.githubusercontent.com/hatoo/oha/master/install.sh | sh"
    echo "Or via cargo: cargo install oha"
    exit 1
fi

DURATION="10s"
CONCURRENCY="100"

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -d|--duration) DURATION="$2"; shift ;;
        -c|--concurrency) CONCURRENCY="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

echo "=========================================================="
echo " Starting Hello World Benchmark (oha) "
echo " Duration: $DURATION | Concurrency: $CONCURRENCY "
echo "=========================================================="
echo ""

# Warm-up phase
echo "Warming up applications..."
for i in {1..5}; do
    curl -s -o /dev/null http://localhost:8001/
    curl -s -o /dev/null http://localhost:8002/
    curl -s -o /dev/null http://localhost:8003/
    curl -s -o /dev/null http://localhost:8004/
    curl -s -o /dev/null http://localhost:8005/
done
sleep 2
echo "Warm-up complete!"
echo ""

# Running benchmarks
echo "Running benchmarks (logging outputs)..."

echo "[1/5] Benchmarking Laravel (Octane/FrankenPHP)..."
oha -z "$DURATION" -c "$CONCURRENCY" --no-tui http://localhost:8001/ > laravel.log 2>&1

echo "[2/5] Benchmarking Hono (Bun)..."
oha -z "$DURATION" -c "$CONCURRENCY" --no-tui http://localhost:8002/ > hono.log 2>&1

echo "[3/5] Benchmarking ElysiaJS (Bun)..."
oha -z "$DURATION" -c "$CONCURRENCY" --no-tui http://localhost:8003/ > elysia.log 2>&1

echo "[4/5] Benchmarking Go (net/http)..."
oha -z "$DURATION" -c "$CONCURRENCY" --no-tui http://localhost:8004/ > go.log 2>&1

echo "[5/5] Benchmarking NestJS (Fastify)..."
oha -z "$DURATION" -c "$CONCURRENCY" --no-tui http://localhost:8005/ > nestjs.log 2>&1

echo ""
echo "=========================================================="
echo "                     BENCHMARK RESULTS                    "
echo "=========================================================="
echo ""

# Helper to extract statistics
extract_stats() {
    local log_file=$1
    local label=$2
    
    # Extract metrics using grep and awk
    local rps=$(grep -i "Requests/sec:" "$log_file" | sed 's/[[:space:]]//g' | cut -d':' -f2)
    local avg_lat=$(grep -i "Average:" "$log_file" | sed 's/[[:space:]]//g' | cut -d':' -f2)
    local success=$(grep -i "Success rate:" "$log_file" | sed 's/[[:space:]]//g' | cut -d':' -f2)
    
    # Format fallback if extraction fails
    if [ -z "$rps" ]; then rps="N/A"; fi
    if [ -z "$avg_lat" ]; then avg_lat="N/A"; fi
    if [ -z "$success" ]; then success="N/A"; fi

    printf "| %-30s | %-12s | %-12s | %-12s |\n" "$label" "$rps" "$avg_lat" "$success"
}

# Print Table Header
printf "| %-30s | %-12s | %-12s | %-12s |\n" "Framework (Server Engine)" "Requests/sec" "Avg Latency" "Success Rate"
printf "| %-30s | %-12s | %-12s | %-12s |\n" "------------------------------" "------------" "------------" "------------"

# Print Table Rows
extract_stats "laravel.log" "Laravel 11 (Octane/FrankenPHP)"
extract_stats "hono.log" "Hono v4 (Bun)"
extract_stats "elysia.log" "ElysiaJS v1 (Bun)"
extract_stats "go.log" "Go (net/http)"
extract_stats "nestjs.log" "NestJS v10 (Fastify)"

# Clean up raw logs
rm laravel.log hono.log elysia.log go.log nestjs.log
