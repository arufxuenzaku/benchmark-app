package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprint(w, "Hello World")
	})
	
	// Start server on container port 8000
	fmt.Println("Go server starting on port 8000...")
	if err := http.ListenAndServe(":8000", nil); err != nil {
		panic(err)
	}
}
