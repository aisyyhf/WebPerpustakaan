package servlet;

import classes.JDBC;
import model.Pengguna;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/WishlistServlet")
public class WishlistServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Ambil session dan cek login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("pengguna") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Ambil objek pengguna dari session
        Pengguna pengguna = (Pengguna) session.getAttribute("pengguna");
        String userID = pengguna.getUserID();

        // Ambil parameter bookID dari form
        String bookID = request.getParameter("bookID");
        String statusBaca = "belum dibaca";  // default status

        try (Connection conn = JDBC.getConnection()) {
            // Cek apakah buku sudah ada di wishlist
            String checkSql = "SELECT * FROM wishlist WHERE userID = ? AND bookID = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, userID);
            checkStmt.setString(2, bookID);
            ResultSet rs = checkStmt.executeQuery();

            if (!rs.next()) { // Jika belum ada di wishlist, insert
                String insertSql = "INSERT INTO wishlist (userID, bookID, statusBaca) VALUES (?, ?, ?)";
                PreparedStatement insertStmt = conn.prepareStatement(insertSql);
                insertStmt.setString(1, userID);
                insertStmt.setString(2, bookID);
                insertStmt.setString(3, statusBaca);
                insertStmt.executeUpdate();
                insertStmt.close();
            }
            rs.close();
            checkStmt.close();

            // Setelah tambah wishlist redirect ke wishlist.jsp
            response.sendRedirect("wishlist.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("books.jsp?error=Gagal menambah ke wishlist");
        }
    }
}
