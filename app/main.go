// main.go
package main

import (
	"context"
	"log"
	"net/http"
	"os"
)

type Counter struct {
	redis *RedisCounter
	ctx   context.Context
}

func main() {
	ctx := context.Background()
	port := "8080"
	redisAddr := "localhost:6379"
	if v := os.Getenv("REDIS_ADDR"); v != "" {
		redisAddr = v
	}
	redisPass := os.Getenv("REDIS_PASSWORD")

	// Initialize Redis counter
	redisCounter, err := NewCounter(redisAddr, redisPass, "visitor_count", 0)
	if err != nil {
		log.Fatalf("Failed to connect to Redis: %v", err)
	}

	// Test Redis connection
	if err := redisCounter.RedisHealth(); err != nil {
		log.Fatalf("Redis health check failed: %v", err)
	}
	log.Println("Connected to Redis successfully")

	counter := &Counter{redis: redisCounter, ctx: ctx}
	mux := http.NewServeMux()

	mux.HandleFunc("/", counter.handlerIndex)

	srv := &http.Server{
		Addr:    ":" + port,
		Handler: counter.VistorMetricsInc(mux),
	}

	log.Printf("Server running on port: %s\n", port)
	log.Fatal(srv.ListenAndServe())
}
