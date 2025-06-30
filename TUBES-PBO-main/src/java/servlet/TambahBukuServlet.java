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

@WebServlet("/TambahBukuServlet")
public class TambahBukuServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bookID = request.getParameter("bookID");
        String judul = request.getParameter("judul");
        String penulis = request.getParameter("penulis");
        String penerbit = request.getParameter("penerbit");
        String tahun = request.getParameter("tahun");
        String isbn = request.getParameter("isbn");
        String jenis = request.getParameter("jenis");
        String status = "tersedia";  // default status tersedia saat baru ditambah

        try (Connection conn = JDBC.getConnection()) {
            String sql = "INSERT INTO books (bookID, judul, penulis, penerbit, tahunTerbit, isbn, jenis, statusKetersediaan) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, bookID);
            stmt.setString(2, judul);
            stmt.setString(3, penulis);
            stmt.setString(4, penerbit);
            stmt.setInt(5, Integer.parseInt(tahun));
            stmt.setString(6, isbn);
            stmt.setString(7, jenis);
            stmt.setString(8, status);

            stmt.executeUpdate();
            stmt.close();

            // Redirect ke halaman books_admin.jsp setelah berhasil tambah buku
            response.sendRedirect("books_admin.jsp?success=Tambah buku berhasil");

        } catch (SQLException e) {
            e.printStackTrace();
            // Jika error, kembali ke form dengan pesan error
            response.sendRedirect("tambahbuku.jsp?error=Gagal menambah buku, pastikan data sudah benar");
        }
    }
}
