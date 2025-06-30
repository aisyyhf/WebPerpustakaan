/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author HP
 */
public class Admin extends Pengguna {

    @Override
    public void aksesDashboard() {
        System.out.println("Akses dashboard admin");
    }

    public void tambahBuku(Buku buku) {
        // implementasi tambah buku
    }

    // method admin lainnya...
}

