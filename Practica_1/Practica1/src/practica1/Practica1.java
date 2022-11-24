package practica1;

import java.util.Random;
import java.util.concurrent.Semaphore;

/**
 *
 * @author xvive
 */
public class Practica1 {

    final String NOMS[] = {"Joaquim", "Goku", "Alicia", "Victòria", "Xisca", "Biel", "Xavier", "Elena", "Magdalena", "Marc", "Miquel", "Toni",
        "Lluís", "Sílvia", "Martí", "Josep", "Damià", "Ester", "Ventura", "Bàrbara", "Aina", "Julià", "Albert", "Eva", "Maria", "Àngels",
        "Tomeu", "Gerard", "Mateu", "Jordi", "Joan", "Carolina", "Bel", "Amadeu", "Emili", "Daniel", "Carles", "Felip", "Laura", "Andreu", "Joel",
        "Pau", "Roderic", "Ernest", "Vicenç", "Abril", "Venus", "Zeus", "Mart", "Morfeu"};

    final int N_ESTUDIANTS = 10;
    final int N_RONDES = 3;
    final int CAPACITAT_SALA = 4;
    static int capacitat = 0;
    static Semaphore sala = new Semaphore(1);
    static Semaphore director = new Semaphore(1);
    static Semaphore director_dedins=new Semaphore(1);

    private class director extends Thread {

        @Override
        public void run() {
            try {
                for (int i = 0; i < N_RONDES; i++) {
                    Thread.sleep(new Random().nextInt(50) + 50);
                    // Començar ronda
                    System.out.println("\tEl director comença la ronda");
                    // Comprovar capacitat
                    sala.acquire();
                    // Cas en el que no hi ha nnigú a la sala
                    if (capacitat == 0) {
                        System.out.println("\tEl Director veu que no hi ha ningú a la sala d'estudis");
                    } else {
                        // Cas en el que hi ha una quantitat acceptable d'alumnes a la sala
                        if (capacitat <= CAPACITAT_SALA) {
                            System.out.println("\tEl Director està esperant per entrar. No molesta als que estudien");
                        }
                        // Espera per poder entrar
                        sala.release();
                        director.acquire();
                        sala.acquire();
                        // Cas en el que s'ha buidat la sala
                        if (capacitat == 0) {
                            System.out.println("\tEl Director veu que no hi ha ningú a la sala d'estudis");
                        } // Cas en el que hi ha una FESTA
                        else {
                            System.out.println("\tEl Director està dins la sala d'estudi: S'HA ACABAT LA FESTA!");
                            // Fa que nigú pugui entrar fins que no se buidi
                            director_dedins.acquire();
                            while (capacitat != 0) {
                                sala.release();
                                Thread.sleep(50);
                                sala.acquire();
                            }
                            director_dedins.release();
                        }
                    }
                    sala.release();
                    System.out.println("\tEl Director acaba la ronda " + (i + 1) + " de " + N_RONDES);

                }

            } catch (InterruptedException ex) {
            }
        }

    }

    private class estudiant extends Thread {

        String nom;

        public estudiant(String nom) {
            this.nom = nom;

        }

        @Override
        public void run() {
            try {
                sleep(new Random().nextInt(50) + 20);
                // Si el professor està buidant la sala perquè hi ha hagut FESTA, espera't
                director_dedins.acquire();
                director_dedins.release();
                sala.acquire();
                // Entra a la sala
                if (capacitat == 0) {
                    director.acquire();
                }
                capacitat++;
                System.out.println(nom + " entra a la sala d'estudi, nombre d'estudiants: " + capacitat);
                // Entra i hi ha festa
                if (capacitat > CAPACITAT_SALA) {
                    System.out.println(nom + ": FESTA!!!!!");
                    // Cas en el que monta la festa i el director estava esperant
                    if (director.hasQueuedThreads()) {
                        System.out.println(nom + " ALERTA que vé el director!!!!!!!!!");
                    }
                    // Dona permís perquè pugui entrar el director
                    director.release();

                }
                sala.release();
                // Simular estudi
                Thread.sleep(new Random().nextInt(100) + 200);
                // Sortir de la sala
                sala.acquire();
                capacitat--;
                System.out.println(nom + " surt de la sala d'estudi, nombre estudiants: " + capacitat);
                if (capacitat == 0) {
                    if (director.hasQueuedThreads()) {
                        System.out.println(nom + " ADÉU Senyor Director, pot entrar si vol, no hi ha nigú");
                    }
                    director.release();
                }
                sala.release();

            } catch (InterruptedException ex) {
            }
        }

    }

    public void main() throws InterruptedException {
        Thread threads[] = new Thread[N_ESTUDIANTS + 1];
        for (int i = 0; i < N_ESTUDIANTS; i++) {
            threads[i] = new estudiant(NOMS[i]);
            threads[i].start();
        }
        threads[N_ESTUDIANTS] = new director();
        threads[N_ESTUDIANTS].start();
        for (int i = 0; i < N_ESTUDIANTS; i++) {
            threads[i].join();
        }
        threads[N_ESTUDIANTS].join();
    }

    public static void main(String[] args) throws InterruptedException {
        new Practica1().main();

    }
}
