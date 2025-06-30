<%-- 
    Document   : menunggu_persetujuan
    Created on : 12 Jun 2025, 10.43.58
    Author     : HP
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Pengguna" %>

<%
    if (session == null || session.getAttribute("pengguna") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    Pengguna pengguna = (Pengguna) session.getAttribute("pengguna");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Menunggu Persetujuan</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <style>
        body { background: #f5f5f5; padding: 50px; font-family: Arial, sans-serif; }
        .container { background: white; padding: 40px; border-radius: 12px; text-align: center; max-width: 600px; margin: auto; box-shadow: 0 0 15px #ccc; }
    </style>
</head>
<body>
<div class="container">
    <h2>✅ Permintaan Peminjaman Diterima</h2>
    <p>Halo <strong><%= pengguna.getNama() %></strong>, permintaan peminjamanmu telah kami terima.</p>
    <p>Mohon tunggu persetujuan dari perpustakawan. Kamu dapat memantau statusnya di halaman riwayat peminjaman.</p>
    <br/>
    <a href="riwayat_peminjaman.jsp" class="btn btn-primary">Lihat Riwayat Peminjaman</a>
    <a href="books.jsp" class="btn btn-secondary">Kembali ke Daftar Buku</a>
</div>
</body>
</html>