<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Faculty Page</title>
</head>
<body>

<h2>Faculty Entry Form</h2>
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
                    .prepareStatement("INSERT INTO Faculty (ssn, title, first, last, dept_name)" + 
                    " VALUES (?, ?, ?, ?, ?)");

                    pstmt.setString(1, request.getParameter("ssn"));
                    String title = request.getParameter("title_dropdown");
                    if (title != null) {
                    	pstmt.setString(2, title);
                    }
                    else {
						// output error message to page;
						// return
                    }
                    pstmt.setString(3, request.getParameter("first"));
                    pstmt.setString(4, request.getParameter("last"));
                    String dept = request.getParameter("dept_dropdown");
                    if (title != null) {
                    	pstmt.setString(5, dept);
                    }
                    else {
						// output error message to page;
						// return
                    }
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
                        .prepareStatement("UPDATE Faculty SET ssn = ?, title = ?, "
                            + "first = ?, last = ?, dept_name = ? WHERE ssn = ?");

                    pstmt.setString(1, request.getParameter("ssn"));
                    String title = request.getParameter("title_dropdown");
                    if (title != null) {
                    	pstmt.setString(2, title);
                    }
                    else {
						// output error message to page;
						// return
                    }
                    pstmt.setString(3, request.getParameter("first"));
                    pstmt.setString(4, request.getParameter("last"));
                    String dept = request.getParameter("dept_dropdown");
                    if (title != null) {
                    	pstmt.setString(5, dept);
                    }
                    else {
						// output error message to page;
						// return
                    }
                    pstmt.setString(6, request.getParameter("id"));
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
                        .prepareStatement("DELETE FROM Faculty WHERE ssn = ?");

                    pstmt.setString(1, request.getParameter("id"));
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
                rs = statement.executeQuery("SELECT * FROM Faculty");
                rs1 = statement1.executeQuery("SELECT dept_name FROM Department");
                ArrayList<String> dept_names = new ArrayList<String>();
                while (rs1.next()) {
                	dept_names.add(rs1.getString("dept_name"));
                }
            %>
            
            <!-- Add an HTML table header row to format the results -->
            <table border="2">
            <tr>
                <th>SSN (xxx-xx-xxxx)</th>
                <th>Title</th>
                <th>First Name</th>
                <th>Last Name</th>
                <th>Department</th>
            </tr>
            
            <!-- An empty row with blankets for user to type in -->
            <tr>
                <form action="Faculty.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <th><input value="" name="ssn" size="15"/></th>
                    <th> 
                    <select name = "title_dropdown">
                    <option value = "">Select Title</option>
                    	<option value="Professor">Professor</option>
                    	<option value="Assistant_Professor">Assistant_Professor</option>
                    	<option value="Associated_Professor">Associated_Professor</option>
                    	<option value="Lecturer">Lecturer</option>
                    </select>
                    </th>
                    <th><input value="" name="first" size="10"/></th>
                    <th><input value="" name="last" size="10"/></th>
                    <th> 
                    <select name = "dept_dropdown">
                    <option value = "">Select Department</option>
                    	<% for (int i = 0; i < dept_names.size(); ++i) { %>
                    		<option value=<%= dept_names.get(i)%>><%= dept_names.get(i)%></option>
                    	<% } %>
                    </select>
                    </th>
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
                  		<input type="hidden" name="id" value="<%=rs.getString("ssn")%>"/>
					<td><input value=<%=rs.getString("ssn")%> name="ssn" size="15"/></td>
					<td> 
                    <select name = "title_dropdown">
                    <option value = <%=rs.getString("title")%>><%=rs.getString("title")%></option>
                    	<option value="Professor">Professor</option>
                    	<option value="Assistant_Professor">Assistant_Professor</option>
                    	<option value="Associated_Professor">Associated_Professor</option>
                    	<option value="Lecturer">Lecturer</option>
                    </select>
                    </td>
                    <td><input value=<%=rs.getString("first")%> name="first" size="10"/></td>
                    <td><input value=<%=rs.getString("last")%> name="last" size="10"/></td>
					<td>
					<select name = "dept_dropdown">
                    <option value = <%=rs.getString("dept_name")%>><%=rs.getString("dept_name")%></option>
                    <% for (int i = 0; i < dept_names.size(); ++i) { %>
                    	<option value=<%= dept_names.get(i)%>><%= dept_names.get(i)%></option>
                    <% } %>
                    </select>
                    </td>
					<!-- Update button -->
					<td><input type="submit" value="Update"></td>
				</form>
				<form action="Faculty.jsp" method="POST">
					<input type="hidden" name="action" value="delete" /> 
					<input type="hidden" value="<%=rs.getString("ssn")%>" name="id"/>
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


</body>
</html>
