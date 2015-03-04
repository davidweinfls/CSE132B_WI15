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
                    "user=sendvt&password=postgres");
                
                // Create the statement
                Statement statement = conn.createStatement();

            %>
            
            <%-- -------- INSERT Code -------- --%>
            <%
                String action = request.getParameter("action");
                // Check if an insertion is requested
                if (action != null && action.equals("insert")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    pstmt = conn
                    .prepareStatement("INSERT INTO Course (course_name, unit_low, unit_high, letter_su, lab, title, consent_of_instructor, course_type, dept_name)" + 
                    " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");

                    //pstmt.setInt(1, Integer.parseInt(request.getParameter("course_id")));
                    pstmt.setString(1, request.getParameter("course_name"));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("unit_low")));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("unit_high")));
                    pstmt.setString(4, request.getParameter("letter_su"));
                    pstmt.setBoolean(5, Boolean.parseBoolean(request.getParameter("lab")));
                    pstmt.setString(6, request.getParameter("title"));
                    pstmt.setBoolean(7, Boolean.parseBoolean(request.getParameter("consent_of_instructor")));
                    pstmt.setString(8, request.getParameter("course_type"));
                    pstmt.setString(9, request.getParameter("dept_name"));
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    
                    action = null;
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
                        "consent_of_instructor = ?, course_type = ? WHERE course_id = ?");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("course_id")));
                    pstmt.setString(2, request.getParameter("course_name"));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("unit_low")));
                    pstmt.setInt(4, Integer.parseInt(request.getParameter("unit_high")));
                    pstmt.setString(5, request.getParameter("letter_su"));
                    pstmt.setBoolean(6, Boolean.parseBoolean(request.getParameter("lab")));
                    pstmt.setString(7, request.getParameter("title"));
                    pstmt.setBoolean(8, Boolean.parseBoolean(request.getParameter("consent_of_instructor")));
                    pstmt.setString(9, request.getParameter("course_type"));
                    pstmt.setInt(10, Integer.parseInt(request.getParameter("id")));
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    
                    action = null;
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
                    
                    action = null;
                }
            %>
            
            <%-- -------- Check Prereq Code -------- --%>
            <%
                if (action != null && action.equals("check")) {
                	int course_id = Integer.parseInt(request.getParameter("course_id"));
					String q1 = "SELECT c1.course_name cname, c2.course_name pname, c2.course_id p_id " + 
                	"FROM Prerequisite p, Course c1, Course c2 " + 
                "WHERE p.course_id = c1.course_id AND p.prerequisite_id = c2.course_id AND p.course_id = " + course_id;
					rs = statement.executeQuery(q1);
			%>
			
			<table border="2">
            <tr>
                <th>Course Name</th>
                <th>Prerequisite Name</th>
            </tr>
            
            <tr>
                <form action="Course.jsp" method="POST">
                    <input type="hidden" name="action" value="insert_prereq"/>
                    <th><input value="" name="course_name" size="10"/></th>
                    <th><input value="" name="prereq_name" size="10"/></th>
                    <th><input type="submit" value="Insert"/></th>
                </form>
            </tr>
			
			<%
				while (rs.next()) {
			%>
			<tr>
				<form>
					<input type="hidden" name="action" value="update_prereq"/>
                  	<input type="hidden" name="course_id" value="<%=course_id%>"/>
                  	<input type="hidden" name="old_p_id" value="<%=rs.getInt("p_id")%>"/>
					<td><%=rs.getString("cname")%></td>
					<td><input value=<%=rs.getString("pname")%> name="new_p_name" size="10"/></td>
					<td><input type="submit" value="Update"></td>
				</form>
				<form action="Course.jsp" method="POST">
					<input type="hidden" name="action" value="delete_prereq" /> 
					<input type="hidden" value="<%=course_id%>" name="course_id"/>
					<input type="hidden" name="pre_id" value="<%=rs.getInt("p_id")%>"/>
					<%-- Delete Button --%>
					<td><input type="submit" value="Delete" /></td>
				</form>
			</tr>
			<%			
					}
			%>
			</table>
			<%		
                }
            %>
            
            <%-- -------- INSERT Prereq Code -------- --%>
            <%
                if (action != null && action.equals("insert_prereq")) {
                	String course_name = request.getParameter("course_name");
                	String prereq_name = request.getParameter("prereq_name");
                	
                	String q1 = "SELECT course_id FROM Course WHERE course_name = '" + course_name + "'";
                	rs = statement.executeQuery(q1);
                	rs.next();
                	int course_id = rs.getInt("course_id");
                	
                	String q2 = "SELECT course_id FROM Course WHERE course_name = '" + prereq_name + "'";
                	rs = statement.executeQuery(q2);
                	rs.next();
                	int prereq_id = rs.getInt("course_id");
                	
                    // Begin transaction
                    conn.setAutoCommit(false);

                    pstmt = conn
                    .prepareStatement("INSERT INTO Prerequisite " + "VALUES (" + course_id + ", " + prereq_id + ")");
                    int rowCount = pstmt.executeUpdate();

                    if (rowCount > 0) {
                    	out.println("Prerequisite added!!!");
                    } else {
                    	out.println("<font color='#ff0000'>Add Prerequisite Failed!");
                    }
                    
                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>
            
            <%-- -------- UPDATE Prereq Code -------- --%>
            <%
                // Check if an update is requested
                if (action != null && action.equals("update_prereq")) {
                	int course_id = Integer.parseInt(request.getParameter("course_id"));
                	int old_prereq_id = Integer.parseInt(request.getParameter("old_p_id"));
                	String new_prereq_name = request.getParameter("new_p_name");
                	
                	// get new pre id
                	String q1 = "SELECT course_id FROM Course WHERE course_name = '" + new_prereq_name + "'";
                	rs = statement.executeQuery(q1);
                	rs.next();
                	int new_prereq_id = rs.getInt("course_id");
                	
                    // Begin transaction
                    conn.setAutoCommit(false);

                    pstmt = conn
                        .prepareStatement("UPDATE Prerequisite SET prerequisite_id = " + new_prereq_id + 
                        " WHERE course_id = " + course_id + " AND prerequisite_id = " + old_prereq_id);

                    int rowCount = pstmt.executeUpdate();

                    if (rowCount > 0) {
                    	out.println("Update Prerequisite Successfully!");
                    }
                    
                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>
            
            <%-- -------- DELETE Prereq Code -------- --%>
            <%
                // Check if a delete is requested
                if (action != null && action.equals("delete_prereq")) {
                	int course_id = Integer.parseInt(request.getParameter("course_id"));
                	int pre_id = Integer.parseInt(request.getParameter("pre_id"));
                	
                    conn.setAutoCommit(false);

                    pstmt = conn
                        .prepareStatement("DELETE FROM Prerequisite WHERE course_id = " + course_id + 
                        " AND prerequisite_id = " + pre_id);
                    int rowCount = pstmt.executeUpdate();
                    
                    if (rowCount > 0) {
                    	out.println("Delete Prerequisite Successfully!");
                    }

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>
            
            <%-- -------- SELECT Statement Code -------- --%>
            <%
            if (action == null) {
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
                <th>Course Type</th>
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
                    <th><input value="" name="course_type" size="5"/></th>
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
					<td><input value=<%=rs.getInt("course_id")%> name="course_id" size="5"/></td>
					<td><input value=<%=rs.getString("course_name")%> name="course_name" size="10"/></td>
					<td><input value=<%=rs.getInt("unit_low")%> name="unit_low" size="5"/></td>
					<td><input value=<%=rs.getInt("unit_high")%> name="unit_high" size="5"/></td>
					<td><input value=<%=rs.getString("letter_su")%> name="letter_su" size="5"/></td>
					<td><input value=<%=rs.getBoolean("lab")%> name="lab" size="5"/></td>
					<td><input value=<%=rs.getString("title")%> name="title" size="20"/></td>
					<td><input value=<%=rs.getBoolean("consent_of_instructor")%> name="consent_of_instructor" size="5"/></td>
					<td><input value=<%=rs.getString("course_type")%> name="course_type" size="15"/></td>
					<td><input value=<%=rs.getString("dept_name")%> name="dept_name" size="15"/></td>
					<!-- Update button -->
					<td><input type="submit" value="Update"></td>
				</form>
				<form action="Course.jsp" method="POST">
					<input type="hidden" name="action" value="delete" /> 
					<input type="hidden" value="<%=rs.getInt("course_id")%>" name="id"/>
					<%-- Delete Button --%>
					<td><input type="submit" value="Delete" /></td>
				</form>
				<form action="Course.jsp" method="POST">
					<input type="hidden" name="action" value="check" /> 
					<input type="hidden" value="<%=rs.getInt("course_id")%>" name="course_id"/>
					<td><input type="submit" value="Check Prereq" /></td>
				</form>
			</tr>
			<%
				}
            }
			%>

            <%-- -------- Close Connection Code -------- --%>
            <%
            	// Close the ResultSet
            		if (rs != null) 
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

<a href="Welcome.html">Back</a>

</body>
</html>
