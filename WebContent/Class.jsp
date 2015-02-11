<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Class Page</title>
</head>
<body>

<h2>Class Entry Form</h2>
<table>
    <tr>
        <td valign="top">
            <%-- -------- Include menu HTML code -------- --%>
            <%-- <jsp:include page="/hearder.html" /> --%>
        </td>
        <td>
            <%-- Import the java.sql package --%>
            <%@ page import="java.sql.*"%>
            <%@ page import="java.util.*"%>
            <%-- -------- Open Connection Code -------- --%>
            <%
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            ResultSet rs1 = null;
            
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
                    .prepareStatement("INSERT INTO Class (class_name, quarter, year)" + 
                    " VALUES (?, ?, ?)");

                    String name = request.getParameter("dropdown");
                    if (name != null) {
                    	pstmt.setString(1, request.getParameter("dropdown"));
                    }
                    else {
						// output error message to page;
						// return
                    }
                    pstmt.setString(2, request.getParameter("quarter"));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("year")));
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
                        .prepareStatement("UPDATE Class SET class_name = ?, quarter = ?, "
                            + "year = ? WHERE class_id = ?");

                    String name = request.getParameter("dropdown");
                    if (name != null) {
                    	pstmt.setString(1, request.getParameter("dropdown"));
                    }
                    else {
						// output error message to page;
						// return
                    }
                    pstmt.setString(2, request.getParameter("quarter"));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("year")));
                    pstmt.setInt(4, Integer.parseInt(request.getParameter("id")));
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
                        .prepareStatement("DELETE FROM Class WHERE class_id = ?");

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
            	Statement statement1 = conn.createStatement();

                // Use the created statement to SELECT
                // the student attributes FROM the Student table.
                rs = statement.executeQuery("SELECT * FROM Class");
                rs1 = statement1.executeQuery("SELECT course_name FROM Course");
                ArrayList<String> course_names = new ArrayList<String>();
                while (rs1.next()) {
                	course_names.add(rs1.getString("course_name"));
                }
            %>
            
            <!-- Add an HTML table header row to format the results -->
            <table border="2">
            <tr>
                <th>Class_ID</th>
                <th>Class Name</th>
                <th>Quarter</th>
                <th>Year</th>
            </tr>
            
            <!-- An empty row with blankets for user to type in -->
            <tr>
                <form action="Class.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <th>&nbsp;</th>
                    <th> 
                    <select name = "dropdown">
                    <option value = "">Select Course</option>
                    <% for (int i = 0; i < course_names.size(); ++i) { %>
                    	<option value=<%= course_names.get(i)%>><%= course_names.get(i)%></option>
                    <% } %>
                    </select>
                    </th>
                    <th><input value="" name="quarter" size="5"/></th>
                    <th><input value="" name="year" size="5"/></th>
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
                  		<input type="hidden" name="id" value="<%=rs.getInt("class_id")%>"/>
					<td><input value=<%=rs.getInt("class_id")%> name="class_id" size="5"/></td>
					<td>
					<select name = "dropdown">
                    <option value = <%=rs.getString("class_name")%>><%=rs.getString("class_name")%></option>
                    <% for (int i = 0; i < course_names.size(); ++i) { %>
                    	<option value=<%= course_names.get(i)%>><%= course_names.get(i)%></option>
                    <% } %>
                    </select>
                    </td>
					<td><input value=<%=rs.getString("quarter")%> name="quarter" size="5"/></td>
					<td><input value=<%=rs.getInt("year")%> name="year" size="5"/></td>
					<!-- Update button -->
					<td><input type="submit" value="Update"></td>
				</form>
				<form action="Class.jsp" method="POST">
					<input type="hidden" name="action" value="delete" /> 
					<input type="hidden" value="<%=rs.getInt("class_id")%>" name="id"/>
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
            		rs1.close();

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
            		if (rs1 != null) {
            			try {
            				rs1.close();
            			} catch (SQLException e) {
            			} // Ignore
            			rs1 = null;
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

<a href="Welcome.html">Back</a>

</body>
</html>
