package com.setmygoal.dao;

import com.setmygoal.config.DatabaseConfig;
import com.setmygoal.model.Goal;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * DAO for reading and writing long‑term goals.
 */
public class GoalDao {

    public Goal findActiveGoalForUser(int userId) throws SQLException {
        String sql = """
                SELECT id, user_id, title, description, target_date, progress_percent, active
                FROM goals
                WHERE user_id = ? AND active = 1
                ORDER BY id DESC
                LIMIT 1
                """;

        try (Connection con = DatabaseConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                return mapRow(rs);
            }
        }
    }

    public boolean createDefaultGoalForUser(int userId, String title, String description) throws SQLException {
        String sql = """
                INSERT INTO goals(user_id, title, description, target_date, progress_percent, active)
                VALUES (?, ?, ?, DATE_ADD(CURDATE(), INTERVAL 365 DAY), 0, 1)
                """;

        try (Connection con = DatabaseConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, title);
            ps.setString(3, description);
            int affected = ps.executeUpdate();
            return affected > 0;
        }
    }

    private Goal mapRow(ResultSet rs) throws SQLException {
        Goal goal = new Goal();
        goal.setId(rs.getInt("id"));
        goal.setUserId(rs.getInt("user_id"));
        goal.setTitle(rs.getString("title"));
        goal.setDescription(rs.getString("description"));
        Date target = rs.getDate("target_date");
        goal.setTargetDate(target != null ? target.toLocalDate() : null);
        goal.setProgressPercent(rs.getInt("progress_percent"));
        goal.setActive(rs.getBoolean("active"));
        return goal;
    }
}

