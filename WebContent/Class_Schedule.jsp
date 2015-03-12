<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Class Schedule Page</title>
</head>
<body>

<h2>Class Schedule Form</h2>
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
          PreparedStatement pstmt2 = null;
          PreparedStatement pstmt3 = null;
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
          	String action = request.getParameter("action");
          %>
          
          <%-- -------- Original Form -------- --%>
          <%            
          	if (action == null) {
          		rs = statement.executeQuery("SELECT * FROM Student");
      	  %>
               <table border="2">
               <tr>
                   <th>Student ID</th>
                   <th>SSN</th>
                   <th>First</th>
                   <th>Middle</th>
                   <th>Last</th>
               </tr>
        <%      
               while (rs.next()) {
        %>
       			<tr>
       				<form action="Class_Schedule.jsp" method="POST">
       					<input type="hidden" name="action" value="display_class"/>
                        <input type="hidden" name="student_id" value="<%=rs.getInt("student_id")%>"/>
       					<td><%=rs.getInt("student_id")%></td>
       					<td><%=rs.getString("ssn")%></td>
       					<td><%=rs.getString("first")%></td>
       					<td><%=rs.getString("middle")%></td>
       					<td><%=rs.getString("last")%></td>
       					<td><input type="submit" value="Select"></td>
       				</form>
       			</tr>
       	<%
               }
        } // end of original form %>
          
          <%-- -------- display_class -------- --%>
          <%
              // Check if an insertion is requested
              if (action != null && action.equals("display_class")) {
              	int student_id = Integer.parseInt(request.getParameter("student_id"));
              	
				conn.setAutoCommit(false);
				
				pstmt2 = conn.prepareStatement("DROP VIEW IF EXISTS V1");
				pstmt2.executeUpdate();
				
				pstmt3 = conn.prepareStatement("DROP VIEW IF EXISTS V2");
				pstmt3.executeUpdate();
              	
              	// 1. get current meeting schedule
              	
              	String w = "CREATE VIEW V1 AS (SELECT m.start_time, m.end_time, m.day, m.section_id, " +
              				"s.class_id, c.class_name, cou.title " + 
              				"FROM Meeting m, Class c, Section s, Section_Enrolllist se, Course cou " + 
              				"WHERE m.section_id = s.section_id " +
              				"AND cou.course_name = c.class_name " +
              				"AND s.class_id = c.class_id " + 
              				"AND se.section_id = s.section_id " +
              				"AND se.student_id = " + student_id + 
              				" ORDER BY s.section_id)";
              	pstmt = conn.prepareStatement(w);
               	int rowCount = pstmt.executeUpdate();
               	
               	// 2. get current not selected sections
               	String s = "CREATE VIEW V2 AS (SELECT m.start_time, m.end_time,m.day, m.section_id, " +
               				"c.class_id, c.class_name, cou.title " +
	               			"FROM Meeting m, Section s, Class c, Course cou " +
	               			"WHERE m.section_id = s.section_id AND s.class_id = c.class_id " + 
	               			"AND cou.course_name = c.class_name " +
	               			"AND c.quarter = 'Spring' AND c.year = 2009 " +   
	               			"AND c.class_id NOT IN ( SELECT class_id FROM Student_Class WHERE student_id = " + 
	               			student_id + " ) " + 
	               			"ORDER BY s.section_id )";
               	pstmt1 = conn.prepareStatement(s);
               	int rowCount1 = pstmt1.executeUpdate();
               	
               	// 3. compare time slots
               	String t = "SELECT v2.class_name name2, v2.title title2, v2.section_id sec2, " +
               				"v1.class_name name1, v1.title title1, v1.section_id sec1 " +
               				"FROM V1 v1, V2 v2 " + 
               				"WHERE v1.day = v2.day " +
               				"AND (v1.start_time, v1.end_time) OVERLAPS (v2.start_time, v2.end_time) ";
               	rs = statement.executeQuery(t);
           %>
                 <table border="2">
                 <tr>
                     <th>Request Class Name</th>
                     <th>Request Class Title</th>
                     <th>Request Section ID</th>
                     <th>Conflict Class Name</th>
                     <th>Conflict Class Title</th>
                     <th>Conflict Section ID</th>
                 </tr>
           <%
              	while (rs.next()) {
           %>
	           <tr>
					<td><%=rs.getString("name2")%></td>
					<td><%=rs.getString("title2")%></td>
					<td><%=rs.getInt("sec2")%></td>
					<td><%=rs.getString("name1")%></td>
					<td><%=rs.getString("title1")%></td>
					<td><%=rs.getInt("sec1")%></td>
				</tr>	
	      <%
              }
           %>
           </table>
           <%
           		conn.commit();
   				conn.setAutoCommit(true);
          }
          %>

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
<a href="Class_Schedule.jsp">Refresh</a>

</body>
</html>
