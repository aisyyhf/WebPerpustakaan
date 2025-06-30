<%-- 
    Document   : dashboard
    Created on : 24 May 2025, 12.44.16
    Author     : HP
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Pengguna" %>
<%@ page import="java.sql.*" %>
<%@ page import="classes.JDBC" %>

<%
    if (session == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Pengguna pengguna = (Pengguna) session.getAttribute("pengguna");
    if (pengguna == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String nama = pengguna.getNama();
    String role = pengguna.getRole();
    String namaDepan = nama.split(" ")[0]; // Ambil nama depan aja

    String userID = pengguna.getUserID();

    Connection conn = JDBC.getConnection();

    String sqlCurrentlyReading = "SELECT b.bookID, b.judul, b.penulis FROM wishlist w JOIN books b ON w.bookID = b.bookID WHERE w.userID = ? AND w.statusBaca = 'sedang dibaca'";
    PreparedStatement psCurrentlyReading = conn.prepareStatement(sqlCurrentlyReading);
    psCurrentlyReading.setString(1, userID);
    ResultSet rsCurrentlyReading = psCurrentlyReading.executeQuery();

    String sqlWishlist = "SELECT b.judul, b.penulis FROM wishlist w JOIN books b ON w.bookID = b.bookID WHERE w.userID = ? AND w.statusBaca = 'belum dibaca'";
    PreparedStatement psWishlist = conn.prepareStatement(sqlWishlist);
    psWishlist.setString(1, userID);
    ResultSet rsWishlist = psWishlist.executeQuery();

    String sqlPinjaman = "SELECT p.idPeminjaman, b.judul, p.tanggalKembali " +
                        "FROM peminjaman p " +
                        "JOIN books b ON p.bookID = b.bookID " +
                        "WHERE p.userID = ? AND p.status = 'dipinjam'";

    PreparedStatement psPinjaman = conn.prepareStatement(sqlPinjaman);
    psPinjaman.setString(1, userID);
    ResultSet rsPinjaman = psPinjaman.executeQuery();

    // Section Review: buku dengan statusBaca = 'sudah dibaca'
    String sqlReviewed = "SELECT b.bookID, b.judul FROM wishlist w JOIN books b ON w.bookID = b.bookID WHERE w.userID = ? AND w.statusBaca = 'sudah dibaca'";
    PreparedStatement psReviewed = conn.prepareStatement(sqlReviewed);
    psReviewed.setString(1, userID);
    ResultSet rsReviewed = psReviewed.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - MeinLib</title>
    <style>
        body { margin: 0; font-family: Arial, sans-serif; }
        .sidebar { position: fixed; width: 220px; height: 100%; background-color: #111; color: white; padding: 20px; box-shadow: 2px 0 5px rgba(0,0,0,0.1); }
        .sidebar h2 { font-size: 20px; margin-bottom: 30px; }
        .sidebar a { display: block; color: white; padding: 10px 0; text-decoration: none; transition: all 0.3s; }
        .sidebar a:hover { background-color: #444; padding-left: 10px; }
        .main { margin-left: 240px; padding: 20px; }
        .section { background-color: #f2f2f2; margin-bottom: 20px; padding: 20px; border-radius: 10px; }
        .grid { display: flex; gap: 10px; flex-wrap: wrap; }
        .box { flex: 1 1 200px; background-color: #ddd; text-align: center; padding: 15px; border-radius: 10px; margin-bottom: 10px; }
        .wishlist-text { font-size: 12px; color: gray; }

        /* Tombol putih dengan border hitam dan teks hitam */
        .btn-white-black {
            background-color: white;
            border: 2px solid black;
            color: black;
            padding: 6px 12px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            transition: 0.3s;
        }
        .btn-white-black:hover {
            background-color: black;
            color: white;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>📚 MEINLIB</h2>
    <p><strong><%= nama %></strong><br><%= role %></p>
    <a href="dashboard_user.jsp">🏠 Dashboard</a>
    <a href="profile.jsp">👤 Profile</a>
    <a href="books.jsp">📖 All Books</a>
    <a href="wishlist.jsp">📌 Wishlist</a>
    <a href="review.jsp">📝 Review</a>
    <a href="riwayat_peminjaman.jsp">⏰ Riwayat Peminjaman</a>
    <a href="LogoutServlet">🚪 Log Out</a>
    
</div>

<div class="main">
    <!-- Search Bar di pojok kanan atas -->
    <div style="text-align: right; margin-bottom: 20px;">
        <form action="books.jsp" method="get" style="display:inline;">
            <input type="text" name="search" placeholder="Cari buku berdasarkan judul, penulis, atau jenis..."
                   style="padding: 8px; border-radius: 5px; border: 1px solid #ccc;">
            <button type="submit" class="btn-white-black">🔍 Cari</button>
        </form>
    </div>

    <!-- Sapaan -->
    <div class="section">
        <h2>HALO <%= namaDepan.toUpperCase() %>!</h2>
        <p>Apa yang mau kamu baca hari ini?</p>
    </div>

    <!-- Reminder -->
    <div class="section">
        <h3><%= namaDepan.toUpperCase() %>’S REMINDER</h3>
        <table style="width: 100%; border-collapse: collapse;">
            <thead>
                <tr style="background-color: #eee;">
                    <th style="padding: 8px; border: 1px solid #ccc;">Judul Buku</th>
                    <th style="padding: 8px; border: 1px solid #ccc;">Tanggal Tenggat</th>
                    <th style="padding: 8px; border: 1px solid #ccc;">Aksi</th>
                </tr>
            </thead>
            <tbody>
                <%
                    boolean adaPinjaman = false;
                    while (rsPinjaman.next()) {
                        adaPinjaman = true;
                        int idPeminjaman = rsPinjaman.getInt("idPeminjaman");
                        String judulPinjam = rsPinjaman.getString("judul");
                        Date tanggalKembali = rsPinjaman.getDate("tanggalKembali");
                %>
                <tr>
                    <td style="padding: 8px; border: 1px solid #ccc;"><%= judulPinjam %></td>
                    <td style="padding: 8px; border: 1px solid #ccc;"><%= tanggalKembali %></td>
                    <td style="padding: 8px; border: 1px solid #ccc;">
                        <form action="PengembalianServlet" method="post" style="margin:0;">
                            <input type="hidden" name="idPeminjaman" value="<%= idPeminjaman %>">
                            <button type="submit" class="btn-white-black">Sudah Dikembalikan</button>
                        </form>
                    </td>
                </tr>
                <% 
                    }
                    if (!adaPinjaman) {
                %>
                <tr>
                    <td colspan="3" style="padding: 8px; border: 1px solid #ccc; text-align: center;">
                        Tidak ada buku yang sedang dipinjam.
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <!-- Currently Read: tampilkan semua buku yang sedang dibaca -->
    <div class="section">
        <h3><%= namaDepan.toUpperCase() %>’S CURRENTLY READ</h3>
        <div class="grid">
            <%
                boolean adaBukuSedangDibaca = false;
                while (rsCurrentlyReading.next()) {
                    adaBukuSedangDibaca = true;
                    String bookID = rsCurrentlyReading.getString("bookID");
                    String judul = rsCurrentlyReading.getString("judul");
                    String penulis = rsCurrentlyReading.getString("penulis");
            %>
                <div class="box">
                    <p><strong><%= judul %></strong></p>
                    <p><em><%= penulis %></em></p>
                    <button class="btn-white-black" onclick="location.href='baca.jsp?bookID=<%= bookID %>';">Lanjut Baca</button>
                </div>
            <% } 
                if (!adaBukuSedangDibaca) {
            %>
                <p>Belum ada buku yang sedang dibaca.</p>
            <% } %>
        </div>
    </div>

    <!-- Wishlist: tampilkan buku yang belum dibaca -->
    <div class="section">
        <h3><%= namaDepan.toUpperCase() %>’S BOOK WISHLIST</h3>
        <div class="grid">
            <% 
                boolean adaWishlist = false;
                while (rsWishlist.next()) {
                    adaWishlist = true;
                    String judul = rsWishlist.getString("judul");
                    String penulis = rsWishlist.getString("penulis");
            %>
                <div class="box">
                    <p><strong><%= judul %></strong></p>
                    <p><em><%= penulis %></em></p>
                </div>
            <% }
                if (!adaWishlist) {
            %>
                <p>Wishlist kamu kosong.</p>
            <% } %>
        </div>
        <p class="wishlist-text">Sudah kamu masukkan ke wishlist, ayo baca!</p>
        <button class="btn-white-black" onclick="location.href='wishlist.jsp';">Lihat Wishlist Lebih Lengkap</button>
    </div>

    <!-- Review: tampilkan buku yang sudah dibaca -->
    <div class="section">
        <%
            boolean adaReview = false;
            if (rsReviewed.next()) {
                adaReview = true;
        %>
        <h3><%= nama.toUpperCase() %> AYO REVIEW</h3>
        <p style="font-size: 12px; color: gray;">kamu sudah menyelesaikan ini, ayo tulis review!</p>
        <div class="grid">
            <%
                do {
                    String bookID = rsReviewed.getString("bookID");
                    String judul = rsReviewed.getString("judul");
            %>
            <div class="box" style="height: 100px;">
                <p><strong><%= judul %></strong></p>
                <button class="btn-white-black" onclick="location.href='review.jsp?bookID=<%= bookID %>';">Ayo Review!</button>
            </div>
            <%
                } while(rsReviewed.next());
            %>
        </div>
        <% } else { %>
            <p>Tidak ada buku untuk direview saat ini.</p>
        <% } %>
    </div>

</div>

</body>
</html>

<%
    rsCurrentlyReading.close();
    psCurrentlyReading.close();
    rsWishlist.close();
    psWishlist.close();
    rsPinjaman.close();
    psPinjaman.close();
    rsReviewed.close();
    psReviewed.close();
    conn.close();
%>