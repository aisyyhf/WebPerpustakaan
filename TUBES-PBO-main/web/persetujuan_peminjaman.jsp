<%-- 
    Document   : persetujuan_peminjaman
    Created on : 12 Jun 2025, 10.47.00
    Author     : HP
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, classes.JDBC, model.Pengguna" %>

<%
    if (session == null || session.getAttribute("pengguna") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    Pengguna pengguna = (Pengguna) session.getAttribute("pengguna");
    if (!"admin".equalsIgnoreCase(pengguna.getRole())) {
        response.sendRedirect("dashboard_user.jsp");
        return;
    }

    Connection conn = JDBC.getConnection();
    String sql = "SELECT p.idPeminjaman, p.userID, b.judul FROM peminjaman p JOIN books b ON p.bookID = b.bookID WHERE p.status = 'menunggu'";
    PreparedStatement stmt = conn.prepareStatement(sql);
    ResultSet rs = stmt.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Persetujuan Peminjaman</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <style>
        body { padding: 30px; background: #f9f9f9; font-family: Arial, sans-serif; }
        .container { background: white; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px #ccc; }
    </style>
</head>
<body>
<div class="container">
    <h2>Permintaan Peminjaman Menunggu Persetujuan</h2>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>ID</th>
                <th>User</th>
                <th>Judul Buku</th>
                <th>Aksi</th>
            </tr>
        </thead>
        <tbody>
        <%
            while (rs.next()) {
                int idPeminjaman = rs.getInt("idPeminjaman");
                String userID = rs.getString("userID");
                String judul = rs.getString("judul");
        %>
            <tr>
                <td><%= idPeminjaman %></td>
                <td><%= userID %></td>
                <td><%= judul %></td>
                <td>
                    <form action="PersetujuanPeminjamanServlet" method="post" style="display:inline;">
                        <input type="hidden" name="idPeminjaman" value="<%= idPeminjaman %>"/>
                        <input type="hidden" name="aksi" value="terima"/>
                        <button class="btn btn-success btn-sm" type="submit">Setujui</button>
                    </form>
                    <form action="PersetujuanPeminjamanServlet" method="post" style="display:inline;">
                        <input type="hidden" name="idPeminjaman" value="<%= idPeminjaman %>"/>
                        <input type="hidden" name="aksi" value="tolak"/>
                        <button class="btn btn-danger btn-sm" type="submit">Tolak</button>
                    </form>
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
    <a href="dashboard_admin.jsp" class="btn btn-secondary">Kembali ke Dashboard</a>
</div>
</body>
</html>
