package com.setmygoal.web;

import com.setmygoal.dao.TaskDao;
import com.setmygoal.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

/**
 * Handles quick task actions from the dashboard (add / complete).
 */
public class TaskServlet extends HttpServlet {

    private final TaskDao taskDao = new TaskDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("student") == null) {
            response.sendRedirect("login.html");
            return;
        }
        Student student = (Student) session.getAttribute("student");

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect("dashboard");
            return;
        }

        try {
            switch (action) {
                case "add" -> handleAddTask(request, student);
                case "complete" -> handleCompleteTask(request, student);
                default -> {
                    // ignore unknown
                }
            }
        } catch (SQLException e) {
            throw new ServletException("Error while updating tasks", e);
        }

        response.sendRedirect("dashboard");
    }

    private void handleAddTask(HttpServletRequest request, Student student) throws SQLException {
        String title = request.getParameter("title");
        String skillTag = request.getParameter("skill_tag");
        if (title == null || title.isBlank()) {
            return;
        }
        if (skillTag == null || skillTag.isBlank()) {
            skillTag = "General";
        }
        taskDao.createQuickTask(student.getId(), null, title.trim(), skillTag.trim());
    }

    private void handleCompleteTask(HttpServletRequest request, Student student) throws SQLException {
        String idParam = request.getParameter("task_id");
        if (idParam == null) {
            return;
        }
        try {
            int taskId = Integer.parseInt(idParam);
            taskDao.markCompleted(taskId, student.getId());
        } catch (NumberFormatException ignored) {
        }
    }
}

