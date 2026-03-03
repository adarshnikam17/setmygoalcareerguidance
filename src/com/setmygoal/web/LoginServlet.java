package com.setmygoal.web;

import com.setmygoal.dao.StudentDao;
import com.setmygoal.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import org.mindrot.jbcrypt.BCrypt;

public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        try {
            StudentDao dao = new StudentDao();

            // ── Find student by email only ──
            Student s = dao.findByEmail(email);

            if (s != null && BCrypt.checkpw(password, s.getPassword())) {
                // ── Password matches — create session ──
                HttpSession session = req.getSession();
                session.setAttribute("student", s);
                session.setAttribute("studentName", s.getFullName());
                session.setAttribute("studentId", s.getId());
                res.sendRedirect("dashboard");
            } else {
                res.sendRedirect("login.html?error=1");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            res.sendRedirect("login.html?error=1");
        }
    }
}