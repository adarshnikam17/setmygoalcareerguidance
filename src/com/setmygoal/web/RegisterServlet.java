package com.setmygoal.web;

import com.setmygoal.dao.StudentDao;
import com.setmygoal.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import org.mindrot.jbcrypt.BCrypt;

public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html");

        String fullName     = req.getParameter("full_name");
        String email        = req.getParameter("email");
        String password     = req.getParameter("password");
        String standard     = req.getParameter("standard");
        String board        = req.getParameter("board");
        String medium       = req.getParameter("medium");
        String interest     = req.getParameter("interest");
        String state        = req.getParameter("state");
        String careerStream = req.getParameter("career_stream");
        String goalTimeline = req.getParameter("goal_timeline");
        String prepLevel    = req.getParameter("prep_level");

        if (fullName == null || fullName.isBlank() ||
            email    == null || email.isBlank()    ||
            password == null || password.isBlank()) {
            res.sendRedirect("signup.html?error=missing");
            return;
        }

        // ── Hash the password ──
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        Student s = new Student();
        s.setFullName(fullName);
        s.setEmail(email);
        s.setPassword(hashedPassword);  // ← store hash, not plain text
        s.setStandard(standard);
        s.setBoard(board);
        s.setMedium(medium);
        s.setInterest(interest);
        s.setState(state);
        s.setCareerStream(careerStream);
        s.setGoalTimeline(goalTimeline);
        s.setPrepLevel(prepLevel);

        try {
            StudentDao dao = new StudentDao();
            boolean success = dao.registerStudent(s);

           

if (success) {

    // Do NOT create session here
    // Only save data and redirect to login

    res.sendRedirect("login.html?success=registered");

} else {
    res.sendRedirect("signup.html?error=failed");
}

        } catch (SQLException e) {
            e.printStackTrace();
            PrintWriter out = res.getWriter();
            out.println("<h2 style='color:red'>SQL Error:</h2><pre>" + e.getMessage() + "</pre><a href='signup.html'>Go back</a>");
        } catch (Exception e) {
            e.printStackTrace();
            PrintWriter out = res.getWriter();
            out.println("<h2 style='color:red'>Error:</h2><pre>" + e.getMessage() + "</pre><a href='signup.html'>Go back</a>");
        }
    }
}