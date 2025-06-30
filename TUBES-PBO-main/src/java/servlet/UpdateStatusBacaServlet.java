/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;

import classes.JDBC;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/UpdateStatusBacaServlet")
public class UpdateStatusBacaServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("pengguna") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String userID = request.getParameter("userID");
        String bookID = request.getParameter("bookID");

        if (userID == null || bookID == null || userID.isEmpty() || bookID.isEmpty()) {
            response.sendRedirect("wishlist.jsp?error=Data tidak lengkap");
            return;
        }

        try (Connection conn = JDBC.getConnection()) {
            String sql = "UPDATE wishlist SET statusBaca = 'sudah dibaca' WHERE userID = ? AND bookID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, userID);
            stmt.setString(2, bookID);

            int rowsUpdated = stmt.executeUpdate();
            stmt.close();

            if (rowsUpdated > 0) {
                // Update sukses, redirect kembali ke halaman baca atau wishlist
                response.sendRedirect("baca.jsp?bookID=" + bookID + "&success=Status baca diperbarui");
            } else {
                // Gagal update, mungkin data tidak ditemukan
                response.sendRedirect("baca.jsp?bookID=" + bookID + "&error=Gagal memperbarui status baca");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("baca.jsp?bookID=" + bookID + "&error=Kesalahan server saat memperbarui status");
        }
    }
}

