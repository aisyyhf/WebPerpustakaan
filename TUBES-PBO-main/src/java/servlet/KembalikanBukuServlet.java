/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;

import classes.JDBC;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/KembalikanBukuServlet")
public class KembalikanBukuServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String idPeminjamanStr = request.getParameter("idPeminjaman");
        if (idPeminjamanStr == null) {
            response.sendRedirect("dashboard_user.jsp?error=ID peminjaman tidak valid.");
            return;
        }

        int idPeminjaman = Integer.parseInt(idPeminjamanStr);

        try (Connection conn = JDBC.getConnection()) {
            conn.setAutoCommit(false);

            // 1. Update status peminjaman jadi dikembalikan
            String sqlUpdatePeminjaman = "UPDATE peminjaman SET status = 'dikembalikan' WHERE idPeminjaman = ?";
            try (PreparedStatement psPeminjaman = conn.prepareStatement(sqlUpdatePeminjaman)) {
                psPeminjaman.setInt(1, idPeminjaman);
                psPeminjaman.executeUpdate();
            }

            // 2. Cari bookID dari peminjaman tsb
            String sqlGetBookID = "SELECT bookID FROM peminjaman WHERE idPeminjaman = ?";
            String bookID = null;
            try (PreparedStatement psGetBook = conn.prepareStatement(sqlGetBookID)) {
                psGetBook.setInt(1, idPeminjaman);
                try (ResultSet rs = psGetBook.executeQuery()) {
                    if (rs.next()) {
                        bookID = rs.getString("bookID");
                    }
                }
            }

            // 3. Update status buku jadi tersedia
            if (bookID != null) {
                String sqlUpdateBook = "UPDATE books SET statusKetersediaan = 'tersedia' WHERE bookID = ?";
                try (PreparedStatement psBook = conn.prepareStatement(sqlUpdateBook)) {
                    psBook.setString(1, bookID);
                    psBook.executeUpdate();
                }
            }

            conn.commit();
            conn.setAutoCommit(true);

            response.sendRedirect("dashboard_user.jsp?message=Buku berhasil dikembalikan.");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("dashboard_user.jsp?error=Gagal mengupdate status pengembalian buku.");
        }
    }
}
