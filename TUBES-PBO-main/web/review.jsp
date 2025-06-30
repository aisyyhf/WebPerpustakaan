<%-- 
    Document   : review
    Created on : 28 May 2025, 13.20.21
    Author     : HP
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="classes.JDBC" %>
<%@ page import="model.Pengguna" %>

<%
    if (session == null || session.getAttribute("pengguna") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    Pengguna pengguna = (Pengguna) session.getAttribute("pengguna");
    String userID = pengguna.getUserID();

    String bookID = request.getParameter("bookID");

    List<Map<String, Object>> reviewList = new ArrayList<>();
    String judul = "";
    String penulis = "";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        conn = JDBC.getConnection();

        if (bookID != null && !bookID.trim().isEmpty()) {
            // Ambil detail buku
            String bookSql = "SELECT judul, penulis FROM books WHERE bookID = ?";
            PreparedStatement bookStmt = conn.prepareStatement(bookSql);
            bookStmt.setString(1, bookID);
            ResultSet bookRs = bookStmt.executeQuery();
            if (bookRs.next()) {
                judul = bookRs.getString("judul");
                penulis = bookRs.getString("penulis");
            }
            bookRs.close();
            bookStmt.close();

            // Ambil review buku ini
            String reviewSql = "SELECT r.rating, r.komentar, p.nama FROM review r JOIN pengguna p ON r.userID = p.userID WHERE r.bookID = ? ORDER BY r.tanggalReview DESC";
            stmt = conn.prepareStatement(reviewSql);
            stmt.setString(1, bookID);
        } else {
            // Ambil semua review user ini tulis
            String reviewSql = "SELECT r.rating, r.komentar, b.judul FROM review r JOIN books b ON r.bookID = b.bookID WHERE r.userID = ? ORDER BY r.tanggalReview DESC";
            stmt = conn.prepareStatement(reviewSql);
            stmt.setString(1, userID);
        }

        rs = stmt.executeQuery();

        while (rs.next()) {
            Map<String, Object> review = new HashMap<>();
            if (bookID != null && !bookID.trim().isEmpty()) {
                review.put("nama", rs.getString("nama"));
                review.put("rating", rs.getInt("rating"));
                review.put("komentar", rs.getString("komentar"));
            } else {
                review.put("judul", rs.getString("judul"));
                review.put("rating", rs.getInt("rating"));
                review.put("komentar", rs.getString("komentar"));
            }
            reviewList.add(review);
        }

    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        try { if (rs != null) rs.close(); } catch(Exception e) {}
        try { if (stmt != null) stmt.close(); } catch(Exception e) {}
        try { if (conn != null) conn.close(); } catch(Exception e) {}
    }

    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Review Buku - MeinLib</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .stars { color: gold; }
        .review-item { margin-bottom: 15px; padding-bottom: 15px; border-bottom: 1px solid #ddd; }
        textarea { width: 100%; height: 100px; }
    </style>
</head>
<body class="container">

<% if (bookID != null && !bookID.trim().isEmpty()) { %>
    <a href="wishlist.jsp" class="btn btn-secondary mb-3">⬅ Kembali ke Wishlist</a>
    <h2>Review Buku: <%= judul %></h2>
    <p><em>Penulis: <%= penulis %></em></p>
<% } else { %>
    <a href="dashboard_user.jsp" class="btn btn-secondary mb-3">⬅ Kembali ke Dashboard</a>
    <h2>Semua Review Saya</h2>
<% } %>

<% if (error != null) { %>
    <div class="alert alert-danger"><%= error %></div>
<% } %>

<% if (success != null) { %>
    <div class="alert alert-success"><%= success %></div>
<% } %>

<div>
    <% if (reviewList.isEmpty()) { %>
        <p>Belum ada review.</p>
    <% } else {
        for (Map<String, Object> r : reviewList) {
    %>
        <div class="review-item">
            <% if (bookID != null && !bookID.trim().isEmpty()) { %>
                <strong><%= r.get("nama") %></strong><br/>
            <% } else { %>
                <strong>Buku: <%= r.get("judul") %></strong><br/>
            <% } %>
            <span class="stars">
                <% int rating = (int) r.get("rating");
                   for (int i = 0; i < rating; i++) { %>★<% }
                   for (int i = rating; i < 5; i++) { %>☆<% } %>
            </span>
            <p><%= r.get("komentar") %></p>
        </div>
    <%  }
    } %>
</div>

<% if (bookID != null && !bookID.trim().isEmpty()) { %>
    <hr/>
    <h4>Tambah Review</h4>
    <form action="SubmitReviewServlet" method="post">
        <input type="hidden" name="bookID" value="<%= bookID %>" />
        Rating:
        <select name="rating" class="form-select" style="width: 100px; display: inline-block;">
            <option value="1">★☆☆☆☆</option>
            <option value="2">★★☆☆☆</option>
            <option value="3" selected>★★★☆☆</option>
            <option value="4">★★★★☆</option>
            <option value="5">★★★★★</option>
        </select>
        <br/><br/>
        <textarea name="comment" placeholder="Tulis komentar kamu di sini..." required></textarea>
        <br/>
        <input type="submit" class="btn btn-primary" value="Kirim Review" />
    </form>
<% } else { %>
    <p>Untuk menambah review, buka halaman buku yang ingin direview melalui wishlist atau daftar buku.</p>
<% } %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
