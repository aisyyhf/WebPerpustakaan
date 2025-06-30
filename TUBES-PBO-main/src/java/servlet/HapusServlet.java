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

@WebServlet("/HapusServlet")
public class HapusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bookID = request.getParameter("bookID");

        try (Connection conn = JDBC.getConnection()) {
            String sql = "DELETE FROM books WHERE bookID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, bookID);

            stmt.executeUpdate();
            response.sendRedirect("books_admin.jsp"); // Redirect back to the admin page

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("books_admin.jsp?error=Terjadi kesalahan dalam penghapusan buku.");
        }
    }
}
