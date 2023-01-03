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
	peces_a_menjar := rand.Intn(15) + 1

	// Obrir connexions
	log.Printf("Bon vespre vinc a sopar de sushi")
	log.Printf("Avui menjaré %d peces", peces_a_menjar)

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

	// Menjar tantes peces com ha decidit
	for i := 0; i < peces_a_menjar; i++ {
		time.Sleep(time.Duration(rand.Intn(1000)) * time.Millisecond)
		// Espera permís
		qt := <-quantitat
		qt.Ack(false)
		aux, _ := strconv.Atoi(string(qt.Body))
		aux--
		a := <-plat
		a.Ack(false)

		log.Printf("Ha agafat un %s", string(a.Body))
		log.Printf("Al plat hi ha %d peces", aux)

		// Només publica un missatge al canal quan en queden més per així fer que els altres clients segueixin esperant
		if aux > 0 {
			body := strconv.Itoa(aux)
			err = ch2.Publish("", "quantitat", false, false, amqp.Publishing{ContentType: "text/plain", Body: []byte(body)})
		}

	}

}
