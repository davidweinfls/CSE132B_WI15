<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Grade Report Page</title>
</head>
<body>

<h2>Grade Report Form</h2>
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
          
          <%
          	Statement statement = conn.createStatement();
          	Statement statement1 = conn.createStatement();
          	String action = request.getParameter("action");
          %>
          
          <%-- -------- Original Form -------- --%>
          <%            
          	if (action == null) {
          		rs = statement.executeQuery("SELECT * FROM Class");
      	  %>
               <table border="2">
               <tr>
                   <th>Class ID</th>
                   <th>Class Name</th>
                   <th>Quarter</th>
                   <th>Year</th>
               </tr>
        <%      
               while (rs.next()) {
        %>
       			<tr>
       				<form>
       					<input type="hidden" name="action" value="display_roster"/>
                        <input type="hidden" name="class_id" value="<%=rs.getInt("class_id")%>"/>
       					<td><%=rs.getInt("class_id")%></td>
       					<td><%=rs.getString("class_name")%></td>
       					<td><%=rs.getString("quarter")%></td>
       					<td><%=rs.getInt("year")%></td>
       					<td><input type="submit" value="Select"></td>
       				</form>
       			</tr>
       	<%
               }
        } // end of original form %>
          
          <%-- -------- display_roster -------- --%>
          <%
              // Check if an insertion is requested
              if (action != null && action.equals("display_roster")) {
              	int class_id = Integer.parseInt(request.getParameter("class_id"));
              	
              	String w = "SELECT s.*, sec.section_id, se.grade_option, se.waitlist " + 
              				"FROM Student s, Student_Class sc, Section sec, Section_Enrolllist se " + 
              				"WHERE sc.student_id = s.student_id " + 
              				"AND sc.class_id = " + class_id +
              				" AND sec.class_id = " + class_id + 
              				"AND se.section_id = sec.section_id " +
              				"AND se.student_id = s.student_id";
              	rs = statement.executeQuery(w);
           %>
                 <table border="2">
                 <tr>
                     <th>Student ID</th>
                     <th>First</th>
                     <th>Middle</th>
                     <th>Last</th>
                     <th>SSN</th>
                     <th>Enrollment</th>
                     <th>Residency</th>
                     <th>Five-year Program</th>
                     <th>Section ID</th>
                     <th>Grade Option</th>
                     <th>Waitlist</th>
                 </tr>
           <%
              	while (rs.next()) {
           %>
	           <tr>
					<td><%=rs.getInt("student_id")%></td>
					<td><%=rs.getString("first")%></td>
					<td><%=rs.getString("middle")%></td>
					<td><%=rs.getString("last")%></td>
					<td><%=rs.getString("ssn")%></td>
					<td><%=rs.getBoolean("enrollment")%></td>
					<td><%=rs.getString("residency")%></td>
					<td><%=rs.getBoolean("five_year_program")%></td>
					<td><%=rs.getInt("section_id")%></td>
					<td><%=rs.getInt("grade_option")%></td>
					<td><%=rs.getBoolean("waitlist")%></td>
				</tr>	
	      <%
              }
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
<a href="Grade_Report.jsp">Refresh</a>

</body>
</html>
