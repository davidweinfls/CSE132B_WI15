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
          <%@ page import="java.lang.StringBuilder"%>
          <%-- -------- Open Connection Code -------- --%>
          <%
          
          Connection conn = null;
          PreparedStatement pstmt = null;
          PreparedStatement pstmt1 = null;
          ResultSet rs = null;
          ResultSet rs1 = null;
          
          Hashtable<String, Double> gpaTable = new Hashtable<String, Double>();
         	
		gpaTable.put("A+", 4.0);
		gpaTable.put("A", 4.0);
		gpaTable.put("A-", 3.7);
		gpaTable.put("B+", 3.3);
		gpaTable.put("B", 3.0);
		gpaTable.put("B-", 2.7);
		gpaTable.put("C+", 2.3);
		gpaTable.put("C", 2.0);
		gpaTable.put("C-", 1.7);
		gpaTable.put("D+", 1.3);
		gpaTable.put("D", 1.0);
		gpaTable.put("F", 0.0);
          
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
       				<form>
       					<input type="hidden" name="action" value="grade_report"/>
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
          
          <%-- -------- Grade Report -------- --%>
          <%
              // Check if an insertion is requested
              if (action != null && action.equals("grade_report")) {
            	  int student_id = Integer.parseInt(request.getParameter("student_id"));
                	
                	String w = "SELECT c.*, sc.grade, se.grade_option " +  
                			"FROM Class c, Student_Class sc, Section s, Section_Enrolllist se " +  
                			"WHERE sc.class_id = c.class_id " +  
                			"AND sc.student_id = " + student_id + 
                			" AND s.class_id = c.class_id " + 
                			"AND s.section_id = se.section_id " +  
                			"AND se.student_id = " + student_id + 
                			" AND NOT(c.year <> 2015 AND c.quarter <> 'Winter') " +
                			"GROUP BY c.class_id, c.year, c.quarter, sc.grade, se.grade_option " + 
                			"ORDER BY c.year";
                	rs = statement.executeQuery(w);
           %>
                 <table border="2">
                 <tr>
                     <th>Class ID</th>
                     <th>Class Name</th>
                     <th>Quarter</th>
                     <th>Year</th>
                     <th>Grade</th>
                     <th>Grade Option</th>
                 </tr>
           <%
              	while (rs.next()) {
           %>
	           <tr>
					<td><%=rs.getInt("class_id")%></td>
					<td><%=rs.getString("class_name")%></td>
					<td><%=rs.getString("quarter")%></td>
					<td><%=rs.getInt("year")%></td>
					<td><%=rs.getString("grade")%></td>
					<td><%=rs.getString("grade_option")%></td>
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
