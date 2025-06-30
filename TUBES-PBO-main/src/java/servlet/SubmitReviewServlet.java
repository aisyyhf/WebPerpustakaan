/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package servlet;

import classes.JDBC;
import model.Pengguna;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;

@WebServlet("/SubmitReviewServlet")
public class SubmitReviewServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("pengguna") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Pengguna pengguna = (Pengguna) session.getAttribute("pengguna");
        String userID = pengguna.getUserID();

        String bookID = request.getParameter("bookID");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        int rating = 0;
        try {
            rating = Integer.parseInt(ratingStr);
        } catch (NumberFormatException e) {
            rating = 0; // default jika parsing gagal
        }

        if (bookID == null || rating < 1 || rating > 5 || comment == null || comment.trim().isEmpty()) {
            response.sendRedirect("review.jsp?bookID=" + bookID + "&error=Data review tidak valid");
            return;
        }

        try (Connection conn = JDBC.getConnection()) {
            String sql = "INSERT INTO review (userID, bookID, rating, komentar, tanggalReview) VALUES (?, ?, ?, ?, CURRENT_DATE())";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, userID);
            stmt.setString(2, bookID);
            stmt.setInt(3, rating);
            stmt.setString(4, comment.trim());
            stmt.executeUpdate();

            // Setelah insert, redirect kembali ke halaman review buku tersebut
            response.sendRedirect("review.jsp?bookID=" + bookID + "&success=Review berhasil dikirim");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("review.jsp?bookID=" + bookID + "&error=Terjadi kesalahan saat menyimpan review");
        }
    }
}
