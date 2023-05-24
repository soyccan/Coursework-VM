package main

import (
	"io/ioutil"
	"log"
	"net"
	"os"
)

func main() {
	// Connect to the server
	addr := os.Getenv("SVR_ADDR")
	if addr == "" {
		log.Fatal("env `SVR_ADDR` not set")
		os.Exit(1)
	}

	conn, err := net.Dial("tcp", addr)
	if err != nil {
		log.Println("Failed to connect to the server:", err)
		os.Exit(1)
	}
	defer conn.Close()

	// Read the message from the server
	message, err := ioutil.ReadAll(conn)
	if err != nil {
		log.Println("Failed to read message from server: ", err)
		os.Exit(1)
	}

	// Write the message into a file
	filePath := os.Getenv("OUT")
	if filePath == "" {
		log.Fatal("env `OUT` not set")
		os.Exit(1)
	}

	err = ioutil.WriteFile(filePath, message, 0644)
	if err != nil {
		log.Println("Failed to write message to file: ", err)
		os.Exit(1)
	}

	log.Println("Message received and saved to file.")
}
