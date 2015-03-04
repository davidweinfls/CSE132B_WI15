<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Master Remaining Requirement Page</title>
</head>
<body>

<h2>Master Remaining Requirement Form</h2>
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
          ResultSet rs = null;
          ResultSet rs1 = null;
          ResultSet rs2 = null;
          ResultSet rs3 = null;
          ResultSet rs4 = null;
          ResultSet rs5 = null;
	
          
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
          	Statement stmt = conn.createStatement();
          	String action = request.getParameter("action");
          %>
          
          <%-- -------- Original Student and Degree Form -------- --%>
          <%            
          	if (action == null) {
          		rs = stmt.executeQuery("SELECT student.ssn, student.first, student.middle, student.last "
          				+ "FROM student, master, enrollment "
          				+ "WHERE student.student_id = master.master_id "
          				+ "AND student.ssn = enrollment.ssn and enrollment.year = 2009 "
          				+ "AND enrollment.quarter = 'Spring' ");
      	  %>
               <table border="2">
               <tr>
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
       					<input type="hidden" name="action" value="remain_requirement"/>
                        <input type="hidden" name="ssn" value="<%=rs.getString("ssn")%>"/>
       					<td><%=rs.getString("ssn")%></td>
       					<td><%=rs.getString("first")%></td>
       					<td><%=rs.getString("middle")%></td>
       					<td><%=rs.getString("last")%></td>
       					<td><input type="submit" value="Select"></td>
       				</form>
       			</tr>
       	<%
               }
       
  				rs = stmt.executeQuery("SELECT degree, institute FROM Prev_Degree " +
  						"WHERE degree = 'master'");
	 	 %>
       			<table border="2">
       			<tr>
           			<th>Degree Level</th>
           			<th>Institute</th>
           			<th>Description</th>
       			</tr>
		<%      
       			while (rs.next()) {
		%>
				<tr>
					<form>
						<td><%=rs.getString("degree")%></td>
						<td><%=rs.getString("institute")%></td>
						<td><%=rs.getString("degree").concat(" from ").concat(rs.getString("institute"))%></td>
					</form>
				</tr>
		<%
       			}
        } // end of original form %>
          
          <%-- -------- Remain Requirement Report -------- --%>
          <%
				// Check if an insertion is requested
				if (action != null && action.equals("remain_requirement")) {
					String student_ssn = request.getParameter("ssn");
					
					
					//get tempSid first
                    rs = stmt.executeQuery("SELECT Graduate.in_Dept AS major "
                    		+ "FROM Graduate, Student "
                    		+ "WHERE Graduate.grad_id = Student.student_id "
                    		+ "AND Student.ssn = '" + student_ssn + "'");
                    String department = "";
					if( rs.next() ){
						department = rs.getString("major");
					}

					pstmt = conn.prepareStatement("drop view if exists ConcentrationInDegree ");
					int rowCount = pstmt.executeUpdate();
					
					//create a view for all the Concentration in certain master degree
                    pstmt = conn.prepareStatement("CREATE VIEW ConcentrationInDegree AS ( "
                    		+ "SELECT Requirement.require_id, Requirement.units, "
                    		+ "Requirement.gpa, Requirement.description "
                    		+ "FROM Dept_requirement, Requirement "
                    		+ "WHERE Dept_requirement.dept_name = '" + department + "' "
                    		+ "AND Requirement.require_id = Dept_Requirement.require_id "
                    		+ "AND Requirement.degree = 'master' )");
					
                    rowCount = pstmt.executeUpdate();
					
                    
					// select all the classes a master student has taken/is taking
                    rs2 = stmt.executeQuery("SELECT Section_Enrolllist.grade_option AS unit, " 
                    		+ "Concentration_course.con_name AS con, Student_Class.grade AS grade, "
                    		+ "Student.ssn AS ssn, Course.course_id AS cid "
                    		+ "FROM Section_Enrolllist, Student_Class, Section, Course, Class, "
                    		+ "Student, Concentration_course "
                    		+ "WHERE Section_Enrolllist.section_id = Section.section_id "
                    		+ "AND Section.class_id = Student_Class.class_id "
                    		+ "AND Section_Enrolllist.student_id = Student_class.student_id "
                    		+ "AND Course.course_name = Class.class_name "
                    		+ "AND Class.class_id = Student_Class.class_id "
                    		+ "AND Student_class.student_id = Student.student_id "
                    		+ "AND Concentration_Course.course_id = Course.course_id "
                    		+ "AND Student.ssn = '" + student_ssn +"'");
					
                    ArrayList<Integer> class_id = new ArrayList<Integer>();
                    ArrayList<String> unit = new ArrayList<String>(); // grade option
                    ArrayList<String> con = new ArrayList<String>();
                    ArrayList<String> grade = new ArrayList<String>();
					// generate a list of class a student has taken/is taking with units and grade information
                    while( rs2.next() ){
                    	class_id.add(rs2.getInt("cid"));
                    	unit.add(rs2.getString("unit"));
                    	con.add(rs2.getString("con"));
                    	grade.add(rs2.getString("grade"));
                    }
					
                    ArrayList<Integer> require_id= new ArrayList<Integer>();
                    ArrayList<Float> require_gpa = new ArrayList<Float>();
                    ArrayList<Integer> require_units = new ArrayList<Integer>();
                    ArrayList<String> require_name = new ArrayList<String>();
                    ArrayList<Boolean> require_met = new ArrayList<Boolean>();
					
					rs1 = stmt.executeQuery("SELECT * FROM ConcentrationInDegree");
					
					while( rs1.next() ){
                    	require_id.add(rs1.getInt("require_id"));
                    	require_units.add(rs1.getInt("units"));
                    	require_gpa.add(rs1.getFloat("gpa"));
                    	require_name.add(rs1.getString("description"));
                    	require_met.add(false);
                    }
					
					ArrayList<String> conName = new ArrayList<String>();
					ArrayList<Integer> courseNeeded = new ArrayList<Integer>();
					ArrayList<String> courseName = new ArrayList<String>();
					
					// loop through each requirement to check condition :)
					for( int i = 0; i < require_id.size(); i++ ){
						
						// SELECT the courses in this requirement/concentration
						rs = stmt.executeQuery("SELECT Concentration_Course.course_id, "
							+ "Course.course_name "
							+ "FROM Concentration_Course, ConcentrationInDegree, Course "
							+ "WHERE Concentration_Course.con_name = ConcentrationInDegree.description "
							+ "AND Concentration_Course.course_id = Course.course_id "
							+ "AND Concentration_Course.con_name = '" + require_name.get(i) + "'");
						ArrayList<Integer> require_course= new ArrayList<Integer>();
						ArrayList<String> require_course_name = new ArrayList<String>();
						while( rs.next() ){
							require_course.add(rs.getInt("course_id"));
							require_course_name.add(rs.getString("course_name"));
						}
						
	                    int totalUnit = 0;
	                    int letterUnit = 0;
	                    float gradePoints = 0;
	                    
	                    // check if the student has taken each course in this concentration
	                    for( int j = 0; j < require_course.size(); j++ ){
	                    	if( class_id.contains(require_course.get(j)) ){
	                    		int ind = class_id.indexOf( require_course.get(j) );
	                    		// check if WIP on this course
	                    		if( grade.get(ind).equals("WIP") ){
	                    			conName.add(require_name.get(i));
	                    			courseNeeded.add(require_course.get(j));
	                    			courseName.add(require_course_name.get(j));
	                    			continue;
	                    		}
	                    		else if( unit.get(ind).equals("P/NP") ){
	                    			totalUnit += 4;
	                    		}
	                    		else{
	                    			int courseUnit = Integer.parseInt(unit.get(ind));
	                    			totalUnit += courseUnit;
	                    			letterUnit += courseUnit;
	                    			gradePoints += gpaTable.get(grade.get(ind)) * courseUnit;
	                    		}
	                    	}
	                    	// else add the course id and the concentration name into the array list
	                    	else{
	                    		conName.add(require_name.get(i));
                    			courseNeeded.add(require_course.get(j));
                    			courseName.add(require_course_name.get(j));
	                    		continue;
	                    	}
	                    	
	                    	// if all the courses in this concentration are taken by the student
	                    	// check GPA and total units requirement
	                    	if( j == require_course.size() - 1 ){
	                    		if( totalUnit >= require_units.get(i) && 
	                    				gradePoints/letterUnit >= require_gpa.get(i) )
	                    		require_met.set(i, true);
	                    	}
	                    }
					}
					
					ArrayList<Integer> nextYear = new ArrayList<Integer>();
					ArrayList<String> nextQuarter = new ArrayList<String>();
					for( int k = 0; k < courseNeeded.size(); k++ ){
						rs4 = stmt.executeQuery( "SELECT Class.quarter, Class.year, Class.class_name "
								+ "FROM Class, Course "
								+ "WHERE Course.course_id = " + courseNeeded.get(k) + " "
								+ "AND Course.course_name = Class.class_name ");
						int minYear = 2020;
						String minQuarter = "N/A";
						
						while( rs4.next() ){
							int tmpYear = rs4.getInt("year");
							String tmpQuarter = rs4.getString("quarter");
							if( tmpYear < minYear ){
								minYear = tmpYear;
								minQuarter = tmpQuarter;
							}
							else if( tmpQuarter.equals("Winter") || minQuarter.equals("Fall") || 
	                				( tmpQuarter.equals("Spring") && minQuarter.equals("Summer") ) ){
								minQuarter = tmpQuarter;
							}
						}
						
						nextYear.add(minYear);
						nextQuarter.add(minQuarter);
					}
					
					
					
					
                    %>
                    <h3>Completed Concentration</h3> 
                    <table border="2">
                    <tr>
                        <th>Student_SSN</th>
                        <th>Concentration_Name</th>
                    </tr>
                  <%
                  for(int l = 0; l < require_name.size(); l++ ){
                     if( require_met.get(l)){
                  %>   
                    <tr>
						<td><%=student_ssn%></td>
						<td><%=require_name.get(l)%></td>
					</tr>
					</table>
                    <%
                     }
                  }
                    %>
                    
                    <h3>Remain Concentration Courses</h3> 
                    <table border="2">
                    <tr>
                        <th>Student_SSN</th>
                        <th>Concentration</th>
                        <th>Course</th>
                        <th>Quarter</th>
                        <th>Year</th>
                    </tr>
                    
                    <%
                  for(int m = 0; m < courseName.size(); m++ ){
                  %>
                    <tr>
						<td><%=student_ssn%></td>
						<td><%=conName.get(m)%></td>
						<td><%=courseName.get(m)%></td>
						<td><%=nextQuarter.get(m)%></td>
						<td><%=nextYear.get(m)%></td>
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
          		if (stmt != null)
          			stmt.close();

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
          		if (rs2 != null) {
          			try {
          				rs2.close();
          			} catch (SQLException e) {
          			} // Ignore
          			rs2 = null;
          		}
          		if (rs3 != null) {
          			try {
          				rs3.close();
          			} catch (SQLException e) {
          			} // Ignore
          			rs3 = null;
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


<a href="Welcome.html">Back</a>
<a href="Master_remain_requirement.jsp">Refresh</a>

</body>
</html>
