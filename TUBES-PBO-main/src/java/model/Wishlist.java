/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author HP
 */
import java.util.Date;

public class Wishlist {
    private int idWishlist;
    private String userID;
    private String bookID;
    private Date tanggalDitambahkan;
    private String statusBaca; // belum dibaca, sedang dibaca, sudah dibaca

    // getter dan setter

    public int getIdWishlist() {
        return idWishlist;
    }

    public void setIdWishlist(int idWishlist) {
        this.idWishlist = idWishlist;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getBookID() {
        return bookID;
    }

    public void setBookID(String bookID) {
        this.bookID = bookID;
    }

    public Date getTanggalDitambahkan() {
        return tanggalDitambahkan;
    }

    public void setTanggalDitambahkan(Date tanggalDitambahkan) {
        this.tanggalDitambahkan = tanggalDitambahkan;
    }

    public String getStatusBaca() {
        return statusBaca;
    }

    public void setStatusBaca(String statusBaca) {
        this.statusBaca = statusBaca;
    }
}

