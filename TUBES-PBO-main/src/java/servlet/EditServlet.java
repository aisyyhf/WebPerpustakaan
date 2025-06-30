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

@WebServlet("/EditServlet")
public class EditServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bookID = request.getParameter("bookID");
        String judul = request.getParameter("judul");
        String penulis = request.getParameter("penulis");
        String penerbit = request.getParameter("penerbit");
        String tahun = request.getParameter("tahun");
        String jenis = request.getParameter("jenis");
        String status = request.getParameter("status");

        try (Connection conn = JDBC.getConnection()) {
            String sql = "UPDATE books SET judul = ?, penulis = ?, penerbit = ?, tahunTerbit = ?, jenis = ?, statusKetersediaan = ? WHERE bookID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, judul);
            stmt.setString(2, penulis);
            stmt.setString(3, penerbit);
            stmt.setString(4, tahun);
            stmt.setString(5, jenis);
            stmt.setString(6, status);
            stmt.setString(7, bookID);

            stmt.executeUpdate();
            response.sendRedirect("books_admin.jsp"); // Redirect back to the admin page

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("books_admin.jsp?error=Terjadi kesalahan dalam pembaruan data buku.");
        }
    }
}
