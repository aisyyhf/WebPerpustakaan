<%-- 
    Document   : books_admin
    Created on : 29 May 2025, 16.27.13
    Author     : HP
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="classes.JDBC" %>
<%@ page import="model.Pengguna" %>

<%
    // Cek session dan ambil objek pengguna
    if (session == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Pengguna pengguna = (Pengguna) session.getAttribute("pengguna");
    if (pengguna == null || !"admin".equalsIgnoreCase(pengguna.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = JDBC.getConnection();
    String query = "SELECT * FROM books";
    PreparedStatement stmt = conn.prepareStatement(query);
    ResultSet rs = stmt.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Kelola Buku - MEINLIB</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { width: 100%; border-collapse: collapse; }
        table, th, td { border: 1px solid #aaa; }
        th, td { padding: 10px; text-align: left; }
        th { background-color: #f0f0f0; }
        .btn { padding: 5px 10px; margin: 0 2px; border: none; border-radius: 4px; cursor: pointer; }
        .btn-edit { background-color: #ffc107; color: white; }
        .btn-hapus { background-color: #dc3545; color: white; }
        .btn-disabled { background-color: #ccc; color: #666; cursor: not-allowed; }
        .back-btn { margin-bottom: 20px; display: inline-block; text-decoration: none; background-color: #222; color: white; padding: 8px 12px; border-radius: 5px; }
        .back-btn:hover { background-color: #444; }
    </style>
</head>
<body>

<a href="dashboard_admin.jsp" class="back-btn">⬅ Kembali ke Dashboard</a>

<h2>📚 Kelola Buku</h2>

<!-- Search Bar di pojok kanan atas -->
<div style="text-align: right; margin-bottom: 15px;">
  <form action="books_admin.jsp" method="get" style="display: inline;">
    <input type="text" name="search" placeholder="Cari buku berdasarkan judul, penulis, atau jenis..."
           style="padding: 6px 12px; border-radius: 5px; border: 1px solid #ccc;">
    <button type="submit" class="btn btn-primary">🔍 Cari</button>
  </form>
</div>

<a href="tambahbuku.jsp" class="btn btn-primary" style="margin-bottom: 15px;">Tambah Buku</a>

<table>
    <tr>
        <th>Judul</th>
        <th>Penulis</th>
        <th>Penerbit</th>
        <th>Tahun Terbit</th>
        <th>Jenis</th>
        <th>Status</th>
        <th>Aksi</th>
    </tr>
<%
    while (rs.next()) {
        String bookID = rs.getString("bookID");
        String judul = rs.getString("judul");
        String penulis = rs.getString("penulis");
        String penerbit = rs.getString("penerbit");
        String tahun = rs.getString("tahunTerbit");
        String jenis = rs.getString("jenis");
        String status = rs.getString("statusKetersediaan");
%>
    <tr>
        <td><%= judul %></td>
        <td><%= penulis %></td>
        <td><%= penerbit %></td>
        <td><%= tahun %></td>
        <td><%= jenis %></td>
        <td><%= status %></td>
        <td>
            <a href="editbuku.jsp?bookID=<%= bookID %>" class="btn btn-edit">Edit</a>
            <form action="HapusServlet" method="post" style="display:inline;">
                <input type="hidden" name="bookID" value="<%= bookID %>">
                <button type="submit" class="btn btn-hapus">Hapus</button>
            </form>
        </td>
    </tr>
<% } 
    rs.close();
    stmt.close();
    conn.close();
%>
</table>

</body>
</html>

