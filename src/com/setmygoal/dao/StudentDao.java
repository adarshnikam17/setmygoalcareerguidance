package com.setmygoal.dao;

import com.setmygoal.config.DatabaseConfig;
import com.setmygoal.model.Student;
import java.sql.*;

public class StudentDao {

    // ── Register new student ──
    public boolean registerStudent(Student s) throws SQLException {
        System.out.println("Inside registerStudent DAO");
        String sql = "INSERT INTO students (full_name, email, password, standard, board, medium, interest, state, career_stream, goal_timeline, prep_level) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DatabaseConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1,  s.getFullName());
            ps.setString(2,  s.getEmail());
            ps.setString(3,  s.getPassword());
            ps.setString(4,  s.getStandard());
            ps.setString(5,  s.getBoard());
            ps.setString(6,  s.getMedium());
            ps.setString(7,  s.getInterest());
            ps.setString(8,  s.getState());
            ps.setString(9,  s.getCareerStream());
            ps.setString(10, s.getGoalTimeline());
            ps.setString(11, s.getPrepLevel());
            return ps.executeUpdate() == 1;
        }
    }

    // ── Find by email (used by Login + Register) ──
    public Student findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM students WHERE email = ?";
        try (Connection con = DatabaseConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
            return null;
        }
    }

    // ── Check email exists ──
    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT id FROM students WHERE email = ?";
        try (Connection con = DatabaseConfig.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            return ps.executeQuery().next();
        }
    }

    // ── Map ResultSet to Student ──
    private Student mapRow(ResultSet rs) throws SQLException {
        Student s = new Student();
        s.setId(rs.getInt("id"));
        s.setFullName(rs.getString("full_name"));
        s.setEmail(rs.getString("email"));
        s.setPassword(rs.getString("password"));
        s.setStandard(rs.getString("standard"));
        s.setBoard(rs.getString("board"));
        s.setMedium(rs.getString("medium"));
        s.setInterest(rs.getString("interest"));
        s.setState(rs.getString("state"));
        s.setCareerStream(rs.getString("career_stream"));
        s.setGoalTimeline(rs.getString("goal_timeline"));
        s.setPrepLevel(rs.getString("prep_level"));
        return s;
    }
}