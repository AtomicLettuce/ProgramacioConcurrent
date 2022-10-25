/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package practica1;

/**
 *
 * @author xvive
 */
public class Practica1 {
    static final int N_ESTUDIANTS = 15;

    static private class director extends Thread {

        @Override
        public void run() {
            //TODO

        }
    }
    
    
    static private class estudiant extends Thread {

        @Override
        public void run() {
            //TODO

        }
    }
    
    
    
    public static void main(String[] args) throws InterruptedException {
        
        Thread threads[] = new Thread[N_ESTUDIANTS+1];
        for (int i = 0; i < N_ESTUDIANTS; i++) {
            threads[i] = new estudiant();
            threads[i].start();
        }
        threads[N_ESTUDIANTS]=new director();
        threads[N_ESTUDIANTS].start();
        for (int i = 0; i < N_ESTUDIANTS; i++) {
            threads[i].join();
        }
        threads[N_ESTUDIANTS].join();
    }
    
}
