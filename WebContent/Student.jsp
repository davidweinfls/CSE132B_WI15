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
            
            <%-- -------- INSERT Code -------- --%>
            <%
                String action = request.getParameter("action");
                // Check if an insertion is requested
                if (action != null && action.equals("insert")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    // INSERT student values INTO the students table.
                    pstmt = conn
                    .prepareStatement("INSERT INTO Student (student_id, first, middle, last, ssn, enrollment, residency, five_year_program)" + 
                    " VALUES (?, ?, ?, ?, ?, ?, ?, ?)");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("student_id")));
                    pstmt.setString(2, request.getParameter("first"));
                    pstmt.setString(3, request.getParameter("middle"));
                    pstmt.setString(4, request.getParameter("last"));
                    pstmt.setString(5, request.getParameter("ssn"));
                    pstmt.setBoolean(6, Boolean.parseBoolean(request.getParameter("enrollment")));
                    pstmt.setString(7, request.getParameter("residency"));
                    pstmt.setBoolean(8, Boolean.parseBoolean(request.getParameter("five_year_program")));
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
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
                <th>Middle Name</th>
                <th>Last Name</th>
                <th>SSN</th>
                <th>Enrollment</th>
                <th>Residency</th>
                <th>Five-year program</th>
            </tr>
            
            <!-- An empty row with blankets for user to type in -->
            <tr>
                <form action="Student.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <th><input value="" name="student_id" size="10"/></th>
                    <th><input value="" name="first" size="10"/></th>
                    <th><input value="" name="middle" size="10"/></th>
                    <th><input value="" name="last" size="10"/></th>
                    <th><input value="" name="ssn" size="10"/></th>
                    <th><input value="" name="enrollment" size="5"/></th>
                    <th><input value="" name="residency" size="5"/></th>
                    <th><input value="" name="lfive_year_program" size="5"/></th>
                    <th><input type="submit" value="Insert"/></th>
                </form>
            </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>
			<tr>
				<form>
					<input type="hidden" name="action" value="update"/>
                  		<input type="hidden" name="id" value="<%=rs.getInt("student_id")%>"/>
					<%-- Get the student_id --%>
					<td><input value=<%=rs.getInt("student_id")%> name="student_id" size="10"/></td>
					<%-- Get the first name --%>
					<td><input value=<%=rs.getString("first")%> name="first" size="10"/></td>
					<%-- Get the middle name --%>
					<td><input value=<%=rs.getString("middle")%> name="middle" size="10"/></td>
					<%-- Get the last name --%>
					<td><input value=<%=rs.getString("last")%> name="last" size="10"/></td>
					<%-- Get the ssn --%>
					<td><input value=<%=rs.getString("ssn")%> name="ssn" size="10"/></td>
					<%-- Get the enrollment --%>
					<td><input value=<%=rs.getBoolean("enrollment")%> name="enrollment" size="5"/></td>
					<%-- Get the residency --%>
					<td><input value=<%=rs.getString("residency")%> name="residency" size="5"/></td>
					<%-- Get the 5-year program --%>
					<td><input value=<%=rs.getBoolean("five_year_program")%> name="five_year_program" size="5"/></td>
					<!-- Update button -->
					<td><input type="submit" value="Update"></td>
				</form>
				<form action="attempt3/students.jsp" method="POST">
					<input type="hidden" name="action" value="delete" /> 
					<input type="hidden" value="<%=rs.getInt("student_id")%>" name="id"/>
					<%-- Delete Button --%>
					<td><input type="submit" value="Delete" /></td>
				</form>
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
            	} finally {
            		// Release resources in a finally block in reverse-order of
            		// their creation

            		if (rs != null) {
            			try {
            				rs.close();
            			} catch (SQLException e) {
            			} // Ignore
            			rs = null;
            		}
            		if (pstmt != null) {
            			try {
            				pstmt.close();
            			} catch (SQLException e) {
            			} // Ignore
            			pstmt = null;
            		}
            		if (conn != null) {
            			try {
            				conn.close();
            			} catch (SQLException e) {
            			} // Ignore
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
