<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Student Page</title>
</head>
<body>

<h2>Student Entry Form</h2>
<table>
    <tr>
        <td valign="top">
            <%-- -------- Include menu HTML code -------- --%>
            <%-- <jsp:include page="/hearder.html" /> --%>
        </td>
        <td>
            <%-- Import the java.sql package --%>
            <%@ page import="java.sql.*"%>
            <%-- -------- Open Connection Code -------- --%>
            <%
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/cse132b?" +
                    "user=postgres&password=postgres");
            %>
            
            <%-- -------- SELECT Statement Code -------- --%>
            <%
                // Create the statement
                Statement statement = conn.createStatement();

                // Use the created statement to SELECT
                // the student attributes FROM the Student table.
                rs = statement.executeQuery("SELECT * FROM Student");
            %>
            
            <!-- Add an HTML table header row to format the results -->
            <table border="2">
            <tr>
                <th>Student_ID</th>
                <th>First Name</th>
                <th>MIddle Name</th>
                <th>Last Name</th>
                <th>SSN</th>
                <th>Enrollment</th>
                <th>Residency</th>
                <th>Five-year program</th>
            </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>

            <tr>
                <%-- Get the student_id --%>
                <td>
                    <%=rs.getInt("student_id")%>
                </td>

                <%-- Get the first name --%>
                <td>
                    <%=rs.getString("first")%>
                </td>

                <%-- Get the middle name --%>
                <td>
                    <%=rs.getString("middle")%>
                </td>

                <%-- Get the last name --%>
                <td>
                    <%=rs.getString("last")%>
                </td>

                <%-- Get the ssn --%>
                <td>
                    <%=rs.getString("ssn")%>
                </td>
                
                <%-- Get the enrollment --%>
                <td>
                    <%=rs.getBoolean("enrollment")%>
                </td>
                
                <%-- Get the residency --%>
                <td>
                    <%=rs.getString("residency")%>
                </td>
                
                <%-- Get the 5-year program --%>
                <td>
                    <%=rs.getBoolean("five_year_program")%>
                </td>
            </tr>
            <%
                }
            %>

            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                rs.close();

                // Close the Statement
                statement.close();

                // Close the Connection
                conn.close();
            } catch (SQLException e) {

                // Wrap the SQL exception in a runtime exception to propagate
                // it upwards
                throw new RuntimeException(e);
            }
            finally {
                // Release resources in a finally block in reverse-order of
                // their creation

                if (rs != null) {
                    try {
                        rs.close();
                    } catch (SQLException e) { } // Ignore
                    rs = null;
                }
                if (pstmt != null) {
                    try {
                        pstmt.close();
                    } catch (SQLException e) { } // Ignore
                    pstmt = null;
                }
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) { } // Ignore
                    conn = null;
                }
            }
            %>
        </table>
        </td>
    </tr>
</table>


</body>
</html>
