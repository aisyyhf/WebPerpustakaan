package servlet;

import classes.JDBC;
import model.Pembaca; // Import Pembaca model

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String namaDepan = request.getParameter("namaDepan");
        String namaBelakang = request.getParameter("namaBelakang");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String noTelp = request.getParameter("noTelp");

        // Membuat nama lengkap dari nama depan dan nama belakang
        String namaLengkap = namaDepan + " " + namaBelakang;

        // Generate userID secara sederhana
        String userID = "P" + System.currentTimeMillis(); // Contoh ID dengan timestamp

        // Membuat objek Pembaca
        Pembaca pembaca = new Pembaca();
        pembaca.setUserID(userID);
        pembaca.setNama(namaLengkap);
        pembaca.setEmail(email);
        pembaca.setPassword(password);
        pembaca.setPhoneNumber(noTelp);
        pembaca.setRole("pembaca"); // Role sudah tetap 'pembaca'

        // Menyimpan pengguna ke database
        try (Connection conn = JDBC.getConnection()) {
            String sql = "INSERT INTO pengguna (userID, nama, email, password, role, phone_number) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, pembaca.getUserID());
            stmt.setString(2, pembaca.getNama());
            stmt.setString(3, pembaca.getEmail());
            stmt.setString(4, pembaca.getPassword());
            stmt.setString(5, pembaca.getRole());
            stmt.setString(6, pembaca.getPhoneNumber());

            // Eksekusi insert
            stmt.executeUpdate();

            // Redirect ke halaman login setelah berhasil mendaftar
            response.sendRedirect("login.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            // Jika ada kesalahan, tampilkan error di register.jsp
            response.sendRedirect("register.jsp?error=Email sudah terdaftar atau kesalahan lainnya.");
        }
    }
}
