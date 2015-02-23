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
            <%@ page import="java.util.*"%>
            <%-- -------- Open Connection Code -------- --%>
            <%
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            PreparedStatement pstmt1 = null;
            ResultSet rs = null;
            ResultSet rs1 = null;
            
            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/cse132b?" +
                    "user=sendvt&password=postgres");
            %>
            
            <%-- -------- Insert Code -------- --%>
            <%
                String action = request.getParameter("action");
         		// Create the statement
            	Statement statement = conn.createStatement();
            	Statement statement1 = conn.createStatement();
         		
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
            %>
            
            <table border="2">
            <form action="Student.jsp" method="POST">
            <input type="hidden" name="student_id" value="<%=request.getParameter("student_id")%>"/>
            <input type="hidden" name="action" value="check_type"/>
	            <tr>
	            <td>
	            <select name = "student_type_dropdown">
	            	<option value = "">Select</option>
	            	<option value="undergraduate">Undergraduate</option>
	            	<option value="graduate">Graduate</option>
	            </select>
	            </td>
	            <td><input type="submit" value="Submit"/></td>
	            </tr>
        	</form>
            </table>
                    
            <%        
                }
            %>
            
            <%-- -------- Check Type Code -------- --%>
            <%
                // Check if an update is requested
                if (action != null && action.equals("check_type")) {
                	int student_id = Integer.parseInt(request.getParameter("student_id"));
					String type = request.getParameter("student_type_dropdown");
					// get dept list
					rs1 = statement1.executeQuery("SELECT dept_name FROM Department");
	                ArrayList<String> dept_names = new ArrayList<String>();
	                while (rs1.next()) {
	                	dept_names.add(rs1.getString("dept_name"));
	                }
					
					if (type.equals("undergraduate")) {
			%>			
				<table border="2">
				<tr>
                <th>Major</th>
                <th>Minor</th>
                <th>College</th>
            	</tr>
				
	            <form action="Student.jsp" method="POST">
	            <input type="hidden" name="action" value="insert_undergrad"/>
	            <input type="hidden" name="student_id" value="<%=student_id%>"/>
		          <tr>
		            <td> 
                    <select name = "major_dropdown">
                    <option value = "">Select Department</option>
                    	<% for (int i = 0; i < dept_names.size(); ++i) { %>
                    		<option value=<%= dept_names.get(i)%>><%= dept_names.get(i)%></option>
                    	<% } %>
                    </select>
                    </td>
                    <td> 
                    <select name = "minor_dropdown">
                    <option value = "">Select Department</option>
                    	<% for (int i = 0; i < dept_names.size(); ++i) { %>
                    		<option value=<%= dept_names.get(i)%>><%= dept_names.get(i)%></option>
                    	<% } %>
                    </select>
                    </td>
                    <td><input value="" name="college" size="10"/></td>
		            <td><input type="submit" value="Confirm"/></td>
		          </tr>
	        	</form>
	            </table>
			<%			
					} else if (type.equals("graduate")) {
			%>
				<table border="2">
				<tr>
                	<th>Department</th>
                	<th>Is_Phd</th>
            	</tr>
				
	            <form action="Student.jsp" method="POST">
	            <input type="hidden" name="action" value="insert_grad"/>
	            <input type="hidden" name="student_id" value="<%=student_id%>"/>
		          <tr>
		            <td> 
                    <select name = "dept_dropdown">
	                    <option value = "">Select Department</option>
	                    	<% for (int i = 0; i < dept_names.size(); ++i) { %>
	                    		<option value=<%= dept_names.get(i)%>><%= dept_names.get(i)%></option>
	                    	<% } %>
                    </select>
                    </td>
                    <td>
                    <select name = "phd_dropdown">
	                    <option value="false">Select</option>
	                    <option value="true">Yes</option>
	                    <option value="false">No</option>
                    </select>
                    </td>
		            <td><input type="submit" value="Confirm"/></td>
		          </tr>
	        	</form>
	            </table>
			<%			
					}
                }
            %>
            
            <%-- -------- Insert Undergrad Code -------- --%>
            <%
            if (action != null && action.equals("insert_undergrad")) {
            	int student_id = Integer.parseInt(request.getParameter("student_id"));
            	String major = request.getParameter("major_dropdown");
            	String minor = request.getParameter("minor_dropdown");
            	String college = request.getParameter("college");
                // Begin transaction
                conn.setAutoCommit(false);

                // Create the prepared statement and use it to
                // INSERT student values INTO the students table.
                pstmt = conn
                .prepareStatement("INSERT INTO Undergraduate VALUES (?, ?, ?, ?)");

                pstmt.setInt(1, student_id);
                pstmt.setString(2, college);
                pstmt.setString(3, major);
                pstmt.setString(4, minor);
                int rowCount = pstmt.executeUpdate();

                // Commit transaction
                conn.commit();
                conn.setAutoCommit(true);
                
                if (rowCount > 0) {
                	out.println("Success - inserted into undergraduate table");
                } else {
                	out.println("<font color='#ff0000'>Error - cannot insert into undergraduate table");
                }
            %>
            
            <%        
            }
            %>
            
            <%-- -------- Insert Graduate Code -------- --%>
            <%
            if (action != null && action.equals("insert_grad")) {
            	int student_id = Integer.parseInt(request.getParameter("student_id"));
            	String dept = request.getParameter("dept_dropdown");
            	String is_phd = request.getParameter("phd_dropdown");
                

                if (is_phd.equals("false")) {
	                // Begin transaction
	                conn.setAutoCommit(false);
	                
	                pstmt = conn.prepareStatement("INSERT INTO Graduate VALUES (?, ?)");
	                pstmt.setInt(1, student_id);
	                pstmt.setString(2, dept);
	                int rowCount = pstmt.executeUpdate();
	
	                pstmt1 = conn.prepareStatement("INSERT INTO Master (master_id) VALUES (?)");
	    	        pstmt1.setInt(1, student_id);
	    	        int rowCount1 = pstmt1.executeUpdate();
	                
	                // Commit transaction
	                conn.commit();
	                conn.setAutoCommit(true);
	                
	                if (rowCount > 0 && rowCount1 > 0) {
	                	out.println("Success - inserted into graduate and master table");
	                } else {
	                	out.println("<font color='#ff0000'>Error - cannot insert into graduate/master table");
	                }
                } else {
            %>
            <table border="2">
				<tr>
                	<th>Candidacy</th>
            	</tr>
				
	            <form action="Student.jsp" method="POST">
	            <input type="hidden" name="action" value="insert_phd"/>
	            <input type="hidden" name="student_id" value="<%=student_id%>"/>
	            <input type="hidden" name="dept" value="<%=dept%>"/>
		          <tr>
		            <td> 
                    <select name = "candidacy_dropdown">
	                    <option value="false">Select</option>
	                    <option value="true">Yes</option>
	                    <option value="false">No</option>
                    </select>
                    </td>
		            <td><input type="submit" value="Confirm"/></td>
		          </tr>
	        	</form>
	            </table>
            <%    	
                }
            %>
            
            <%        
            }
            %>
            
            <%-- -------- Insert Phd Code -------- --%>
            <%
            if (action != null && action.equals("insert_phd")) {
            	int student_id = Integer.parseInt(request.getParameter("student_id"));
            	Boolean candidacy = Boolean.parseBoolean(request.getParameter("candidacy_dropdown"));
            	String dept = request.getParameter("dept");

            	conn.setAutoCommit(false);

                pstmt = conn.prepareStatement("INSERT INTO Graduate VALUES (?, ?)");
	            pstmt.setInt(1, student_id);
	            pstmt.setString(2, dept);
	            int rowCount = pstmt.executeUpdate();
	            
	            pstmt1 = conn.prepareStatement("INSERT INTO Phd VALUES (?, ?)");
    	        pstmt1.setInt(1, student_id);
    	        pstmt1.setBoolean(2, candidacy);
    	        int rowCount1 = pstmt1.executeUpdate();

                // Commit transaction
                conn.commit();
                conn.setAutoCommit(true);
                
                if (rowCount > 0) {
                	out.println("Success - inserted into graduate and phd table");
                } else {
                	out.println("<font color='#ff0000'>Error - cannot insert into graduate/phd table");
                }
            %>
            
            <%        
            }
            %>
            
            <%-- -------- UPDATE Code -------- --%>
            <%
                // Check if an update is requested
                if (action != null && action.equals("update")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    // UPDATE student values in the Students table.
                    pstmt = conn
                        .prepareStatement("UPDATE Student SET student_id = ?, first = ?, "
                            + "middle = ?, last = ?, ssn = ?, enrollment = ?, residency = ?, " + 
                        "five_year_program = ? WHERE student_id = ?");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("student_id")));
                    pstmt.setString(2, request.getParameter("first"));
                    pstmt.setString(3, request.getParameter("middle"));
                    pstmt.setString(4, request.getParameter("last"));
                    pstmt.setString(5, request.getParameter("ssn"));
                    pstmt.setBoolean(6, Boolean.parseBoolean(request.getParameter("enrollment")));
                    pstmt.setString(7, request.getParameter("residency"));
                    pstmt.setBoolean(8, Boolean.parseBoolean(request.getParameter("five_year_program")));
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

                    // Create the prepared statement and use it to
                    // DELETE students FROM the Students table.
                    pstmt = conn
                        .prepareStatement("DELETE FROM Student WHERE student_id = ?");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    
                    if (rowCount > 0) {
                    	out.println("Success - Delete student");
                    } else {
                    	out.println("<font color='#ff0000'>Error - cannot delete this student");
                    }
                }
            %>
            
            <%-- -------- SELECT Statement Code -------- --%>
            <%
            if (action == null) {
                

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
                    <th><input value="" name="five_year_program" size="5"/></th>
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
				<form action="Student.jsp" method="POST">
					<input type="hidden" name="action" value="delete" /> 
					<input type="hidden" value="<%=rs.getInt("student_id")%>" name="id"/>
					<%-- Delete Button --%>
					<td><input type="submit" value="Delete" /></td>
				</form>
			</tr>
			<%
				}
            }
			%>

            <%-- -------- Close Connection Code -------- --%>
            <%
            	// Close the ResultSet
            		if (rs != null) rs.close();

            		// Close the Statement
            		if (statement != null) statement.close();

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

<a href="Welcome.html">Back</a>

</body>
</html>
