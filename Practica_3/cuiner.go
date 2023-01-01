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

	log.Printf("El cuiner de sushi ja és aquí")

	// Obri connexions
	conn, err := amqp.Dial("amqp://guest:guest@localhost:5672/")
	failOnError(err, "Failed to connect to RabbitMQ")
	defer conn.Close()

	ch1, err := conn.Channel()
	failOnError(err, "Failed to open a channel")
	defer ch1.Close()

	ch2, err := conn.Channel()
	failOnError(err, "Failed to open a channel")
	defer ch2.Close()

	// Declaram búffers
	plat, err := ch1.QueueDeclare("plat", false, false, false, false, nil)
	failOnError(err, "Failed to declare a queue")

	qunatitat, err := ch2.QueueDeclare("quantitat", false, false, false, false, nil)
	failOnError(err, "Failed to declare a queue")

	// Decideix quantes peces cuinarà
	total_peces := 10
	peces_niguiri := 0
	peces_sashimi := 0
	peces_maki := 0
	peces_niguiri = rand.Intn(total_peces)
	peces_sashimi = rand.Intn(total_peces - peces_niguiri)
	peces_maki = total_peces - peces_niguiri - peces_sashimi

	// Anuncia les peces que cuniarà
	log.Printf("El cuiner prepararà un plat amb:")
	log.Printf("%d peces de niguiri de salmó", peces_niguiri)
	log.Printf("%d peces de sahimi de tonyina", peces_sashimi)
	log.Printf("%d peces de maki de cranc", peces_maki)

	// Cuina les peces i les posa al plat
	for i := 0; i < peces_niguiri; i++ {
		time.Sleep(time.Duration(rand.Intn(1500)) * time.Millisecond)
		body := "niguiri de salmó"
		err = ch1.Publish("", plat.Name, false, false, amqp.Publishing{ContentType: "text/plain", Body: []byte(body)})
		log.Printf("[x] Posa dins el plat %s", body)
	}
	// Cuina les peces i les posa al plat
	for i := 0; i < peces_sashimi; i++ {
		time.Sleep(time.Duration(rand.Intn(1500)) * time.Millisecond)
		body := "sashimi de tonyina"
		err = ch1.Publish("", plat.Name, false, false, amqp.Publishing{ContentType: "text/plain", Body: []byte(body)})
		log.Printf("[x] Posa dins el plat %s", body)
	}
	// Cuina les peces i les posa al plat
	for i := 0; i < peces_maki; i++ {
		time.Sleep(time.Duration(rand.Intn(1500)) * time.Millisecond)
		body := "maki de cranc"
		err = ch1.Publish("", plat.Name, false, false, amqp.Publishing{ContentType: "text/plain", Body: []byte(body)})
		log.Printf("[x] Posa dins el plat %s", body)

	}

	// Dona permís als clients per menjar
	body := strconv.Itoa(total_peces)
	err = ch1.Publish("", qunatitat.Name, false, false, amqp.Publishing{ContentType: "text/plain", Body: []byte(body)})

}
