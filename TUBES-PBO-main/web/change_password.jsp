<%-- 
    Document   : change_password
    Created on : 12 Jun 2025, 14.56.22
    Author     : HP
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Pengguna" %>
<%
    if (session == null || session.getAttribute("pengguna") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Ganti Password</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; }
        .sidebar { position: fixed; width: 220px; height: 100%; background-color: #111; color: white; padding: 20px; }
        .sidebar h2 { font-size: 20px; margin-bottom: 30px; }
        .sidebar a { display: block; color: white; padding: 10px 0; text-decoration: none; }
        .sidebar a:hover { background-color: #444; }
        .main { margin-left: 240px; padding: 20px; }
        .password-container { max-width: 600px; margin: 0 auto; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; }
        input[type="password"] { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
        button { background-color: #4CAF50; color: white; padding: 10px 15px; border: none; border-radius: 4px; cursor: pointer; }
        .message { color: green; margin-top: 10px; }
        .error { color: red; margin-top: 10px; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>📚 MEINLIB</h2>
        <p><strong><%= ((Pengguna)session.getAttribute("pengguna")).getNama() %></strong><br><%= ((Pengguna)session.getAttribute("pengguna")).getRole() %></p>
        <a href="dashboard_user.jsp">🏠 Dashboard</a>
        <a href="profile.jsp">👤 Profil</a>
        <a href="change_password.jsp">🔒 Ganti Password</a>
        <a href="LogoutServlet">🚪 Log Out</a>
    </div>

    <div class="main">
        <div class="password-container">
            <h1>Ganti Password</h1>
            
            <% if (request.getAttribute("message") != null) { %>
                <div class="message"><%= request.getAttribute("message") %></div>
            <% } %>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="error"><%= request.getAttribute("error") %></div>
            <% } %>
            
            <form action="ChangePasswordServlet" method="post">
                <div class="form-group">
                    <label for="currentPassword">Password Saat Ini:</label>
                    <input type="password" id="currentPassword" name="currentPassword" required>
                </div>
                
                <div class="form-group">
                    <label for="newPassword">Password Baru:</label>
                    <input type="password" id="newPassword" name="newPassword" required>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">Konfirmasi Password Baru:</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required>
                </div>
                
                <button type="submit">Ganti Password</button>
            </form>
        </div>
    </div>
</body>
</html>
