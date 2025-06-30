package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import classes.JDBC;

@WebServlet("/PersetujuanPeminjamanServlet")
public class PersetujuanPeminjamanServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idPeminjaman = request.getParameter("idPeminjaman");
        String aksi = request.getParameter("aksi");

        try (Connection conn = JDBC.getConnection()) {
            if ("terima".equalsIgnoreCase(aksi)) {
                String sql = "UPDATE peminjaman SET status = 'dipinjam' WHERE idPeminjaman = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, Integer.parseInt(idPeminjaman));
                stmt.executeUpdate();
                stmt.close();

            } else if ("tolak".equalsIgnoreCase(aksi)) {
                String sql = "UPDATE peminjaman SET status = 'ditolak' WHERE idPeminjaman = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, Integer.parseInt(idPeminjaman));
                stmt.executeUpdate();
                stmt.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Gagal memproses persetujuan.");
            return;
        }

        response.sendRedirect("persetujuan_peminjaman.jsp");
    }
}