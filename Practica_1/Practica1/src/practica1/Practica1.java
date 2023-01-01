/*
Autors : 
        Marc Melià Flexas
        Xavier Vives Marcus

Vídeo:
        https://www.youtube.com/watch?v=wPlCwHHk-AA&ab_channel=XavierVives
*/

package practica1;

import java.util.Random;
import java.util.concurrent.Semaphore;

public class Practica1 {

    final String NOMS[] = {"Joaquim", "Goku", "Alicia", "Victòria", "Xisca", "Biel", "Xavier", "Elena", "Magdalena", "Marc", "Miquel", "Toni",
        "Lluís", "Sílvia", "Martí", "Josep", "Damià", "Ester", "Ventura", "Bàrbara", "Aina", "Julià", "Albert", "Eva", "Maria", "Àngels",
        "Tomeu", "Gerard", "Mateu", "Jordi", "Joan", "Carolina", "Bel", "Amadeu", "Emili", "Daniel", "Carles", "Felip", "Laura", "Andreu", "Joel",
        "Pau", "Roderic", "Ernest", "Vicenç", "Abril", "Venus", "Zeus", "Mart", "Morfeu"};

    final int N_ESTUDIANTS = 15;
    final int N_RONDES = 3;
    final int CAPACITAT_SALA = 5;
    
    static int capacitat = 0;
    
    static Semaphore sala = new Semaphore(1);
    static Semaphore director = new Semaphore(1);
    static Semaphore director_dedins = new Semaphore(1);

    static enum Estat {
        NO_HI_ES, ESPERANT, DEDINS
    };

    Estat estat_director = Estat.NO_HI_ES;

    public static final String ANSI_COLOR_RED = "\033[1;31m";
    public static final String ANSI_COLOR_CYAN = "\033[1;36m";
    public static final String ANSI_COLOR_GREEN = "\033[1;32m";
    public static final String ANSI_COLOR_YELLOW = "\033[1;33m";
    public static final String ANSI_COLOR_BLUE = "\033[1;34m";
    public static final String ANSI_COLOR_PURPLE = "\033[1;35m";
    public static final String ANSI_COLOR_WHITE = "\033[1;37m";

    public static final String ANSI_RESET = "\u001B[0m";
    public static final String RANIBOW_FESTA = ANSI_COLOR_RED + "F" + ANSI_COLOR_GREEN + "E" + ANSI_COLOR_YELLOW + "S" + ANSI_COLOR_BLUE + "T" + ANSI_COLOR_PURPLE + "A" + ANSI_COLOR_CYAN + "!" + ANSI_COLOR_WHITE + "!" + ANSI_COLOR_RED + "!" + ANSI_COLOR_GREEN + "!" + ANSI_COLOR_YELLOW + "!" + ANSI_RESET;

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
                    estat_director = Estat.ESPERANT;
                    // Cas en el que no hi ha nnigú a la sala
                    if (capacitat == 0) {
                        estat_director = Estat.DEDINS;
                        System.out.println("\tEl Director veu que no hi ha ningú a la sala d'estudis");
                    } else {
                        // Cas en el que hi ha una quantitat acceptable d'alumnes a la sala
                        if (capacitat <= CAPACITAT_SALA) {
                            estat_director=Estat.ESPERANT;
                            System.out.println("\tEl Director està esperant per entrar. No molesta als que estudien");
                        }
                        // Espera per poder entrar
                        sala.release();
                        director.acquire();
                        sala.acquire();
                        // Cas en el que s'ha buidat la sala
                        if (capacitat == 0) {
                            estat_director = Estat.DEDINS;
                            System.out.println("\tEl Director veu que no hi ha ningú a la sala d'estudis");
                        } // Cas en el que hi ha una FESTA
                        else {
                            estat_director = Estat.DEDINS;
                            System.out.println("\tEl Director està dins la sala d'estudi: S'HA ACABAT LA FESTA!");
                            // Fa que nigú pugui entrar fins que no se buidi
                            director_dedins.acquire();
                            sala.release();
                            // Espera fins que se buidi
                            director.acquire();
                            System.out.println("\tEl Director veu que no hi ha ningú a la sala d'estudis");
                            director.release();
                            sala.acquire();
                            director_dedins.release();
                        }
                    }
                    estat_director=Estat.NO_HI_ES;
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
                sleep(new Random().nextInt(50) + 100);
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
                if (capacitat >= CAPACITAT_SALA) {
                    System.out.println(nom + ": " + RANIBOW_FESTA);
                }
                // Cas en el que monta la festa
                if (capacitat == CAPACITAT_SALA) {
                    // Cas en el que monta la festa i el director estava esperant
                    if (estat_director.equals(Estat.ESPERANT)) {
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
                    // Si estat_director == DEDINS o estat_director == ESPERANT
                    if (estat_director.equals(Estat.DEDINS)) {
                        System.out.println(nom + " ADÉU Senyor Director, pot entrar si vol, no hi ha nigú");
                    }else if(estat_director.equals(Estat.ESPERANT)){
                        System.out.println(nom+"ADÉU Senyor Director, pot entrar si vol, no hi ha nigú");
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
