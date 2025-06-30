package servlet;

import model.Pengguna;
import classes.JDBC;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/ProfileServlet"})
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("pengguna") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Pengguna pengguna = (Pengguna) session.getAttribute("pengguna");

        // Ambil nama dan nomor telepon yang baru dari form
        String newName = request.getParameter("nama");
        String newPhoneNumber = request.getParameter("phone_number");

        if (newName == null || newName.trim().isEmpty()) {
            request.setAttribute("error", "Nama tidak boleh kosong");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        try (Connection conn = JDBC.getConnection()) {
            // Update data pengguna di database
            String sql = "UPDATE pengguna SET nama = ?, phone_number = ? WHERE userID = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, newName);
                ps.setString(2, newPhoneNumber);
                ps.setString(3, pengguna.getUserID());
                ps.executeUpdate();
                
                // Update session dengan data terbaru
                pengguna.setNama(newName);
                pengguna.setPhoneNumber(newPhoneNumber);
                session.setAttribute("pengguna", pengguna);
                
                // Pesan berhasil
                request.setAttribute("message", "Profil berhasil diperbarui");
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Gagal memperbarui profil: " + e.getMessage());
        }
        
        // Kembali ke halaman profile.jsp dengan pesan
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
}