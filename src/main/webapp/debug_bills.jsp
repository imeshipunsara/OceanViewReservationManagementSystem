<%@ page import="java.sql.*" %>
    <%@ page import="com.oceanview.util.DBConnection" %>
        <%@ page import="com.oceanview.dao.BillDAO" %>
            <%@ page import="com.oceanview.model.Bill" %>
                <%@ page import="java.util.List" %>
                    <!DOCTYPE html>
                    <html>

                    <head>
                        <title>Debug Bills</title>
                    </head>

                    <body>
                        <h2>Database Connectivity Check</h2>
                        <pre>
<%
    try (Connection conn = DBConnection.getConnection()) {
        out.println("Database connection successful.");
        
        // Check columns in billing table
        DatabaseMetaData md = conn.getMetaData();
        ResultSet rs = md.getColumns(null, null, "billing", null);
        out.println("\nColumns in 'billing' table:");
        while (rs.next()) {
            out.println("- " + rs.getString("COLUMN_NAME") + " (" + rs.getString("TYPE_NAME") + ")");
        }
    } catch (Exception e) {
        out.println("Database connection failed: " + e.getMessage());
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>
    </pre>

                        <h2>BillDAO.getAllBills() Check</h2>
                        <pre>
<%
    try {
        BillDAO dao = new BillDAO();
        List<Bill> bills = dao.getAllBills();
        out.println("\nCalling getAllBills()...");
        if (bills == null) {
            out.println("Result is NULL");
        } else {
            out.println("Result size: " + bills.size());
            for (Bill b : bills) {
                out.println("Bill ID: " + b.getBillId() + ", Total: " + b.getTotalAmount());
            }
        }
    } catch (Exception e) {
        out.println("BillDAO execution failed: " + e.getMessage());
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>
    </pre>
                    </body>

                    </html>