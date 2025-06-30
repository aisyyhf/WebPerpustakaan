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
    if (pengguna == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String role = pengguna.getRole();
    if (!"pembaca".equalsIgnoreCase(role)) {
        response.sendRedirect("dashboard_admin.jsp");
        return;
    }

    String userID = pengguna.getUserID();
    String keyword = request.getParameter("search");

    Connection conn = JDBC.getConnection();
    String query = "SELECT * FROM books";
    PreparedStatement stmt;

    if (keyword != null && !keyword.trim().isEmpty()) {
        query += " WHERE judul LIKE ? OR penulis LIKE ? OR jenis LIKE ?";
        stmt = conn.prepareStatement(query);
        String like = "%" + keyword + "%";
        stmt.setString(1, like);
        stmt.setString(2, like);
        stmt.setString(3, like);
    } else {
        stmt = conn.prepareStatement(query);
    }

    ResultSet rs = stmt.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Daftar Buku - MEINLIB</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { width: 100%; border-collapse: collapse; }
        table, th, td { border: 1px solid #aaa; }
        th, td { padding: 10px; text-align: left; }
        th { background-color: #f0f0f0; }
        .btn { padding: 5px 10px; margin: 0 2px; border: none; border-radius: 4px; cursor: pointer; }
        .btn-wishlist { background-color: #007bff; color: white; }
        .btn-pinjam { background-color: #28a745; color: white; }
        .btn-disabled { background-color: #ccc; color: #666; cursor: not-allowed; }
        .back-btn { margin-bottom: 20px; display: inline-block; text-decoration: none; background-color: #222; color: white; padding: 8px 12px; border-radius: 5px; }
        .back-btn:hover { background-color: #444; }
    </style>
</head>
<body>

<a href="dashboard_user.jsp" class="back-btn">⬅ Kembali ke Dashboard</a>

<h2>📚 Daftar Buku</h2>

<form action="books.jsp" method="get" style="margin-bottom: 20px;">
    <input type="text" name="search" placeholder="Cari judul, penulis, atau jenis..."
           value="<%= keyword != null ? keyword : "" %>"
           style="width: 60%; padding: 8px; border-radius: 5px; border: 1px solid #ccc;">
    <button type="submit" style="padding: 8px 12px;">🔍 Cari</button>
</form>

<table>
    <tr>
        <th>Judul</th>
        <th>Penulis</th>
        <th>Penerbit</th>
        <th>Tahun</th>
        <th>Jenis</th>
        <th>Status</th>
        <th>Aksi</th>
    </tr>
<%
    while (rs.next()) {
        String bookID = rs.getString("bookID");
        String jenis = rs.getString("jenis");
        String status = rs.getString("statusKetersediaan");
%>
    <tr>
        <td><%= rs.getString("judul") %></td>
        <td><%= rs.getString("penulis") %></td>
        <td><%= rs.getString("penerbit") %></td>
        <td><%= rs.getString("tahunTerbit") %></td>
        <td><%= jenis %></td>
        <td><%= status %></td>
        <td>
    <% if ("ebook".equalsIgnoreCase(jenis)) { %>
        <!-- Tambah ke Wishlist -->
        <button type="button" class="btn btn-wishlist" data-bs-toggle="modal" data-bs-target="#wishlistModal" 
            onclick="setModalData('<%= bookID %>', '<%= rs.getString("judul").replace("'", "\\'") %>')">
            Tambah ke Wishlist
        </button>
    <% } else if ("fisik".equalsIgnoreCase(jenis) && "tersedia".equalsIgnoreCase(status)) { %>
        <!-- Arahkan ke form peminjaman -->
        <form action="peminjaman_user.jsp" method="get" style="display:inline;">
            <input type="hidden" name="bookID" value="<%= bookID %>">
            <button type="submit" class="btn btn-pinjam">Pinjam Buku</button>
        </form>
    <% } else { %>
        <button class="btn btn-disabled" disabled>Tidak tersedia</button>
    <% } %>
</td>
    </tr>
<% } 
    rs.close();
    stmt.close();
    conn.close();
%>
</table>

<!-- Modal Konfirmasi Wishlist -->
<div class="modal fade" id="wishlistModal" tabindex="-1" aria-labelledby="wishlistModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content" style="border-radius: 0 50px 0 50px;">
      <div class="modal-header">
        <h5 class="modal-title" id="wishlistModalLabel">Konfirmasi Wishlist</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Tutup"></button>
      </div>
      <div class="modal-body">
        <p id="modalText">Masukkan buku ke dalam wishlist?</p>
      </div>
      <div class="modal-footer">
        <form id="wishlistForm" method="post" action="WishlistServlet">
          <input type="hidden" name="userID" value="<%= userID %>">
          <input type="hidden" id="modalBookID" name="bookID" value="">
          <button type="submit" class="btn btn-primary">Iya</button>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
        </form>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
function setModalData(bookID, judul) {
    document.getElementById('modalBookID').value = bookID;
    document.getElementById('modalText').textContent = `Masukkan buku "${judul}" ke dalam wishlist?`;
}
</script>

</body>
</html>