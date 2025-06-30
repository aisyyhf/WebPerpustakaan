/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author HP
 */
public abstract class Pengguna {
    protected String userID;
    protected String nama;
    protected String email;
    protected String password;
    protected String role;
    protected String fotoProfil;
    private String phoneNumber;
    
    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getNama() {
        return nama;
    }

    public void setNama(String nama) {
        this.nama = nama;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    // Constructor, getter dan setter
    public void setRole(String role) {    
        this.role = role;
    }

    // Abstract method, yang diimplementasi di subclass
    public abstract void aksesDashboard();

    public String getFotoProfil() {
        return fotoProfil != null ? fotoProfil : "default-profile.png";
    }

    public void setFotoProfil(String fotoProfil) {
        this.fotoProfil = fotoProfil;
    }    

    public void setBio(String newBio) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
     // Getter and Setter for phoneNumber
    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public void setAddress(String newAddress) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}

