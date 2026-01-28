// handler.go
package main

import (
	"fmt"
	"net/http"
)

func (c *Counter) handlerIndex(w http.ResponseWriter, r *http.Request) {
	count, err := c.redis.Get()
	if err != nil {
		http.Error(w, "Failed to get counter", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(fmt.Sprintf("<html><body><h1>This is visitor %d</h1></body></html>", count)))
}

// Middleware to increment counter on each request
func (c *Counter) VistorMetricsInc(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path == "/" {
			c.redis.IncrBy(1)
		}
		next.ServeHTTP(w, r)
	})
}
