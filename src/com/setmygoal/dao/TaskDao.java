package com.setmygoal.dao;

import com.setmygoal.config.DatabaseConfig;
import com.setmygoal.model.Task;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for reading and writing tasks.
 */
public class TaskDao {

    public List<Task> findTodayTasksForUser(int userId) throws SQLException {
        String sql = """
                SELECT id, user_id, goal_id, title, description, due_date, completed, skill_tag
                FROM tasks
                WHERE user_id = ?
                  AND (due_date IS NULL OR DATE(due_date) = CURDATE())
                ORDER BY completed ASC, id DESC
                """;

        try (Connection con = DatabaseConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Task> tasks = new ArrayList<>();
                while (rs.next()) {
                    tasks.add(mapRow(rs));
                }
                return tasks;
            }
        }
    }

    public boolean createQuickTask(int userId, Integer goalId, String title, String skillTag) throws SQLException {
        String sql = """
                INSERT INTO tasks(user_id, goal_id, title, skill_tag, due_date, completed)
                VALUES (?, ?, ?, ?, CURDATE(), 0)
                """;

        try (Connection con = DatabaseConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            if (goalId != null) {
                ps.setInt(2, goalId);
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            ps.setString(3, title);
            ps.setString(4, skillTag);

            int affected = ps.executeUpdate();
            return affected > 0;
        }
    }

    public boolean markCompleted(int taskId, int userId) throws SQLException {
        String sql = """
                UPDATE tasks
                SET completed = 1, completed_at = NOW()
                WHERE id = ? AND user_id = ?
                """;

        try (Connection con = DatabaseConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, taskId);
            ps.setInt(2, userId);

            int affected = ps.executeUpdate();
            return affected > 0;
        }
    }

    private Task mapRow(ResultSet rs) throws SQLException {
        Task task = new Task();
        task.setId(rs.getInt("id"));
        task.setUserId(rs.getInt("user_id"));
        int goalId = rs.getInt("goal_id");
        task.setGoalId(rs.wasNull() ? null : goalId);
        task.setTitle(rs.getString("title"));
        task.setDescription(rs.getString("description"));
        Date dueDate = rs.getDate("due_date");
        task.setDueDate(dueDate != null ? dueDate.toLocalDate() : null);
        task.setCompleted(rs.getBoolean("completed"));
        task.setSkillTag(rs.getString("skill_tag"));
        return task;
    }
}

