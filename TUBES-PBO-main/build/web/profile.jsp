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
    <title>Profil Pengguna</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 0; 
            padding: 0; 
            background-color: #f4f4f4; 
        }
        .sidebar { 
            position: fixed; 
            width: 220px; 
            height: 100%; 
            background-color: #111;  
            color: white; 
            padding: 20px; 
            box-shadow: 2px 0 5px rgba(0,0,0,0.1);
        }
        .sidebar h2 { 
            font-size: 20px; 
            margin-bottom: 30px; 
            color: #ecf0f1;  
        }
        .sidebar a { 
            display: block; 
            color: #ecf0f1; 
            padding: 12px 0; 
            text-decoration: none; 
            transition: all 0.3s;
        }
        .sidebar a:hover { 
            background-color: #444;  
            padding-left: 10px;
        }
        .main { 
            margin-left: 260px; 
            padding: 30px;
            background-color: white;
            min-height: calc(100vh - 60px);
            box-shadow: 0 0 10px rgba(0,0,0,0.05);
        }
        .profile-container { 
            max-width: 600px; 
            margin: 0 auto; 
            padding: 30px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        .profile-header { 
            display: flex; 
            align-items: center; 
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }
        .profile-pic { 
            width: 120px; 
            height: 120px; 
            border-radius: 50%; 
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 50px;
            color: #fff;
            background-color: #3498db;
        }
        .profile-info { margin-left: 20px; }
        .profile-info h2 { margin: 0; color: #2c3e50; }
        .profile-info p { margin: 5px 0 0; color: #7f8c8d; }
        .form-group { margin-bottom: 20px; }
        label { 
            display: block; 
            margin-bottom: 8px; 
            font-weight: bold;
            color: #2c3e50;
        }
        input[type="text"], input[type="email"], input[type="tel"] { 
            width: 100%; 
            padding: 12px; 
            border: 1px solid #ddd; 
            border-radius: 4px; 
            font-size: 16px;
            transition: border 0.3s;
        }
        input[type="text"]:focus, input[type="email"]:focus, input[type="tel"]:focus {
            border-color: #3498db;
            outline: none;
        }
        button { 
            background-color: #3498db; 
            color: white; 
            padding: 12px 20px; 
            border: none; 
            border-radius: 4px; 
            cursor: pointer; 
            font-size: 16px;
            transition: background-color 0.3s;
            width: 100%;
        }
        button:hover {
            background-color: #2980b9; 
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>📚 MEINLIB</h2>
        <p><strong><%= pengguna.getNama() %></strong><br><%= pengguna.getRole() %></p>
        <a href="dashboard_user.jsp">🏠 Dashboard</a>
        <a href="profile.jsp">👤 Profil</a>
        <a href="change_password.jsp">🔒 Ganti Password</a>
        <a href="LogoutServlet">🚪 Log Out</a>
    </div>

    <div class="main">
        <div class="profile-container">
            <h1>Profil Pengguna</h1>
            
            <% if (request.getAttribute("message") != null) { %>
                <div class="message"><%= request.getAttribute("message") %></div>
            <% } %>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="error"><%= request.getAttribute("error") %></div>
            <% } %>
            
            <form action="ProfileServlet" method="post">
                <div class="profile-header">
                    <!-- Ganti bagian ini untuk hanya menampilkan simbol "👤" -->
                    <div class="profile-pic">👤</div>
                    <div class="profile-info">
                        <h2><%= pengguna.getNama() %></h2>
                        <p><%= pengguna.getEmail() %></p>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="nama">Nama:</label>
                    <input type="text" id="nama" name="nama" value="<%= pengguna.getNama() %>" required>
                </div>
                
                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" value="<%= pengguna.getEmail() %>" readonly>
                </div>
                
                <div class="form-group">
                    <label for="phone_number">Nomor Telepon:</label>
                    <input type="tel" id="phone_number" name="phone_number" value="<%= pengguna.getPhoneNumber() %>" required>
                </div>
                
                <button type="submit">Simpan Perubahan</button>
            </form>
        </div>
    </div>
</body>
</html>
