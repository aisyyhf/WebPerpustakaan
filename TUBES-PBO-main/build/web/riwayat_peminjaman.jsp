<%-- 
    Document   : riwayat_peminjaman
    Created on : 12 Jun 2025, 10.57.41
    Author     : HP
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.time.*, java.time.temporal.ChronoUnit, model.Pengguna, classes.JDBC" %>

<%
    if (session == null || session.getAttribute("pengguna") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Pengguna pengguna = (Pengguna) session.getAttribute("pengguna");
    if (!"pembaca".equalsIgnoreCase(pengguna.getRole())) {
        response.sendRedirect("dashboard_admin.jsp");
        return;
    }

    String userID = pengguna.getUserID();

    Connection conn = JDBC.getConnection();
    String sql = "SELECT p.*, b.judul FROM peminjaman p JOIN books b ON p.bookID = b.bookID WHERE p.userID = ? ORDER BY p.tanggalPinjam DESC";
    PreparedStatement stmt = conn.prepareStatement(sql);
    stmt.setString(1, userID);
    ResultSet rs = stmt.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Riwayat Peminjaman - MeinLib</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <style>
        body { padding: 30px; background: #f2f2f2; font-family: Arial, sans-serif; }
        .container { background: white; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px #ccc; }
        .late { color: red; font-weight: bold; }
    </style>
</head>
<body>
<div class="container">
    <h2>Riwayat Peminjaman Buku</h2>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Judul Buku</th>
                <th>Tanggal Pinjam</th>
                <th>Tanggal Kembali</th>
                <th>Status</th>
                <th>Denda</th>
                <th>Aksi</th>
            </tr>
        </thead>
        <tbody>
        <%
            while (rs.next()) {
                int idPeminjaman = rs.getInt("idPeminjaman");
                String judul = rs.getString("judul");
                Date tglPinjam = rs.getDate("tanggalPinjam");
                Date tglKembali = rs.getDate("tanggalKembali");
                String status = rs.getString("status");
                int denda = rs.getInt("denda");

                boolean isLate = false;
                String kembaliText = "-";
                String pinjamText = "-";

                if (tglPinjam != null) {
                    pinjamText = tglPinjam.toString();
                }

                if (tglKembali != null) {
                    LocalDate kembaliDate = tglKembali.toLocalDate();
                    LocalDate hariIni = LocalDate.now();
                    kembaliText = kembaliDate.toString();
                    isLate = "dipinjam".equalsIgnoreCase(status) && hariIni.isAfter(kembaliDate);
                }
        %>
            <tr>
                <td><%= judul %></td>
                <td><%= pinjamText %></td>
                <td>
                    <%= kembaliText %>
                    <% if (isLate) { %>
                        <span class="late">(Terlambat)</span>
                    <% } %>
                </td>
                <td><%= status %></td>
                <td>
                    <% if (denda > 0) { %>
                        <span style="color:red;">Rp <%= denda %></span>
                    <% } else { %>
                        <em>-</em>
                    <% } %>
                </td>
                <td>
                    <% if ("dipinjam".equalsIgnoreCase(status)) { %>
                        <form action="PengembalianServlet" method="post">
                            <input type="hidden" name="idPeminjaman" value="<%= idPeminjaman %>"/>
                            <button class="btn btn-warning btn-sm" type="submit">Kembalikan</button>
                        </form>
                    <% } else { %>
                        <em>-</em>
                    <% } %>
                </td>
            </tr>
        <%
            }
            rs.close();
            stmt.close();
            conn.close();
        %>
        </tbody>
    </table>
    <a href="books.jsp" class="btn btn-secondary">Kembali ke Daftar Buku</a>
</div>
</body>
</html>
