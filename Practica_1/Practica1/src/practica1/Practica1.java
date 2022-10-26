/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package practica1;

import com.sun.corba.se.impl.orbutil.concurrent.Mutex;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author xvive
 */
public class Practica1 {

    final String NOMS[] = {"Joaquim", "Àlex", "Alicia", "Victòria", "Xisca", "Biel", "Xavier", "Elena", "Magdalena", "Marc", "Miquel", "Toni",
        "Lluís", "Sílvia", "Martí", "Josep", "Damià", "Ester", "Ventura", "Bàrbara", "Aina", "Julià", "Albert", "Eva", "Maria", "Àngels",
        "Tomeu", "Gerard", "Mateu", "Jordi", "Joan", "Carolina", "Bel", "Amadeu", "Emili", "Daniel", "Carles", "Felip", "Laura", "Andreu", "Joel",
        "Pau", "Roderic", "Ernest", "Vicenç", "Abril", "Venus", "Zeus", "Mart", "Morfeu"};

    final int N_ESTUDIANTS = 15;
    final int N_RONDES = 3;
    final int CAPACITAT_SALA=7;
    int capacitat = 0;
    Mutex sala = new Mutex();
    Mutex director = new Mutex();

    private class director extends Thread {

        @Override
        public void run() {
            System.out.println("\tEl director comencça la ronda");
            for (int i = 0; i < N_RONDES; i++) {
                try {
                    sala.acquire();
                    if (capacitat == 0) {
                        System.out.println("\tEl Director veu que no hi ha ningú a la sala d'estudis");
                        System.out.println("\tEl Director acaba la ronda" + (i + 1) + "de " + N_RONDES);
                    }else{
                        System.out.println("\tEl Director està esperant per entrar. No molesta als que estudien");
                        sala.release();
                        director.acquire();
                        sala.acquire();
                        if(capacitat>CAPACITAT_SALA){
                            System.out.println("\tEl Director està dins la sala d'estudi: S'HA ACABAT LA FESTA!");
                            while(capacitat!=0){
                                sala.release();
                                sleep(25);
                                sala.acquire();
                            }
                        }else{
                            System.out.println("\tEl Director veu que no hi ha ningú a la sala d'estudis");
                        }
                        System.out.println("\tEl Director acaba la ronda" + (i + 1) + "de " + N_RONDES);
                        director.release();
                        sala.release();
                    }
                } catch (InterruptedException ex) {
                }

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
            // Entren a la sala d'estudi
            try {
                sala.acquire();
                capacitat++;
                System.out.println(nom + " entra a la sala d'estudi, nombre d'estudiants: " + capacitat);
                sala.release();
            } catch (InterruptedException ex) {
            }

        }
    }

    public void main() throws InterruptedException {
        System.out.println(NOMS.length);

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
