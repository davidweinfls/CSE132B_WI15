<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>New Decision Support Page</title>
</head>
<body>

<h2>New Decision Support Form</h2>
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
         	
		gpaTable.put("A+", 4.3);
		gpaTable.put("A", 4.0);
		gpaTable.put("A-", 3.7);
		gpaTable.put("B+", 3.4);
		gpaTable.put("B", 3.1);
		gpaTable.put("B-", 2.8);
		gpaTable.put("C+", 2.5);
		gpaTable.put("C", 2.2);
		gpaTable.put("C-", 1.9);
		gpaTable.put("D", 1.6);
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
          
          <%-- -------- Original Form - Display Professors-------- --%>
          <%            
          	if (action == null) {
          		rs = statement.executeQuery("SELECT * FROM Faculty");
          		
				conn.setAutoCommit(false);
				
				// TEMP TABLE for 3.a.ii
				pstmt = conn.prepareStatement("DROP TABLE IF EXISTS CPQG");
				pstmt.executeUpdate();
				
				String w = 
					"CREATE TABLE CPQG AS (SELECT sec.class_id, sec.instructor_ssn, c.quarter, c.year, " + 
					"SUM(CASE WHEN (sc.grade = 'A' OR sc.grade = 'A+' OR sc.grade = 'A-') THEN 1 ELSE 0 END) AS NUM_OF_A, " +  
					"SUM(CASE WHEN (sc.grade = 'B' OR sc.grade = 'B+' OR sc.grade = 'B-') THEN 1 ELSE 0 END) AS NUM_OF_B, " + 
					"SUM(CASE WHEN (sc.grade = 'C' OR sc.grade = 'C+' OR sc.grade = 'C-') THEN 1 ELSE 0 END) AS NUM_OF_C, " +
					"SUM(CASE WHEN sc.grade = 'D' THEN 1 ELSE 0 END) AS NUM_OF_D, " +
					"SUM(CASE WHEN (sc.grade = 'P' OR sc.grade = 'NP' OR sc.grade = 'F') THEN 1 ELSE 0 END) AS NUM_OF_Other " +
					"FROM Section sec, Section_Enrolllist se, Student_Class sc, Class c " +
					"WHERE sec.section_id = se.section_id " +
					"AND se.student_id = sc.student_id " +
					"AND sc.class_id = sec.class_id " +
					"AND sec.class_id = c.class_id " +
					"GROUP BY sec.class_id, sec.instructor_ssn, c.quarter, c.year " +
					"ORDER BY sec.instructor_ssn)";
				pstmt = conn.prepareStatement(w);
           		int rowCount = pstmt.executeUpdate();
           		
           		// TEMP TABLE for 3.a.iii
           		pstmt1 = conn.prepareStatement("DROP TABLE IF EXISTS CPG");
				pstmt1.executeUpdate();
           				
           		String w1 = 
           			"CREATE TABLE CPG AS (SELECT c.class_name, sec.instructor_ssn, " +
           			"SUM(CASE WHEN (sc.grade = 'A' OR sc.grade = 'A+' OR sc.grade = 'A-') THEN 1 ELSE 0 END) AS NUM_OF_A, " + 
           			"SUM(CASE WHEN (sc.grade = 'B' OR sc.grade = 'B+' OR sc.grade = 'B-') THEN 1 ELSE 0 END) AS NUM_OF_B, " + 
           			"SUM(CASE WHEN (sc.grade = 'C' OR sc.grade = 'C+' OR sc.grade = 'C-') THEN 1 ELSE 0 END) AS NUM_OF_C, " +
           			"SUM(CASE WHEN sc.grade = 'D' THEN 1 ELSE 0 END) AS NUM_OF_D, " +
           			"SUM(CASE WHEN (sc.grade = 'P' OR sc.grade = 'NP' OR sc.grade = 'F') THEN 1 ELSE 0 END) AS NUM_OF_Other " +
           			"FROM Section sec, Section_Enrolllist se, Student_Class sc, Class c " +
           			"WHERE sec.section_id = se.section_id " +
           			"AND se.student_id = sc.student_id " +
           			"AND sc.class_id = sec.class_id " +
           			"AND sec.class_id = c.class_id " +
           			"GROUP BY sec.instructor_ssn, c.class_name " +
           			"ORDER BY sec.instructor_ssn)";
           		
           		pstmt1 = conn.prepareStatement(w1);
           		int rowCount1 = pstmt1.executeUpdate();
      	  %>
      	  		<h4>part ii, iii, v (Only display classes from previous quarter)</h4>
               <table border="2">
               <tr>
                   <th>SSN</th>
                   <th>Title</th>
                   <th>First</th>
                   <th>Last</th>
               </tr>
        <%      
               while (rs.next()) {
        %>
       			<tr>
       				<form>
       					<input type="hidden" name="action" value="display_class"/>
                        <input type="hidden" name="ssn" value="<%=rs.getString("ssn")%>"/>
       					<td><%=rs.getString("ssn")%></td>
       					<td><%=rs.getString("title")%></td>
       					<td><%=rs.getString("first")%></td>
       					<td><%=rs.getString("last")%></td>
       					<td><input type="submit" value="Select"></td>
       				</form>
       			</tr>
       	<%
               }
        %>
        	</table>
        	<%
            String s = "SELECT * FROM Course";
      		rs = statement.executeQuery(s);
            %>
            
            <h4>part iv - Grade Distribution of a course given over year </h4>
          <table border="2">
            <tr>
                <th>Course Name</th>
            </tr>
            
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>
            <tr>
				<form action="Decision_Support_New.jsp" method="POST">
					<input type="hidden" name="action" value="iv"/>
                  	<input type="hidden" name="class_name" value="<%=rs.getString("course_name")%>"/>
					<td><%=rs.getString("course_name")%></td>
					<!-- Update button -->
					<td><input type="submit" value="Select"></td>
				</form>
			</tr>
		
			<%
				}
            %>
            </table>
        
        <%
        	conn.commit();
			conn.setAutoCommit(true);
        } // end of original form %>
          
          <%-- -------- Display_class -------- --%>
          <%
              // Check if an insertion is requested
              if (action != null && action.equals("display_class")) {
              	String f_ssn = request.getParameter("ssn");
              	
              	String w = "SELECT distinct c.* FROM Class c, Section s WHERE s.class_id = c.class_id " +
              				"AND NOT (c.quarter = 'Spring' AND c.year = 2009) " +
              				"AND s.instructor_ssn = '" + f_ssn + "'";
              	rs = statement.executeQuery(w);
          %>
          
          <h4>part ii - Grade Distribution given by quarter-year (specific class) </h4>
          <table border="2">
            <tr>
                <th>Class ID</th>
                <th>Class Name</th>
                <th>Quarter</th>
                <th>Year</th>
            </tr>
            
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>
            <tr>
				<form action="Decision_Support_New.jsp" method="POST">
					<input type="hidden" name="action" value="ii"/>
                  	<input type="hidden" name="class_id" value="<%=rs.getInt("class_id")%>"/>
                  	<input type="hidden" name="ssn" value="<%=f_ssn%>"/>
					<td><%=rs.getInt("class_id")%></td>
					<td><%=rs.getString("class_name")%></td>
					<td><%=rs.getString("quarter")%></td>
					<td><%=rs.getInt("year")%></td>
					<!-- Update button -->
					<td><input type="submit" value="Select"></td>
				</form>
			</tr>
		
			<%
				}
            %>
            </table>
            
            <%
            String s = "SELECT distinct c.class_name FROM Class c, Section s WHERE s.class_id = c.class_id " +
      					"AND s.instructor_ssn = '" + f_ssn + "'";
      		rs = statement.executeQuery(s);
            %>
            
            <h4>part iii - Grade Distribution of a course given by prof over year </h4>
          	<table border="2">
            <tr>
                <th>Class Name</th>
            </tr>
            
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>
            <tr>
				<form action="Decision_Support_New.jsp" method="POST">
					<input type="hidden" name="action" value="iii"/>
                  	<input type="hidden" name="class_name" value="<%=rs.getString("class_name")%>"/>
                  	<input type="hidden" name="ssn" value="<%=f_ssn%>"/>
					<td><%=rs.getString("class_name")%></td>
					<!-- Update button -->
					<td><input type="submit" value="Grade Distribution"></td>
				</form>
			</tr>
		
			<%
				}
            %>
            </table>
            
            <%
            String d = "SELECT distinct c.class_name FROM Class c, Section s WHERE s.class_id = c.class_id " +
      					"AND s.instructor_ssn = '" + f_ssn + "'";
      		rs = statement.executeQuery(d);
            %>
            
            <h4>part v - GPA of a course given by prof over year </h4>
         	<table border="2">
            <tr>
                <th>Class Name</th>
            </tr>
            
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>
            <tr>
            	<form action="Decision_Support_New.jsp" method="POST">
					<input type="hidden" name="action" value="v"/>
                  	<input type="hidden" name="class_name" value="<%=rs.getString("class_name")%>"/>
                  	<input type="hidden" name="ssn" value="<%=f_ssn%>"/>
					<td><%=rs.getString("class_name")%></td>
					<!-- Update button -->
					<td><input type="submit" value="GPA"></td>
				</form>
			</tr>
		
			<%
				}
            %>
            </table>
            
            <%
              }
          %>
          
          <%-- -------- ii -------- --%>
          <%
              // Check if an insertion is requested
              if (action != null && action.equals("ii")) {
              	String f_ssn = request.getParameter("ssn");
              	int class_id = Integer.parseInt(request.getParameter("class_id"));
              	
				conn.setAutoCommit(false);
				
				String s = "SELECT * FROM CPQG WHERE instructor_ssn = '" + f_ssn + "' " +
						"AND class_id = " + class_id;
               	rs = statement.executeQuery(s);
               	if (rs.next()) {
          %>
          
          <table border="2">
            <tr>
                <th>A+/A/A-</th>
                <th>B+/B/B-</th>
                <th>C+/C/C-</th>
                <th>D</th>
                <th>Other</th>
            </tr>
            
            <%
            %>
            <tr>
				<td><%= rs.getInt("num_of_a") %></td>
				<td><%= rs.getInt("num_of_b") %></td>
				<td><%= rs.getInt("num_of_c") %></td>
				<td><%= rs.getInt("num_of_d") %></td>
				<td><%= rs.getInt("num_of_other") %></td>
			</tr>
		
            </table>
            <%
               	}
	            conn.commit();
	    		conn.setAutoCommit(true);
              }
          %>
          
          <%-- -------- iii -------- --%>
          <%
              // Check if an insertion is requested
              if (action != null && action.equals("iii")) {
              	String f_ssn = request.getParameter("ssn");
              	String class_name = request.getParameter("class_name");
              	
				conn.setAutoCommit(false);
				
				String s = "SELECT * FROM CPG WHERE instructor_ssn = '" + f_ssn + "' " +
						"AND class_name = '" + class_name + "'";
               	rs = statement.executeQuery(s);
               	if (rs.next()) {
          %>
          
          <table border="2">
            <tr>
                <th>A+/A/A-</th>
                <th>B+/B/B-</th>
                <th>C+/C/C-</th>
                <th>D</th>
                <th>Other</th>
            </tr>
            
            <%
            %>
            <tr>
				<td><%= rs.getInt("num_of_a") %></td>
				<td><%= rs.getInt("num_of_b") %></td>
				<td><%= rs.getInt("num_of_c") %></td>
				<td><%= rs.getInt("num_of_d") %></td>
				<td><%= rs.getInt("num_of_other") %></td>
			</tr>
		
            </table>
            <%
               	}
	            conn.commit();
	    		conn.setAutoCommit(true);
              }
          %>
          
          <%-- -------- iv -------- --%>
          <%
              // Check if an insertion is requested
              if (action != null && action.equals("iv")) {
              	String class_name = request.getParameter("class_name");
              	
				conn.setAutoCommit(false);
				
				pstmt1 = conn.prepareStatement("DROP VIEW IF EXISTS V2");
				pstmt1.executeUpdate();
              	
				String w = "CREATE VIEW V2 AS (SELECT sc.* FROM Section sec, Section_Enrolllist se, " + 
          				"Student_Class sc, Class c " +
          				"WHERE sec.section_id = se.section_id " +
          				"AND se.student_id = sc.student_id " + 
          				"AND sc.class_id = sec.class_id " + 
          				"AND c.class_name = '" + class_name + "' " +
          				"AND c.class_id = sec.class_id)";
          		pstmt = conn.prepareStatement(w);
           		int rowCount = pstmt.executeUpdate();
               	
               	int a = 0, b = 0, c = 0, d = 0, o = 0;
               	String sa = "SELECT count (*) num_A FROM V2 WHERE grade = 'A+' OR grade = 'A' OR grade = 'A-'"; 
              	rs = statement.executeQuery(sa);
              	if (rs.next()) a = rs.getInt("num_A");
              	
              	String sb = "SELECT count (*) num_B FROM V2 WHERE grade = 'B+' OR grade = 'B' OR grade = 'B-'"; 
              	rs = statement.executeQuery(sb);
              	if (rs.next()) b = rs.getInt("num_B");
              	
              	String sc = "SELECT count (*) num_C FROM V2 WHERE grade = 'C+' OR grade = 'C' OR grade = 'C-'"; 
              	rs = statement.executeQuery(sc);
              	if (rs.next()) c = rs.getInt("num_C");
              	
              	String sd = "SELECT count (*) num_D FROM V2 WHERE grade = 'D'"; 
              	rs = statement.executeQuery(sd);
              	if (rs.next()) d = rs.getInt("num_D");
              	
              	String so = "SELECT count (*) num_O FROM V2 WHERE grade = 'P' OR grade = 'NP' OR grade = 'F'"; 
              	rs = statement.executeQuery(so);
              	if (rs.next()) o = rs.getInt("num_O");
          %>
          
          <table border="2">
            <tr>
                <th>A+/A/A-</th>
                <th>B+/B/B-</th>
                <th>C+/C/C-</th>
                <th>D</th>
                <th>Other</th>
            </tr>
            
            <%
            %>
            <tr>
				<td><%= a %></td>
				<td><%= b %></td>
				<td><%= c %></td>
				<td><%= d %></td>
				<td><%= o %></td>
			</tr>
		
            </table>
            <%
	            conn.commit();
	    		conn.setAutoCommit(true);
              }
          %>
          
          <%-- -------- v -------- --%>
          <%
              // Check if an insertion is requested
              if (action != null && action.equals("v")) {
              	String f_ssn = request.getParameter("ssn");
              	String class_name = request.getParameter("class_name");
              	
				conn.setAutoCommit(false);
				
				pstmt1 = conn.prepareStatement("DROP VIEW IF EXISTS V3");
				pstmt1.executeUpdate();
              	
              	String w = "CREATE VIEW V3 AS (SELECT sc.*, se.grade_option " + 
              				"FROM Section sec, Section_Enrolllist se, " + 
              				"Student_Class sc, Class c " +
              				"WHERE sec.section_id = se.section_id " +
              				"AND se.student_id = sc.student_id " + 
              				"AND sc.class_id = sec.class_id " + 
              				"AND c.class_name = '" + class_name + "' " +
              				"AND c.class_id = sec.class_id " +
              				"AND sec.instructor_ssn = '" + f_ssn + "') ";
              	pstmt = conn.prepareStatement(w);
               	int rowCount = pstmt.executeUpdate();
               	
               	String s = "SELECT * FROM V3";
               	rs = statement.executeQuery(s);
              	float gpa = 0, total_gpa = 0;
              	int count = 0;
              	
              	while (rs.next()) {
              		String grade = rs.getString("grade");
              		String grade_option_s = rs.getString("grade_option");
              		if (!(grade.equals("P") || grade.equals("NP") || grade.equals("WIP")) ){
              			int grade_option = Integer.parseInt(grade_option_s);
              			count+= grade_option;
              			total_gpa += gpaTable.get(grade) * grade_option;
              		}
              		
              	}
              	if (count != 0) {
              		System.out.println("count: " + count);
              		System.out.println("total_gpa: " + total_gpa);
          			gpa = total_gpa / count;
          		}

          %>
          
          <table border="2">
            <tr>
                <th>GPA</th>
            </tr>
            
            <%
            %>
            <tr>
				<td><%= gpa %></td>
			</tr>
		
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
<a href="Decision_Support_New.jsp">Refresh</a>

</body>
</html>
