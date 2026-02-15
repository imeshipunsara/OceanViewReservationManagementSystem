<%@ page import="java.sql.*" %>
    <%@ page import="com.oceanview.util.DBConnection" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Fix Billing Table</title>
        </head>

        <body>
            <h2>Applying Billing Table Patch...</h2>
            <pre>
<%
    try (Connection conn = DBConnection.getConnection();
         Statement stmt = conn.createStatement()) {

        // Add bill_date column
        try {
            stmt.executeUpdate("ALTER TABLE billing ADD COLUMN bill_date DATETIME DEFAULT CURRENT_TIMESTAMP");
            out.println("SUCCESS: Added 'bill_date' column.");
        } catch (SQLException e) {
            out.println("INFO: 'bill_date' column might already exist or error: " + e.getMessage());
        }

    } catch (Exception e) {
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>
    </pre>
            <br>
            <a href="bills.jsp">Go to Bills Page</a>
        </body>

        </html>