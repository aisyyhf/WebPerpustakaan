<%-- 
    Document   : peminjaman_user
    Created on : 29 May 2025, 12.10.30
    Author     : HP
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, classes.JDBC" %>
<%@ page import="model.Pengguna" %>

<%
    // Cek session dan role
    if (session == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    Pengguna pengguna = (Pengguna) session.getAttribute("pengguna");
    if (pengguna == null || !"pembaca".equalsIgnoreCase(pengguna.getRole())) {
        response.sendRedirect("dashboard_admin.jsp");
        return;
    }

    String userID = pengguna.getUserID();
    String bookID = request.getParameter("bookID");
    if (bookID == null || bookID.isEmpty()) {
        response.sendRedirect("books.jsp");
        return;
    }

    Connection conn = JDBC.getConnection();

    // Cek apakah user sudah ajukan buku ini dan status belum selesai
    String cekSql = "SELECT COUNT(*) FROM peminjaman WHERE userID = ? AND bookID = ? AND status IN ('menunggu', 'dipinjam')";
    PreparedStatement cekStmt = conn.prepareStatement(cekSql);
    cekStmt.setString(1, userID);
    cekStmt.setString(2, bookID);
    ResultSet cekRs = cekStmt.executeQuery();

    boolean sudahAjukan = false;
    if (cekRs.next()) {
        sudahAjukan = cekRs.getInt(1) > 0;
    }

    cekRs.close();
    cekStmt.close();

    // Ambil detail buku
    String sql = "SELECT * FROM books WHERE bookID = ?";
    PreparedStatement stmt = conn.prepareStatement(sql);
    stmt.setString(1, bookID);
    ResultSet rs = stmt.executeQuery();

    if (!rs.next()) {
        rs.close();
        stmt.close();
        conn.close();
        response.sendRedirect("books.jsp");
        return;
    }

    String judul = rs.getString("judul");
    String penulis = rs.getString("penulis");

    rs.close();
    stmt.close();
    conn.close();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Ajukan Peminjaman - MeinLib</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { font-family: Arial, sans-serif; padding: 30px; background: #f9f9f9; }
        .container { max-width: 600px; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px #ccc; }
    </style>
</head>
<body>
<div class="container">
    <h2>Ajukan Peminjaman Buku</h2>
    <p><strong>Judul:</strong> <%= judul %></p>
    <p><strong>Penulis:</strong> <%= penulis %></p>

    <% if (sudahAjukan) { %>
        <div class="alert alert-warning">
            Kamu sudah mengajukan atau sedang meminjam buku ini. Mohon tunggu proses selesai sebelum mengajukan lagi.
        </div>
        <a href="books.jsp" class="btn btn-secondary">Kembali ke Daftar Buku</a>
    <% } else { %>
        <form action="PeminjamanServlet" method="post">
            <input type="hidden" name="userID" value="<%= userID %>">
            <input type="hidden" name="bookID" value="<%= bookID %>">

            <div class="mb-3">
                <label for="tanggalPinjam" class="form-label">Tanggal Ajukan</label>
                <input type="date" id="tanggalPinjam" name="tanggalPinjam" class="form-control" required
                       value="<%= java.time.LocalDate.now() %>">
            </div>

            <div class="mb-3">
                <label for="lamaPinjam" class="form-label">Durasi Peminjaman</label>
                <select id="lamaPinjam" name="lamaPinjam" class="form-select" required>
                    <option value="1">1 Hari</option>
                    <option value="3">3 Hari</option>
                    <option value="7" selected>7 Hari</option>
                </select>
            </div>

            <button type="submit" class="btn btn-primary">Ajukan Peminjaman</button>
            <a href="books.jsp" class="btn btn-secondary">Batal</a>
        </form>
    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
