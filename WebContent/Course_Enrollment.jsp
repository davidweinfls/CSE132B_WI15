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
          PreparedStatement pstmt1 = null;
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
              	int student_id = Integer.parseInt(request.getParameter("student_id"));
              	
              	// check prerequisite
              	// get all classes this student took
              	String w = "SELECT course_id FROM Course, Class c, Student_Class s WHERE " + 
              				"class_name = course_name AND c.class_id = s.class_id AND " + 
              				"student_id = " + student_id;
              	rs = statement.executeQuery(w);
              	ArrayList<Integer> course_taken = new ArrayList<Integer>();
              	while (rs.next()) {
              		course_taken.add(rs.getInt("course_id"));
              	}
              	
              	// get prerequisite of this certain class
              	String q = "SELECT prerequisite_id FROM Prerequisite p, Course c WHERE p.course_id = " + 
              				"c.course_id AND c.course_name = '" + class_name + "'";
              	rs = statement.executeQuery(q);
              	int clear = 0;
              	int count = 0;
              	while (rs.next()) {
              		count++;
              		int pre_id = rs.getInt("prerequisite_id");
              		for (int i = 0; i < course_taken.size(); ++i) {
              			if (pre_id == course_taken.get(i)) {
              				clear++;
              				break;
              			}
              		}
              	}
              	if (clear == count) {
              	
              	
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
	              	
	                  String select_query = "Select class_id FROM Class WHERE class_name = '" + class_name + "'" + 
								" AND quarter = 'Winter' AND year = 2015";
					  rs = statement.executeQuery(select_query);
					  rs.next();
					  int class_id = rs.getInt("class_id");
	              	
	            %>
	            		<h3>Class found. Please select section.</h3>
	             		<form action="Course_Enrollment.jsp" method="POST">
	                       <input type="hidden" name="action" value="choose_section"/>
	                       <input type="hidden" value="<%=class_id%>" name="id"/>
	                       <input type="hidden" name="student_id" value="<%=student_id%>"/>
	                       <th><input type="submit" value="Choose Section"/></th>
	                </form>
	             
	          <%
	              } else {
	            	  out.println("<font color='#ff0000'>Prerequisite not cleared. Cannot continue");
	              }
              }
          %>
          
          <%-- -------- Choose Section -------- --%>
          <%
          	if (action != null && action.equals("choose_section")) {
          		int class_id = Integer.parseInt(request.getParameter("id"));
          		int student_id = Integer.parseInt(request.getParameter("student_id"));
          		rs = statement.executeQuery("SELECT * FROM Section WHERE class_id = " + class_id);
          %>
          
          <table border="2">
           <tr>
               <th>Section ID</th>
               <th>Enroll Limit</th>
               <th>Grade Option</th>
               <th>Instructor SSN</th>
               <th>Class ID</th>
           </tr>
          <tr>
          
          <%
          		while (rs.next()) {
          %>
          
		<form>
			<input type="hidden" name="action" value="enroll_section"/>
            <input type="hidden" name="id" value="<%=rs.getInt("section_id")%>"/>
            <input type="hidden" name="class_id" value="<%=class_id%>"/>
            <input type="hidden" name="student_id" value="<%=student_id%>"/>
			<td><%=rs.getInt("section_id")%></td>
			<td><%=rs.getInt("enroll_limit")%></td>
			<td><%=rs.getString("grade_option")%></td>
			<td><%=rs.getString("instructor_ssn")%></td>
			<td><%=rs.getInt("class_id")%></td>
			<%-- Delete Button --%>
			<td><input type="submit" value="Enroll" /></td>
		</form>
	</tr>
          			
          <%
          		}
          	}
          %>
          
          <%-- -------- Enroll Section Form -------- --%>
          <%
          	if (action != null && action.equals("enroll_section")) {
          		int section_id = Integer.parseInt(request.getParameter("id"));
          		int student_id = Integer.parseInt(request.getParameter("student_id"));
          		int class_id = Integer.parseInt(request.getParameter("class_id"));
          		rs = statement.executeQuery("SELECT * FROM Section WHERE section_id = " + section_id);
          		rs.next();
          		int limit = rs.getInt("enroll_limit");
          		String q = "SELECT count(*) num FROM Section_Enrolllist WHERE section_id = " + section_id;
          		rs = statement.executeQuery(q);
          		rs.next();
          		int num = rs.getInt("num");
          		System.out.println("num of enroll:" + num);
          		String waitlist = "false";
          		if (num > limit) {
          			waitlist = "true";
          		}
          		
          		conn.setAutoCommit(false);
          		
          		// check if student already enrolled
              	String q1 = "Select * FROM Section_Enrolllist Where student_id = " + student_id + " AND " + 
              	"section_id = " + section_id;
              	rs = statement.executeQuery(q1);
              	int rowCount = 0;
              	if (!rs.next()) {
          		String query = "INSERT INTO Section_Enrolllist VALUES (" + 
          				student_id + ", " + section_id + ", " + "'L', " + waitlist + ")";
          		System.out.println("insert into Student_Class: " + query);
          		pstmt = conn.prepareStatement(query);
          		rowCount = pstmt.executeUpdate();
              	} else {
        	    	out.println("<font color='#ff0000'>Failed to enroll in section. Already enrolled");
           		}
              	
             	// add relationship to Student_Class table
              	// check if student already enrolled
              	String q2 = "Select * FROM Student_Class Where student_id = " + student_id + " AND " + 
              	"class_id = " + class_id;
              	rs = statement.executeQuery(q2);
              	int rowCount1 = 0;
              	if (!rs.next()) {
              		String query1 = "INSERT INTO Student_Class VALUES (" + student_id + ", " + class_id + ", " + "'WIP'" + ")";
              		System.out.println("insert into Student_Class: " + query1);
              		pstmt1 = conn.prepareStatement(query1);
              		rowCount1 = pstmt1.executeUpdate();
              	} else {
              		out.println("<font color='#ff0000'>Student already enrolled in this class");
              	}
          		
          		if (rowCount > 0 && rowCount1 > 0) {
                    %>
           			<h3>Last step before enroll. Select your grade option</h3>
            		<form action="Course_Enrollment.jsp" method="POST">
                      <input type="hidden" name="action" value="grade_option"/>
                      <input type="hidden" value="<%=section_id%>" name="id"/>
                      <input type="hidden" name="student_id" value="<%=student_id%>"/>
                      <th><input type="submit" value="Grade Option"/></th>
               		</form>
           <% } 
           %>   
                     
          <%
          		conn.commit();
          		conn.setAutoCommit(true);
          	}
          %>
          
          <%-- -------- Grade Option Form -------- --%>
          <%
          	if (action != null && action.equals("grade_option")) {
          		int section_id = Integer.parseInt(request.getParameter("id"));
          		int student_id = Integer.parseInt(request.getParameter("student_id"));
          		
          		// get grade option
          		String query = "SELECT grade_option FROM Section WHERE section_id = " + section_id;
          		rs = statement.executeQuery(query);
          		rs.next();
          		String grade_option = rs.getString("grade_option");
          		boolean su = true;
          		boolean letter = false;
          		int low = 0, high = 0;
          		// get unit range if it can ba taken in letter
          		if (grade_option.equals("L") || grade_option.equals("L/SU")) {
          			String q1 = "SELECT unit_low, unit_high FROM Section, Course, Class WHERE " + 
          			"section.class_id = class.class_id AND class.class_name = course.course_name AND " + 
          			"section_id = " + section_id;
          			rs = statement.executeQuery(q1);
          			rs.next();
          			low = rs.getInt("unit_low");
          			high = rs.getInt("unit_high");
          			
          			if (grade_option == "L") su = false;
          			letter = true;
          		}
          		ArrayList<String> grade_list = new ArrayList<String>();
          		if (su) {
	          		grade_list.add("SU");
          		}
          		if (letter) {
          			for (int i = low; i <= high; ++i) {
          				
          				grade_list.add(Integer.toString(i));
          			}
          		}
          %>	
          
          <table border = "2">
          <tr>
          	<th>Student ID</th>
          	<th>Section ID</th>
          	<th>Grade Option</th>
          </tr>
          
          <tr>
            <form action="Course_Enrollment.jsp" method="POST">
                <input type="hidden" name="action" value="update_grade_option"/>
                <input type="hidden" value="<%=section_id%>" name="id"/>
                <input type="hidden" name="student_id" value="<%=student_id%>"/>
                <th><%=student_id%></th>
          		<th><%=section_id%></th>
                <th>
                <select name = "grade_dropdown">
                <option value = "">Select Unit/SU</option>
                	<% for (int i = 0; i < grade_list.size(); ++i) { %>
                		<option value=<%= grade_list.get(i)%>><%= grade_list.get(i)%></option>
                	<% } %>
                </select>
                </th>
                <th><input type="submit" value="Update Grade Option"/></th>
            </form>
               </tr>
          
          <tr>
          	
          </tr>
          
          </table>	
          	
          <%		
          	}
          %>
          
          <%-- -------- Update Grade Form -------- --%>
          <%
          	if (action != null && action.equals("update_grade_option")) {
          		int section_id = Integer.parseInt(request.getParameter("id"));
          		int student_id = Integer.parseInt(request.getParameter("student_id"));
          		String grade_option = request.getParameter("grade_dropdown");

          		// Begin transaction
                conn.setAutoCommit(false);

                // Create the prepared statement and use it to
                // UPDATE student values in the Students table.
                pstmt = conn
                    .prepareStatement("UPDATE Section_Enrolllist SET grade_option = ?" + 
                    " WHERE student_id = " + student_id + " AND section_id = " + section_id);
                pstmt.setString(1, grade_option);
                int rowCount = pstmt.executeUpdate();
                
                if (rowCount > 0) {
                	out.println("Grade option set!");
                } else {
                	out.println("<font color='#ff0000'>Something went wrong.");
                }

                // Commit transaction
                conn.commit();
                conn.setAutoCommit(true);
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
