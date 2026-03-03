package com.setmygoal.service;

import com.setmygoal.dao.StudentDao;
import com.setmygoal.model.Student;
import org.mindrot.jbcrypt.BCrypt;
import java.sql.SQLException;

public class AuthService {

    private final StudentDao studentDao;

    public AuthService() { this.studentDao = new StudentDao(); }
    public AuthService(StudentDao studentDao) { this.studentDao = studentDao; }

    public RegistrationResult registerStudent(String fullName, String email,
                                              String passwordHash, String standard,
                                              String board, String medium,
                                              String interest, String state,
                                              String careerStream, String goalTimeline,
                                              String prepLevel) throws SQLException {
        if (studentDao.emailExists(email)) return RegistrationResult.EMAIL_ALREADY_EXISTS;

        Student student = new Student();
        student.setFullName(fullName);
        student.setEmail(email);
        student.setPassword(passwordHash);
        student.setStandard(standard);
        student.setBoard(board);
        student.setMedium(medium);
        student.setInterest(interest);
        student.setState(state);
        student.setCareerStream(careerStream);
        student.setGoalTimeline(goalTimeline);
        student.setPrepLevel(prepLevel);

        boolean created = studentDao.registerStudent(student);
        return created ? RegistrationResult.SUCCESS : RegistrationResult.FAILURE;
    }

    // ── BCrypt authenticate ──
    public Student authenticate(String email, String plainPassword) throws SQLException {
        Student student = studentDao.findByEmail(email);
        if (student == null) return null;
        if (student.getPassword() == null) return null;
        if (!BCrypt.checkpw(plainPassword, student.getPassword())) return null;
        return student;
    }

    public enum RegistrationResult { SUCCESS, EMAIL_ALREADY_EXISTS, FAILURE }
}