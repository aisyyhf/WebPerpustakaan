/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author HP
 */
import java.util.List;

public class Pembaca extends Pengguna {
    private List<Buku> wishlist;
    private List<Peminjaman> peminjaman;

    @Override
    public void aksesDashboard() {
        System.out.println("Akses dashboard pembaca");
    }

    public void tambahWishlist(Buku buku) {
        wishlist.add(buku);
    }

    public void pinjamBuku(Buku buku) {
        // implementasi peminjaman buku
    }

    // method pembaca lainnya...
}

