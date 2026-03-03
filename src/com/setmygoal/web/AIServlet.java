package com.setmygoal.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

/**
 * AIServlet — handles all OpenAI API calls for:
 *   - AI Chat  (type: "chat")
 *   - Quiz     (type: "quiz")
 *   - Study Plan (type: "plan")
 */
public class AIServlet extends HttpServlet {

    // ── PUT YOUR OPENAI API KEY HERE ──
    private static final String apiKey = System.getenv("OPENAI_API_KEY");
    private static final String OPENAI_URL     = "https://api.openai.com/v1/chat/completions";
    private static final String MODEL          = "gpt-3.5-turbo";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // ── Auth check ──
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("student") == null) {
            res.setStatus(401);
            res.getWriter().write("{\"error\":\"Unauthorized\"}");
            return;
        }

        res.setContentType("application/json;charset=UTF-8");

        // ── Read request body ──
        StringBuilder sb = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(req.getInputStream(), StandardCharsets.UTF_8))) {
            String line;
            while ((line = br.readLine()) != null) sb.append(line);
        }
        String body = sb.toString();

        // ── Parse type ──
        String type    = extractJson(body, "type");
        String context = extractJson(body, "context");
        String stream  = extractJson(body, "stream");

        try {
            String result;
            if ("chat".equals(type)) {
                String message = extractJson(body, "message");
                result = handleChat(message, context);
                res.getWriter().write("{\"reply\":" + jsonStr(result) + "}");

            } else if ("quiz".equals(type)) {
                result = handleQuiz(stream, context);
                res.getWriter().write("{\"questions\":" + result + "}");

            } else if ("plan".equals(type)) {
                String hours = extractJson(body, "hours");
                String focus = extractJson(body, "focus");
                result = handlePlan(stream, context, hours, focus);
                res.getWriter().write("{\"plan\":" + result + "}");

            } else {
                res.getWriter().write("{\"error\":\"Unknown type\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            res.setStatus(500);
            res.getWriter().write("{\"error\":\"AI request failed: " + e.getMessage() + "\"}");
        }
    }

    // ══════════════════════════════
    // CHAT
    // ══════════════════════════════
    private String handleChat(String message, String context) throws IOException {
        String systemPrompt = "You are SetMyGoal AI, a helpful career guidance assistant for Indian students. " +
            "Student profile: " + context + ". " +
            "Give concise, practical, personalized advice in 3-5 sentences. " +
            "Focus on Indian education system, exams (NEET, JEE, UPSC, CA etc.), colleges, and career paths. " +
            "Be encouraging and specific to their profile. Use simple English.";

        String payload = "{"
            + "\"model\":\"" + MODEL + "\","
            + "\"messages\":["
            + "{\"role\":\"system\",\"content\":" + jsonStr(systemPrompt) + "},"
            + "{\"role\":\"user\",\"content\":" + jsonStr(message) + "}"
            + "],"
            + "\"max_tokens\":300,"
            + "\"temperature\":0.7"
            + "}";

        String response = callOpenAI(payload);
        return extractContent(response);
    }

    // ══════════════════════════════
    // QUIZ
    // ══════════════════════════════
    private String handleQuiz(String stream, String context) throws IOException {
        String prompt = "Generate 5 multiple choice quiz questions for an Indian student with this profile: " + context + ".\n" +
            "Focus on career stream: " + stream + ". Topics: entrance exams, eligibility, career scope, salary, top colleges.\n" +
            "Return ONLY a valid JSON array like this (no other text):\n" +
            "[\n" +
            "  {\n" +
            "    \"question\": \"What is the full form of NEET?\",\n" +
            "    \"options\": [\"National Eligibility cum Entrance Test\", \"National Engineering Entrance Test\", \"National Exam for Education Test\", \"None of these\"],\n" +
            "    \"correct\": 0,\n" +
            "    \"explanation\": \"NEET stands for National Eligibility cum Entrance Test conducted by NTA.\"\n" +
            "  }\n" +
            "]\n" +
            "Make questions relevant to " + stream + " career path. correct is 0-indexed. Return ONLY JSON array.";

        String payload = "{"
            + "\"model\":\"" + MODEL + "\","
            + "\"messages\":[{\"role\":\"user\",\"content\":" + jsonStr(prompt) + "}],"
            + "\"max_tokens\":1200,"
            + "\"temperature\":0.5"
            + "}";

        String response = callOpenAI(payload);
        String content = extractContent(response);

        // Extract JSON array from response
        int start = content.indexOf('[');
        int end   = content.lastIndexOf(']');
        if (start >= 0 && end > start) {
            return content.substring(start, end + 1);
        }
        return "[]";
    }

    // ══════════════════════════════
    // STUDY PLAN
    // ══════════════════════════════
    private String handlePlan(String stream, String context, String hours, String focus) throws IOException {
        String prompt = "Create a personalized 7-day study plan for an Indian student with this profile: " + context + ".\n" +
            "Career stream: " + stream + ". Daily study time: " + hours + " hours. Focus: " + focus + ".\n" +
            "Return ONLY a valid JSON array with 7 days like this (no other text):\n" +
            "[\n" +
            "  {\n" +
            "    \"day\": \"MON\",\n" +
            "    \"title\": \"Physics Basics\",\n" +
            "    \"description\": \"Cover NCERT Physics Ch 1-2. Focus on concepts not formulas.\",\n" +
            "    \"topics\": [\"Kinematics\", \"NCERT\", \"Notes\"],\n" +
            "    \"hours\": \"2 hours\"\n" +
            "  }\n" +
            "]\n" +
            "Make it specific to " + stream + " stream with realistic daily goals. Return ONLY JSON array.";

        String payload = "{"
            + "\"model\":\"" + MODEL + "\","
            + "\"messages\":[{\"role\":\"user\",\"content\":" + jsonStr(prompt) + "}],"
            + "\"max_tokens\":1500,"
            + "\"temperature\":0.6"
            + "}";

        String response = callOpenAI(payload);
        String content = extractContent(response);

        int start = content.indexOf('[');
        int end   = content.lastIndexOf(']');
        if (start >= 0 && end > start) {
            return content.substring(start, end + 1);
        }
        return "[]";
    }

    // ══════════════════════════════
    // HTTP call to OpenAI
    // ══════════════════════════════
    private String callOpenAI(String payload) throws IOException {
        URL url = new URL(OPENAI_URL);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("POST");
        con.setRequestProperty("Content-Type", "application/json");
        con.setRequestProperty("Authorization", "Bearer " + OPENAI_API_KEY);
        con.setDoOutput(true);
        con.setConnectTimeout(15000);
        con.setReadTimeout(30000);

        try (OutputStream os = con.getOutputStream()) {
            os.write(payload.getBytes(StandardCharsets.UTF_8));
        }

        int code = con.getResponseCode();
        InputStream is = (code == 200) ? con.getInputStream() : con.getErrorStream();

        StringBuilder resp = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            String line;
            while ((line = br.readLine()) != null) resp.append(line);
        }
        return resp.toString();
    }

    // ── Extract "content" field from OpenAI response ──
    private String extractContent(String json) {
        // finds: "content":"..."
        String marker = "\"content\":";
        int idx = json.lastIndexOf(marker);
        if (idx < 0) return "Sorry, could not process response.";
        int start = json.indexOf('"', idx + marker.length()) + 1;
        int end = start;
        while (end < json.length()) {
            if (json.charAt(end) == '"' && json.charAt(end-1) != '\\') break;
            end++;
        }
        return json.substring(start, end)
            .replace("\\n", "\n")
            .replace("\\\"", "\"")
            .replace("\\\\", "\\");
    }

    // ── Simple JSON string value extractor ──
    private String extractJson(String json, String key) {
        String search = "\"" + key + "\":\"";
        int idx = json.indexOf(search);
        if (idx < 0) return "";
        int start = idx + search.length();
        int end = start;
        while (end < json.length()) {
            if (json.charAt(end) == '"' && json.charAt(end-1) != '\\') break;
            end++;
        }
        return json.substring(start, end);
    }

    // ── Escape string for JSON ──
    private String jsonStr(String s) {
        return "\"" + s
            .replace("\\", "\\\\")
            .replace("\"", "\\\"")
            .replace("\n", "\\n")
            .replace("\r", "")
            .replace("\t", "\\t") + "\"";
    }
}