<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Decision Support Page</title>
</head>
<body>

<h2>Decision Support Form</h2>
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
      	  %>
      	  		<h4>Only display classes from previous quarter</h4>
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
				<form action="Decision_Support.jsp" method="POST">
					<input type="hidden" name="action" value="i"/>
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
              }
          %>
          
          <%-- -------- i -------- --%>
          <%
              // Check if an insertion is requested
              if (action != null && action.equals("i")) {
              	String f_ssn = request.getParameter("ssn");
              	int class_id = Integer.parseInt(request.getParameter("class_id"));
              	
				conn.setAutoCommit(false);
				
				pstmt1 = conn.prepareStatement("DROP VIEW IF EXISTS V");
				pstmt1.executeUpdate();
              	
              	String w = "CREATE VIEW V AS (SELECT sc.* FROM Section sec, Section_Enrolllist se, Student_Class sc " +
              				"WHERE sec.section_id = se.section_id " +
              				"AND se.student_id = sc.student_id " + 
              				"AND sc.class_id = sec.class_id " + 
              				"AND sc.class_id = " + class_id +
              				" AND sec.instructor_ssn = '" + f_ssn + "') ";
              	pstmt = conn.prepareStatement(w);
               	int rowCount = pstmt.executeUpdate();
               	
               	int a = 0, b = 0, c = 0, d = 0, o = 0;
               	String sa = "SELECT count (*) num_A FROM V WHERE grade = 'A+' OR grade = 'A' OR grade = 'A-'"; 
              	rs = statement.executeQuery(sa);
              	if (rs.next()) a = rs.getInt("num_A");
              	
              	String sb = "SELECT count (*) num_B FROM V WHERE grade = 'B+' OR grade = 'B' OR grade = 'B-'"; 
              	rs = statement.executeQuery(sb);
              	if (rs.next()) b = rs.getInt("num_B");
              	
              	String sc = "SELECT count (*) num_C FROM V WHERE grade = 'C+' OR grade = 'C' OR grade = 'C-'"; 
              	rs = statement.executeQuery(sc);
              	if (rs.next()) c = rs.getInt("num_C");
              	
              	String sd = "SELECT count (*) num_D FROM V WHERE grade = 'D'"; 
              	rs = statement.executeQuery(sd);
              	if (rs.next()) d = rs.getInt("num_D");
              	
              	String so = "SELECT count (*) num_O FROM V WHERE grade = 'P' OR grade = 'NP' OR grade = 'F'"; 
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
          
          
          
          
          <%-- -------- Grade Report -------- --%>
          <%
				// Check if an insertion is requested
				if (action != null && action.equals("grade_report")) {
				int student_id = Integer.parseInt(request.getParameter("student_id"));
				  	
				conn.setAutoCommit(false);
				
				pstmt1 = conn.prepareStatement("DROP VIEW IF EXISTS V");
				pstmt1.executeUpdate();
            	  
               	String w = "CREATE VIEW V AS (SELECT c.*, sc.grade, se.grade_option " +  
               			"FROM Class c, Student_Class sc, Section s, Section_Enrolllist se " +  
               			"WHERE sc.class_id = c.class_id " +  
               			"AND sc.student_id = " + student_id + 
               			" AND s.class_id = c.class_id " + 
               			"AND s.section_id = se.section_id " +  
               			"AND se.student_id = " + student_id + 
               			" AND NOT(c.year = 2009 AND c.quarter = 'Spring') " +
               			"GROUP BY c.class_id, c.year, c.quarter, sc.grade, se.grade_option " + 
               			"ORDER BY c.year)";
               	pstmt = conn.prepareStatement(w);
               	int rowCount = pstmt.executeUpdate();
               	
               	String s = "SELECT * FROM V";
               	rs1 = statement.executeQuery(s);
           %>
           <h3>Class Taken</h3> 
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
              	while (rs1.next()) {
           %>
	           <tr>
					<td><%=rs1.getInt("class_id")%></td>
					<td><%=rs1.getString("class_name")%></td>
					<td><%=rs1.getString("quarter")%></td>
					<td><%=rs1.getInt("year")%></td>
					<td><%=rs1.getString("grade")%></td>
					<td><%=rs1.getString("grade_option")%></td>
				</tr>
				
					
	      <%
              }
          %>
          	</table>
          	
          	<h3>Quarter GPA</h3> 
          	<table border="2">
          	<tr>
          		<th>Quarter</th>
          		<th>Year</th>
          		<th>GPA</th>
          	</tr>

          	<% 
          	// quarter GPA
          	rs = statement.executeQuery(s);
          	Hashtable<String, ArrayList<Double>> quarter_grade = new Hashtable<String, ArrayList<Double>>();
          	Hashtable<String, Integer> sum_of_grade_option = new Hashtable<String, Integer>();
          	
          	while (rs.next()) {
          		int year = rs.getInt("year");
          		String quarter = rs.getString("quarter");
          		String year_quarter = year + "_" + quarter; // key for both hashtable
          		String grade = rs.getString("grade");

          		if (!(grade.equals("P") || grade.equals("NP"))){
          			int grade_option = Integer.parseInt(rs.getString("grade_option"));
          			double converted_gpa = grade_option * gpaTable.get(grade);
          			
	          		if (quarter_grade.get(year_quarter) == null) {
	          			ArrayList<Double> list = new ArrayList<Double>();
	          			list.add(converted_gpa);
	          			quarter_grade.put(year_quarter, list);
	          			sum_of_grade_option.put(year_quarter, grade_option);
	          		} else {
	          			quarter_grade.get(year_quarter).add(converted_gpa);
	          			sum_of_grade_option.put(year_quarter, sum_of_grade_option.get(year_quarter) + grade_option);
	          		}
          		}
          	}
          	
          	for (String key : quarter_grade.keySet()){
          		double total_gpa = 0, quarter_gpa = 0;
          		for (int i = 0; i < quarter_grade.get(key).size(); ++i) {
          			total_gpa += quarter_grade.get(key).get(i);
          		}
          		if (quarter_grade.get(key).size() > 0) {
          			quarter_gpa = total_gpa / sum_of_grade_option.get(key);
          		}
          	%>	
          	<tr>
          		<td><%= key.substring(5) %></td>
          		<td><%= key.substring(0, 4) %></td>
				<td><%= quarter_gpa %></td>
          	</tr>	
          		
          	<%	
          	}
          	
          	%>
          	</table>
          	
          	<h3>Culmulative GPA</h3> 
          	<table border="2">
          	<tr>
          		<th>GPA</th>
          	</tr>
          	
          	<% 
          	// cumulative GPA
          	rs = statement.executeQuery(s);
          	float gpa = 0, total_gpa = 0;
          	int count = 0;
          	
          	while (rs.next()) {
          		String grade = rs.getString("grade");
          		String grade_option_s = rs.getString("grade_option");
          		if (!(grade.equals("P") || grade.equals("NP"))){
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
<a href="Decision_Support.jsp">Refresh</a>

</body>
</html>
