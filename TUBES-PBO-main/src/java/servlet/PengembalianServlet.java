package servlet;

import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import classes.JDBC;

@WebServlet("/PengembalianServlet")
public class PengembalianServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idPeminjamanStr = request.getParameter("idPeminjaman");
        int idPeminjaman = Integer.parseInt(idPeminjamanStr);
        int dendaPerHari = 1000;
        int totalDenda = 0;

        try (Connection conn = JDBC.getConnection()) {
            // Ambil tanggal kembali dari database
            String selectSql = "SELECT tanggalKembali FROM peminjaman WHERE idPeminjaman = ?";
            PreparedStatement selectStmt = conn.prepareStatement(selectSql);
            selectStmt.setInt(1, idPeminjaman);
            ResultSet rs = selectStmt.executeQuery();

            if (rs.next()) {
                Date tglKembali = rs.getDate("tanggalKembali");
                if (tglKembali != null) {
                    LocalDate kembali = tglKembali.toLocalDate();
                    LocalDate hariIni = LocalDate.now();

                    if (hariIni.isAfter(kembali)) {
                        long selisihHari = ChronoUnit.DAYS.between(kembali, hariIni);
                        totalDenda = (int) selisihHari * dendaPerHari;
                    }
                }
            }
            rs.close();
            selectStmt.close();

            // Update status jadi dikembalikan + simpan denda
            String updateSql = "UPDATE peminjaman SET status = 'dikembalikan', denda = ? WHERE idPeminjaman = ?";
            PreparedStatement updateStmt = conn.prepareStatement(updateSql);
            updateStmt.setInt(1, totalDenda);
            updateStmt.setInt(2, idPeminjaman);
            updateStmt.executeUpdate();
            updateStmt.close();

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Gagal mengembalikan buku.");
            return;
        }

        response.sendRedirect("riwayat_peminjaman.jsp");
    }
}