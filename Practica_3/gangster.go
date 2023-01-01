/*
Autors:
		Marc Melià Fleixas
		Xavier Vives Marcus

Vídeo:
		https://www.youtube.com/watch?v=JbF-u2xe0QU&ab_channel=XavierVives
*/

package main

import (
	"log"
	"math/rand"
	"strconv"
	"time"

	amqp "github.com/rabbitmq/amqp091-go"
)

func failOnError(err error, msg string) {
	if err != nil {
		log.Panicf("%s: %s", msg, err)
	}
}

func main() {
	rand.Seed(time.Now().UnixNano())

	log.Printf("Bon vespre vinc a sopar de sushi\nHo vull tot!")

	// Obrim connexions
	conn, err := amqp.Dial("amqp://guest:guest@localhost:5672/")
	failOnError(err, "Failed to connect to RabbitMQ")
	defer conn.Close()

	ch1, err := conn.Channel()
	failOnError(err, "Failed to open a channel")
	defer ch1.Close()

	ch2, err := conn.Channel()
	failOnError(err, "Failed to open a channel")
	defer ch2.Close()

	// Obrim canal per consumir
	plat, err := ch1.Consume("plat", "", false, false, false, false, nil)
	failOnError(err, "Failed to declare a queue")

	// Obrim canal per consumir
	quantitat, err := ch2.Consume("quantitat", "", false, false, false, false, nil)
	failOnError(err, "Failed to declare a queue")

	// Simula una espera
	time.Sleep(time.Duration(rand.Intn(1000)) * time.Millisecond)

	// Espera permís
	qt := <-quantitat
	qt.Ack(false)
	j, _ := strconv.Atoi(string(qt.Body))
	// Menja totes les peces
	for i := 0; i < j; i++ {
		p := <-plat
		p.Ack(false)
	}

	log.Printf("Romp el plat")
	log.Printf("Me'n vaig")

}
