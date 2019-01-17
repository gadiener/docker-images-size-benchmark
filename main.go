package main

import (
	"log"
	"fmt"
	"net/http"
)

func main() {
	http.Handle("/", http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Printf("[INFO]: Access on %q", r.RequestURI)
		fmt.Fprintf(w, "Hello world!")
	}))
	log.Println("[INFO]: Hello world app is running on port 3000")
	http.ListenAndServe(":3000", nil)
}