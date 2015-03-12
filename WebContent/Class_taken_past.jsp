<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Class Taken Past Page</title>
</head>
<body>

<h2>Class Taken in the Past Form</h2>
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
          	String action = request.getParameter("action");
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
                   <form action="Class_taken_past.jsp" method="POST">
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
               <tr>
                   <form action="Class_taken_past.jsp" method="POST">
                       <input type="hidden" name="action" value="show_class_for_update"/>
                       <th><input value="" name="student_id" size="15"/></th>
                       <th>
                       <select name = "course_dropdown">
                       <option value = "">Select Course</option>
                       	<% for (int i = 0; i < course_names.size(); ++i) { %>
                       		<option value=<%= course_names.get(i)%>><%= course_names.get(i)%></option>
                       	<% } %>
                       </select>
                       </th>
                       <th><input type="submit" value="Update Course"/></th>
                   </form>
               </tr>
       <% } // end of original form %>
       
       <%-- -------- add_to_class -------- --%>
          <%
              // Check if an insertion is requested
              if (action != null && action.equals("add_to_class")) {
              	String class_name = request.getParameter("course_dropdown");
              	int student_id = Integer.parseInt(request.getParameter("student_id"));
              	
              	rs = statement.executeQuery("SELECT * FROM Class WHERE class_name = '" + class_name + "'");
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
				<form action="Class_taken_past.jsp" method="POST">
					<input type="hidden" name="action" value="show_section"/>
                  	<input type="hidden" name="class_id" value="<%=rs.getInt("class_id")%>"/>
                  	<input type="hidden" name="student_id" value="<%=student_id%>"/>
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
          
          <%-- -------- Show Section Form -------- --%>
          <%
              // Check if an insertion is requested
              if (action != null && action.equals("show_section")) {
              	int class_id = Integer.parseInt(request.getParameter("class_id"));
              	int student_id = Integer.parseInt(request.getParameter("student_id"));
              	
              	rs = statement.executeQuery("SELECT * FROM Section WHERE class_id = '" + class_id + "'");
          %>
          
          <table border="2">
            <tr>
                <th>Section ID</th>
                <th>Enroll Limit</th>
                <th>Grade Option</th>
                <th>Instructor SSN</th>
                <th>Class ID</th>
            </tr>
            
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>
            <tr>
				<form action="Class_taken_past.jsp" method="POST">
					<input type="hidden" name="action" value="add_section"/>
                  	<input type="hidden" name="section_id" value="<%=rs.getInt("section_id")%>"/>
                  	<input type="hidden" name="student_id" value="<%=student_id%>"/>
                  	<input type="hidden" name="class_id" value="<%=class_id%>"/>
                  	<input type="hidden" name="f_ssn" value="<%=rs.getString("instructor_ssn")%>"/>
					<td><%=rs.getInt("section_id")%></td>
					<td><%=rs.getInt("enroll_limit")%></td>
					<td><%=rs.getString("grade_option")%></td>
					<td><%=rs.getString("instructor_ssn")%></td>
					<td><%=rs.getInt("class_id")%></td>
					<!-- Update button -->
					<td><input type="submit" value="Add"></td>
				</form>
			</tr>
		
			<%
				}
            %>
            </table>
            <%
              }
          %>
          
          <%-- -------- Add Section Form -------- --%>
          <%
          	if (action != null && action.equals("add_section")) {
          		int section_id = Integer.parseInt(request.getParameter("section_id"));
          		int student_id = Integer.parseInt(request.getParameter("student_id"));
          		int class_id = Integer.parseInt(request.getParameter("class_id"));
          		String f_ssn = request.getParameter("f_ssn");
          		
          		conn.setAutoCommit(false);
          		
          		// check if student already enrolled
              	String q1 = "Select * FROM Section_Enrolllist Where student_id = " + student_id + " AND " + 
              	"section_id = " + section_id;
              	rs = statement.executeQuery(q1);
              	int rowCount = 0;
              	if (!rs.next()) {
					// do nothing
              	} else {
        	    	out.println("<font color='#ff0000'>Failed to enroll in section. Already enrolled. ");
           		}
              	
             	// add relationship to Student_Class table
              	// check if student already enrolled
              	String q2 = "Select * FROM Student_Class Where student_id = " + student_id + " AND " + 
              	"class_id = " + class_id;
              	rs = statement.executeQuery(q2);
              	int rowCount1 = 0;
              	if (!rs.next()) {
					// do nothing
              	} else {
              		out.println("<font color='#ff0000'>Student already enrolled in this class");
              	}
          		
          %>
     			<h3>Last step before add class. Select your grade option and input grade</h3>
      			<form action="Class_taken_past.jsp" method="POST">
                <input type="hidden" name="action" value="input_grade"/>
                <input type="hidden" value="<%=section_id%>" name="section_id"/>
                <input type="hidden" name="student_id" value="<%=student_id%>"/>
                <input type="hidden" name="class_id" value="<%=class_id%>"/>
                <input type="hidden" name="f_ssn" value="<%=f_ssn%>"/>
                <th><input type="submit" value="Input Grade"/></th>
         		</form> 
                     
          <%
          		conn.commit();
          		conn.setAutoCommit(true);
          	}
          %>
          
          <%-- -------- Input Grade Form -------- --%>
          <%
          	if (action != null && action.equals("input_grade")) {
          		int section_id = Integer.parseInt(request.getParameter("section_id"));
          		int student_id = Integer.parseInt(request.getParameter("student_id"));
          		int class_id = Integer.parseInt(request.getParameter("class_id"));
          		String f_ssn = request.getParameter("f_ssn");
          		
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
          	<th>Grade</th>
          </tr>
          
          <tr>
            <form action="Class_taken_past.jsp" method="POST">
                <input type="hidden" name="action" value="add_grade"/>
                <input type="hidden" value="<%=section_id%>" name="section_id"/>
                <input type="hidden" name="student_id" value="<%=student_id%>"/>
                <input type="hidden" name="class_id" value="<%=class_id%>"/>
                <input type="hidden" name="f_ssn" value="<%=f_ssn%>"/>
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
                <th><input value="" name="grade" size="5"></th>
                <th><input type="submit" value="Confirm"/></th>
            </form>
               </tr>
          </table>	
          	
          <%		
          	}
          %>
          
          <%-- -------- Add Grade Form -------- --%>
          <%
          	if (action != null && action.equals("add_grade")) {
          		int section_id = Integer.parseInt(request.getParameter("section_id"));
          		int student_id = Integer.parseInt(request.getParameter("student_id"));
          		int class_id = Integer.parseInt(request.getParameter("class_id"));
          		String grade_option = request.getParameter("grade_dropdown");
          		String grade = request.getParameter("grade");
          		String f_ssn = request.getParameter("f_ssn");

                conn.setAutoCommit(false);

                String query = "INSERT INTO Section_Enrolllist VALUES (" + 
  				student_id + ", " + section_id + ", " + "'" + grade_option +  "'," + "false)";
  				pstmt = conn.prepareStatement(query);
  				int rowCount = pstmt.executeUpdate();
                
                String query1 = "INSERT INTO Student_Class VALUES (" 
  				+ student_id + ", " + class_id + ", '" + grade + "', " + "'" + f_ssn + "' " + ")";
  				pstmt1 = conn.prepareStatement(query1);
  				int rowCount1 = pstmt1.executeUpdate();
                
                if (rowCount > 0 && rowCount1 > 0) {
                	out.println("Grade option and grade set!");
                } else {
                	out.println("<font color='#ff0000'>Something went wrong.");
                }

                // Commit transaction
                conn.commit();
                conn.setAutoCommit(true);
          	}
          %>
          
          <%-- -------- Show Class 1 for Update feature -------- --%>
          <%
              // Check if an insertion is requested
              if (action != null && action.equals("show_class_for_update")) {
              	String class_name = request.getParameter("course_dropdown");
              	int student_id = Integer.parseInt(request.getParameter("student_id"));
              	
              	rs = statement.executeQuery("SELECT * FROM Class WHERE class_name = '" + class_name + "'");
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
				<form action="Class_taken_past.jsp" method="POST">
					<input type="hidden" name="action" value="show_enroll"/>
                  	<input type="hidden" name="class_id" value="<%=rs.getInt("class_id")%>"/>
                  	<input type="hidden" name="student_id" value="<%=student_id%>"/>
                  	<input type="hidden" name="class_name" value="<%=rs.getString("class_name")%>"/>
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
          
          <%-- -------- Show Enroll Form -------- --%>
       <%
          	if (action != null && action.equals("show_enroll")) {
          		String class_name = request.getParameter("class_name");
              	int student_id = Integer.parseInt(request.getParameter("student_id"));
              	int class_id = Integer.parseInt(request.getParameter("class_id"));
              	System.out.println("student_id: " + student_id);
				System.out.println("class_id: " + class_id);
	              	
              	// get course_id
              	String q2 = "SELECT course_id FROM Course WHERE course_name = '" + class_name + "'";
				rs = statement.executeQuery(q2);
				rs.next();
				int course_id = rs.getInt("course_id");
				System.out.println("course_id: " + course_id);
				
				// get section_id this student enrolled
				String q3 = "SELECT se.section_id, se.grade_option FROM Section_Enrolllist se WHERE se.section_id IN (" +
						"SELECT section_id FROM Section s WHERE s.class_id = " + class_id + ") " + 
						"AND se.student_id = " + student_id;
				rs = statement.executeQuery(q3);
				if (rs.next()) {
					int section_id = rs.getInt("section_id");
					String grade_taken = rs.getString("grade_option");
					
					String q4 = "SELECT grade FROM Student_Class WHERE class_id = " + class_id + " AND student_id = " + 
								student_id;
					rs = statement.executeQuery(q4);
					rs.next();
					String grade = rs.getString("grade");
					
					// get grade option
	          		String q5 = "SELECT grade_option FROM Section WHERE section_id = " + section_id;
	          		rs = statement.executeQuery(q5);
	          		rs.next();
	          		String grade_option_list = rs.getString("grade_option");
					
					System.out.println("section_id: " + section_id);
					System.out.println("grade: " + grade);
					System.out.println("grade_taken: " + grade_taken);
					
					boolean su = true;
	          		boolean letter = false;
	          		int low = 0, high = 0;
	          		// get unit range if it can ba taken in letter
	          		if (grade_option_list.equals("L") || grade_option_list.equals("L/SU")) {
	          			String q6 = "SELECT unit_low, unit_high FROM Section, Course, Class WHERE " + 
	          			"section.class_id = class.class_id AND class.class_name = course.course_name AND " + 
	          			"section_id = " + section_id;
	          			rs = statement.executeQuery(q6);
	          			rs.next();
	          			low = rs.getInt("unit_low");
	          			high = rs.getInt("unit_high");
	          			
	          			if (grade_option_list == "L") su = false;
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
				
				<table border="2">
	            <tr>
	                <th>Student ID</th>
	                <th>Course ID</th>
	                <th>Class ID</th>
	                <th>Section ID</th>
	                <th>Grade</th>
	                <th>Grade Taken</th>
	                <th>Quarter</th>
	                <th>Year</th>
	                
	            </tr>
				
				<tr>
					<form>
						<input type="hidden" name="action" value="update_enroll"/>
	                  	<input type="hidden" value="<%=student_id%>" name="student_id"/>
						<input type="hidden" value="<%=class_id%>" name="class_id"/>
						<input type="hidden" value="<%=section_id%>" name="section_id"/>
						<input type="hidden" value="<%=grade_taken%>" name="grade_taken"/>
						<td><%=student_id%></td>
						<td><%=course_id%></td>
						<td><%=class_id%></td>
						<td><%=section_id%></td>
						<td><%=grade%></td>
						<th>
	                	<select name = "grade_option_dropdown">
	                	<option value = <%=grade_taken%>><%=grade_taken%></option>
	                		<% for (int i = 0; i < grade_list.size(); ++i) { %>
	                			<option value=<%= grade_list.get(i)%>><%= grade_list.get(i)%></option>
	                		<% } %>
	                	</select>
	                	</th>
						<td><input type="submit" value="Update"></td>
					</form>
					<form action="Class_taken_past.jsp" method="POST">
						<input type="hidden" name="action" value="delete_enroll" /> 
						<input type="hidden" value="<%=student_id%>" name="student_id"/>
						<input type="hidden" value="<%=class_id%>" name="class_id"/>
						<input type="hidden" value="<%=section_id%>" name="section_id"/>
						<%-- Delete Button --%>
						<td><input type="submit" value="Delete" /></td>
					</form>
				</tr>
				</table>
		  <%
				} else {
					out.println("<font color='#ff0000'>You are not enrolled in this class. Cannot update");
				}
          	} // end of show_enroll
          %>
          
          <%-- -------- Update Enroll Code -------- --%>
          <%
          	if (action != null && action.equals("update_enroll")) {
          		int section_id = Integer.parseInt(request.getParameter("section_id"));
          		int class_id = Integer.parseInt(request.getParameter("class_id"));
          		int student_id = Integer.parseInt(request.getParameter("student_id"));
          		String grade_option = request.getParameter("grade_option_dropdown");
          		
                conn.setAutoCommit(false);

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

                conn.commit();
                conn.setAutoCommit(true);
          	}
          %>
          
          <%-- -------- Delete Enroll Code -------- --%>
          <%
          	if (action != null && action.equals("delete_enroll")) {
          		int section_id = Integer.parseInt(request.getParameter("section_id"));
          		int class_id = Integer.parseInt(request.getParameter("class_id"));
          		int student_id = Integer.parseInt(request.getParameter("student_id"));
          		
          		// Begin transaction
                conn.setAutoCommit(false);

                String q1 = "DELETE FROM Section_Enrolllist WHERE student_id = " + student_id + " AND " + 
                		"section_id = " + section_id;
                String q2 = "DELETE FROM Student_Class WHERE student_id = " + student_id + " AND " + 
                		"class_id = " + class_id;
          		
                pstmt = conn.prepareStatement(q1);
                pstmt1 = conn.prepareStatement(q2);

                int rowCount = pstmt.executeUpdate();
                int rowCount1 = pstmt1.executeUpdate();

                if (rowCount > 0 && rowCount1 > 0) {
                	out.println("You are now dropped from section/class");
                } else {
                	out.println("<font color='#ff0000'>You cannot delete this class");
                }
                
                // Commit transaction
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
<a href="Class_taken_past.jsp">Refresh</a>

</body>
</html>
       