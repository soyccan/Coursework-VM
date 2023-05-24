package main

import (
	"io/ioutil"
	"log"
	"net"
	"os"
)

func handleConnection(conn net.Conn, filePath string) {
	defer conn.Close()

	// Send the message to the client
	const message = "r10922187 sending from the server"
	_, err := conn.Write([]byte(message))
	if err != nil {
		log.Println("Error sending message:", err)
		return
	}

	// Save the message to a file
	err = ioutil.WriteFile(filePath, []byte(message), 0644)
	if err != nil {
		log.Println("Error saving message to file:", err)
		return
	}

	log.Println("Message sent and saved to file:", message)
}

func main() {
	filePath := os.Getenv("OUT")
	if filePath == "" {
		log.Fatal("env `OUT` not set")
		os.Exit(1)
	}

	// Create the file if it doesn't exist
	file, err := os.Create(filePath)
	if err != nil {
		log.Fatal("Error creating file:", err)
		os.Exit(1)
	}
	defer file.Close()

	// Start the server
	listener, err := net.Listen("tcp", ":5310")
	if err != nil {
		log.Fatal("Error starting server:", err)
		os.Exit(1)
	}
	defer listener.Close()

	log.Println("Server started. Listening on :5310")

	// Accept and handle incoming connections
	for {
		conn, err := listener.Accept()
		if err != nil {
			log.Println("Error accepting connection:", err)
			continue
		}

		go handleConnection(conn, filePath)
	}
}
