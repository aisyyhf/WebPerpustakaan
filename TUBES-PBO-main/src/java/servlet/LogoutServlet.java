package servlet;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Ambil session aktif, tapi jangan buat baru kalau belum ada
        HttpSession session = request.getSession(false);

        if (session != null) {
            session.invalidate(); // Hapus semua atribut session
        }

        // Redirect ke halaman login setelah logout
        response.sendRedirect("login.jsp");
    }
}