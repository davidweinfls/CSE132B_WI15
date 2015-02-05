<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Course Page</title>
</head>
<body>

<h2>Course Entry Form</h2>
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

                    pstmt = conn
                    .prepareStatement("INSERT INTO Course (course_name, unit_low, unit_high, letter_su, lab, title, consent_of_instructor, dept_name)" + 
                    " VALUES (?, ?, ?, ?, ?, ?, ?, ?)");

                    //pstmt.setInt(1, Integer.parseInt(request.getParameter("course_id")));
                    pstmt.setString(1, request.getParameter("course_name"));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("unit_low")));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("unit_high")));
                    pstmt.setString(4, request.getParameter("letter_su"));
                    pstmt.setBoolean(5, Boolean.parseBoolean(request.getParameter("lab")));
                    pstmt.setString(6, request.getParameter("title"));
                    pstmt.setBoolean(7, Boolean.parseBoolean(request.getParameter("consent_of_instructor")));
                    pstmt.setString(8, request.getParameter("dept_name"));
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>
            
            <%-- -------- UPDATE Code -------- --%>
            <%
                // Check if an update is requested
                if (action != null && action.equals("update")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    pstmt = conn
                        .prepareStatement("UPDATE Course SET course_id = ?, course_name = ?, "
                            + "unit_low = ?, unit_high = ?, letter_su = ?, lab = ?, title = ?, " + 
                        "consent_of_instructor = ? WHERE course_id = ?");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("course_id")));
                    pstmt.setString(2, request.getParameter("course_name"));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("unit_low")));
                    pstmt.setInt(4, Integer.parseInt(request.getParameter("unit_high")));
                    pstmt.setString(5, request.getParameter("letter_su"));
                    pstmt.setBoolean(6, Boolean.parseBoolean(request.getParameter("lab")));
                    pstmt.setString(7, request.getParameter("title"));
                    pstmt.setBoolean(8, Boolean.parseBoolean(request.getParameter("consent_of_instructor")));
                    pstmt.setString(9, request.getParameter("dept_name"));
                    pstmt.setInt(9, Integer.parseInt(request.getParameter("id")));
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>
            
            <%-- -------- DELETE Code -------- --%>
            <%
                // Check if a delete is requested
                if (action != null && action.equals("delete")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    pstmt = conn
                        .prepareStatement("DELETE FROM Course WHERE course_id = ?");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
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
                rs = statement.executeQuery("SELECT * FROM Course");
                
            %>
            
            <!-- Add an HTML table header row to format the results -->
            <table border="2">
            <tr>
                <th>Course_ID</th>
                <th>Course Name</th>
                <th>Minimum Unit</th>
                <th>Maximum Unit</th>
                <th>Grade Option</th>
                <th>Lab</th>
                <th>Title</th>
                <th>Consent of Instructor</th>
                <th>Department</th>
            </tr>
            
            <!-- An empty row with blankets for user to type in -->
            <tr>
                <form action="Course.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <th>&nbsp;</th>
                    <th><input value="" name="course_name" size="10"/></th>
                    <th><input value="" name="unit_low" size="5"/></th>
                    <th><input value="" name="unit_high" size="5"/></th>
                    <th><input value="" name="letter_su" size="5"/></th>
                    <th><input value="" name="lab" size="5"/></th>
                    <th><input value="" name="title" size="10"/></th>
                    <th><input value="" name="consent_of_instructor" size="5"/></th>
                    <th><input value="" name="dept_name" size="10"/></th>
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
                  		<input type="hidden" name="id" value="<%=rs.getInt("course_id")%>"/>
					<%-- Get the student_id --%>
					<td><input value=<%=rs.getInt("course_id")%> name="course_id" size="5"/></td>
					<td><input value=<%=rs.getString("course_name")%> name="course_name" size="10"/></td>
					<td><input value=<%=rs.getInt("unit_low")%> name="unit_low" size="5"/></td>
					<td><input value=<%=rs.getInt("unit_high")%> name="unit_high" size="5"/></td>
					<td><input value=<%=rs.getString("letter_su")%> name="letter_su" size="5"/></td>
					<td><input value=<%=rs.getBoolean("lab")%> name="lab" size="5"/></td>
					<td><input value=<%=rs.getString("title")%> name="title" size="10"/></td>
					<td><input value=<%=rs.getBoolean("consent_of_instructor")%> name="consent_of_instructor" size="5"/></td>
					<td><input value=<%=rs.getString("dept_name")%> name="dept_name" size="20"/></td>
					<!-- Update button -->
					<td><input type="submit" value="Update"></td>
				</form>
				<form action="Course.jsp" method="POST">
					<input type="hidden" name="action" value="delete" /> 
					<input type="hidden" value="<%=rs.getInt("course_id")%>" name="id"/>
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
