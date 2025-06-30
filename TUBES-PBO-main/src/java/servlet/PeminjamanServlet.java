package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import classes.JDBC;

@WebServlet("/PeminjamanServlet")
public class PeminjamanServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userID = request.getParameter("userID");
        String bookID = request.getParameter("bookID");
        String tanggalPinjamStr = request.getParameter("tanggalPinjam");
        int lamaPinjam = Integer.parseInt(request.getParameter("lamaPinjam"));

        LocalDate tanggalPinjam = LocalDate.parse(tanggalPinjamStr);
        LocalDate tanggalKembali = tanggalPinjam.plusDays(lamaPinjam);

        try (Connection conn = JDBC.getConnection()) {
            String sql = "INSERT INTO peminjaman (userID, bookID, tanggalPinjam, tanggalKembali, status) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, userID);
            stmt.setString(2, bookID);
            stmt.setDate(3, java.sql.Date.valueOf(tanggalPinjam));
            stmt.setDate(4, java.sql.Date.valueOf(tanggalKembali));
            stmt.setString(5, "menunggu");
            stmt.executeUpdate();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Gagal menyimpan pengajuan.");
            return;
        }

        response.sendRedirect("menunggu_persetujuan.jsp");
    }
}