<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Course Enrollment Page</title>
</head>
<body>

<h2>Course Enrollment Form</h2>
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
            
            <%
            	Statement statement = conn.createStatement();
            	Statement statement1 = conn.createStatement();
            %>
            
            <%-- -------- add_to_class -------- --%>
            <%
                String action = request.getParameter("action");
            	
                // Check if an insertion is requested
                if (action != null && action.equals("add_to_class")) {
                	String class_name = request.getParameter("course_dropdown");
                	rs = statement.executeQuery("SELECT * FROM Class WHERE class_name = '" + class_name + "'" + 
                			" AND quarter = 'Winter' AND year = 2015");
                	// open a new class if not exists
                	if (!rs.next()) {
                		String query = "INSERT INTO Class (class_name, quarter, year) " + 
								"VALUES ('" + class_name + "', 'Winter', 2015)";
                		System.out.println("insert into Class: " + query);
                		pstmt = conn.prepareStatement(query);
                		int rowCount = pstmt.executeUpdate();
                	}
                	
                	// Begin transaction
                    conn.setAutoCommit(false);
                	
                	// add relationship to Student_Class table
                	String select_query = "Select class_id FROM Class WHERE class_name = '" + class_name + "'" + 
                							" AND quarter = 'Winter' AND year = 2015";
                	rs = statement.executeQuery(select_query);
                	rs.next();
                	int class_id = rs.getInt("class_id");
                	int student_id = Integer.parseInt(request.getParameter("student_id"));
                	String query = "INSERT INTO Student_Class VALUES (" + student_id + ", " + class_id + ", " + "'WIP'" + ")";
                	System.out.println("insert into Student_Class: " + query);
                	pstmt = conn.prepareStatement(query);
                	int rowCount = pstmt.executeUpdate();
                	if (rowCount > 0) {
              %>
	              		<form action="Course_Enrollment.jsp" method="POST">
	                        <input type="hidden" name="action" value="choose_section"/>
	                        <th><input type="submit" value="Choose Section"/></th>
		                </form>
		     		<% } %>   
		             
            <%
                	// Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>
            
            <%-- -------- Choose Section -------- --%>
            <%
            	if (action != null && action.equals("choose_section")) {
            		out.println("lalala");
            	}
            %>
            
            <%-- -------- Original Form -------- --%>
            <%            
            	if (action == null) {
	                rs1 = statement1.executeQuery("SELECT distinct course_name FROM Course");
	                ArrayList<String> course_names = new ArrayList<String>();
	                while (rs1.next()) {
	                	course_names.add(rs1.getString("course_name"));
	                }
	       	%>
	                <table border="2">
	                <tr>
	                    <th>Student_ID</th>
	                    <th>Course_Name</th>
	                </tr>
	                
	                <!-- An empty row with blankets for user to type in -->
	                <tr>
	                    <form action="Course_Enrollment.jsp" method="POST">
	                        <input type="hidden" name="action" value="add_to_class"/>
	                        <th><input value="" name="student_id" size="15"/></th>
	                        <th>
	                        <select name = "course_dropdown">
	                        <option value = "">Select Course</option>
	                        	<% for (int i = 0; i < course_names.size(); ++i) { %>
	                        		<option value=<%= course_names.get(i)%>><%= course_names.get(i)%></option>
	                        	<% } %>
	                        </select>
	                        </th>
	                        <th><input type="submit" value="Add to Course"/></th>
	                    </form>
	                </tr>
	        <% } // end of original form %>

            <%-- -------- Close Connection Code -------- --%>
            <%
            	// Close the ResultSet
            	if (rs != null) rs.close();
            	if (rs1 != null) rs1.close();

            		// Close the Statement
            		if (statement != null)
            			statement.close();
            		if (statement1 != null)
            			statement1.close();

            		// Close the Connection
            		conn.close();
            	} catch (SQLException e) {

            		// Wrap the SQL exception in a runtime exception to propagate
            		// it upwards
            		out.println("<font color='#ff0000'>Add Course Error");
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
<a href="Course_Enrollment.jsp">Refresh</a>

</body>
</html>
