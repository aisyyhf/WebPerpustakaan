<%-- 
    Document   : baca
    Created on : 28 May 2025, 13.20.09
    Author     : HP
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="classes.JDBC" %>
<%@ page import="model.Pengguna" %>
<%@ page import="java.sql.*" %>

<%
    if (session == null || session.getAttribute("pengguna") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    Pengguna pengguna = (Pengguna) session.getAttribute("pengguna");
    String userID = pengguna.getUserID();

    String bookID = request.getParameter("bookID");
    if (bookID == null || bookID.trim().isEmpty()) {
        out.println("<h3>Book ID tidak ditemukan!</h3>");
        return;
    }

    String judul = "";
    String penulis = "";
    String konten = ""; // nanti ambil dari DB kalau ada kolom konten
    String statusBaca = "";

    try (Connection conn = JDBC.getConnection()) {
        // Ambil data buku
        String sqlBook = "SELECT judul, penulis FROM books WHERE bookID = ?";
        PreparedStatement psBook = conn.prepareStatement(sqlBook);
        psBook.setString(1, bookID);
        ResultSet rsBook = psBook.executeQuery();
        if (rsBook.next()) {
            judul = rsBook.getString("judul");
            penulis = rsBook.getString("penulis");
        }
        rsBook.close();
        psBook.close();

        // Ambil status baca dari wishlist
        String sqlStatus = "SELECT statusBaca FROM wishlist WHERE userID = ? AND bookID = ?";
        PreparedStatement psStatus = conn.prepareStatement(sqlStatus);
        psStatus.setString(1, userID);
        psStatus.setString(2, bookID);
        ResultSet rsStatus = psStatus.executeQuery();
        if (rsStatus.next()) {
            statusBaca = rsStatus.getString("statusBaca");
        }
        rsStatus.close();
        psStatus.close();

        // Jika status masih belum dibaca, update ke sedang dibaca (user mulai baca)
        if ("belum dibaca".equals(statusBaca)) {
            String updateStatus = "UPDATE wishlist SET statusBaca = 'sedang dibaca' WHERE userID = ? AND bookID = ?";
            PreparedStatement psUpdate = conn.prepareStatement(updateStatus);
            psUpdate.setString(1, userID);
            psUpdate.setString(2, bookID);
            psUpdate.executeUpdate();
            psUpdate.close();
            statusBaca = "sedang dibaca";
        }

        // Untuk demo, isi konten dummy panjang:
        konten = "Ini adalah isi buku '" + judul + "'.\n\n" +
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n\n";
                

    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Baca Buku - <%= judul %></title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; line-height: 1.6; }
        .header { margin-bottom: 20px; }
        .content { height: 70vh; overflow-y: scroll; border: 1px solid #ccc; padding: 20px; white-space: pre-wrap; background-color: #fafafa; }

        /* CSS untuk tombol */
        .btn {
            display: inline-block;
            padding: 12px 20px;
            background-color: white;  /* Warna latar belakang tombol putih */
            color: black;  /* Warna teks tombol hitam */
            border: 2px solid black;  /* Pinggiran tombol hitam */
            border-radius: 5px;
            cursor: pointer;
            text-align: center;
            width: 200px;
            font-size: 16px;
            margin-top: 15px;
            transition: all 0.3s ease;
        }

        .btn:hover {
            background-color: black;  /* Latar belakang hitam saat hover */
            color: white;  /* Teks putih saat hover */
        }

        .btn:active {
            background-color: black;  /* Latar belakang hitam saat tombol ditekan */
            color: white;  /* Teks putih saat tombol ditekan */
            border: 2px solid black;  /* Pinggiran tetap hitam */
        }
    </style>
</head>
<body>
    <div class="header">
        <form action="wishlist.jsp" method="get">
            <button type="submit" class="btn">Kembali ke Wishlist</button> <!-- Tombol Kembali ke Wishlist -->
        </form>

        <form action="dashboard_user.jsp" method="get">
            <button type="submit" class="btn">Kembali ke Dashboard</button> <!-- Tombol Kembali ke Dashboard -->
        </form>

        <h2><%= judul %></h2>
        <p><em>Penulis: <%= penulis %></em></p>
        <p>Status baca: <strong><%= statusBaca %></strong></p>
    </div>

    <div class="content" id="bookContent">
        <%= konten %> <!-- Konten buku -->
    </div>

    <form action="UpdateStatusBacaServlet" method="post">
        <input type="hidden" name="userID" value="<%= userID %>">
        <input type="hidden" name="bookID" value="<%= bookID %>">
        <button type="submit" class="btn" <%= "sudah dibaca".equals(statusBaca) ? "disabled" : "" %>>Tandai Sudah Dibaca</button>
    </form>

</body>
</html>