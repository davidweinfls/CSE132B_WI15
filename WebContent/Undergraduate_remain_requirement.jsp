<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Undergraduate Remaining Requirement Page</title>
</head>
<body>

<h2>Undergraduate Remaining Requirement Form</h2>
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
          PreparedStatement pstmt2 = null;
          PreparedStatement pstmt3 = null;
          ResultSet rs = null;
          ResultSet rs1 = null;
          ResultSet rs2 = null;
          ResultSet rs3 = null;

          
          try {
              // Registering Postgresql JDBC driver with the DriverManager
              Class.forName("org.postgresql.Driver");

              // Open a connection to the database using DriverManager
              conn = DriverManager.getConnection(
                  "jdbc:postgresql://localhost/cse132b?" +
                  "user=postgres&password=postgres");
          %>
          
          <%
          	Statement stmt = conn.createStatement();
          	String action = request.getParameter("action");
          %>
          
          <%-- -------- Original Student and Degree Form -------- --%>
          <%            
          	if (action == null) {
          		rs = stmt.executeQuery("SELECT student.ssn, student.first, student.middle, student.last "
          				+ "FROM student, undergraduate, enrollment "
          				+ "WHERE student.student_id = undergraduate.u_id "
          				+ "and student.ssn = enrollment.ssn and enrollment.year = 2009 "
          				+ "and enrollment.quarter = 'Spring'");
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
  						"WHERE degree = 'bs' or degree = 'ba'");
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
          
          <%-- -------- Remain Requiment Report -------- --%>
          <%
				// Check if an insertion is requested
				if (action != null && action.equals("remain_requirement")) {
					String student_ssn = request.getParameter("ssn");
					
					
					//get tempSid first
                    rs = stmt.executeQuery("SELECT Undergraduate.major AS major "
                    		+ "FROM Undergraduate, Student "
                    		+ "WHERE Undergraduate.u_id = Student.student_id "
                    		+ "AND Student.ssn = '" + student_ssn + "'");
                    String department = "";
					if( rs.next() ){
						department = rs.getString("major");
					}

                    rs = stmt.executeQuery("SELECT require_id from Dept_requirement where dept_name = '" +
                                    department + "'");
                    
                    boolean conti = true;

                    int totalRemained = 0;
                    int lowerRemained = 0;
                    int upperRemained = 0;
                    int techRemained = 0;
                    int totalUnit = 0;
                    boolean totalCaled = false;
                    
                    // check each requirement of that degree, students need to meet all of them
                    while( rs.next() && conti ){
                            int requireId = rs.getInt("require_id");     

                            Statement stmt2 = conn.createStatement();
                            // find the exact requirement
                            rs2 = stmt2.executeQuery( "SELECT * from Requirement where require_id = " + requireId );
                            if( rs2.next() ){
                                    // only check the exact degree
                                    if( (rs2.getString("degree").equals("bs")) ) { 
                                            // gather information from section enroll list
                                            String requireType = rs2.getString("description");
                                            int requireUnit = Integer.parseInt(rs2.getString("units"));

                                            Statement stmt3 = conn.createStatement();
                                            
                                            int studentUnit = 0;

                                            // select the classes that student has taken to calculate the units
                                            rs3 = stmt3.executeQuery(" SELECT Section_Enrolllist.grade_option AS unit, "
                                                            + "Student_Class.class_id AS class, "
                                                            + "Course.course_type AS type "
                                                            + "From Section_Enrolllist, Student_Class, Section, Course, Class, Student "
                                                            + "WHERE Section_Enrolllist.section_id = Section.section_id "
                                                            + "AND Section.class_id = Student_Class.class_id "
                                                            + "AND Section_Enrolllist.student_id = Student_class.student_id "
                                                            + "AND Course.course_name = Class.class_name "
                                                            + "AND Class.class_id = Student_Class.class_id "
                                                            + "AND Student_class.student_id = Student.student_id "
                                                            + "AND Student.ssn = '" + student_ssn + "'");


                                            while( rs3.next() ){
                                                    String type = rs3.getString("type");
                                                    String strUnit = rs3.getString("unit");
													
                                                    if( !totalCaled ){
                                                    	if( !(strUnit.equals("P/NP")) ){
                                                    		int tUnit = Integer.parseInt(strUnit);
                                                        	totalUnit += tUnit;
                                                    	}
                                                    	else{
                                                    		totalUnit += 4;
                                                    	}
                                                	}
                                                    
                                                    if(type.contains(requireType)){
                                                            if( !(strUnit.equals("P/NP")) ){
                                                            		int unit = Integer.parseInt(strUnit);
                                                                    studentUnit += unit;
                                                            }
                                                            else{
                                                                    studentUnit += 4;

                                                            }
                                                    }
                                            }

                                            if( requireType.equals("UD") ){
                                                    if(requireUnit > studentUnit){
                                                            upperRemained = requireUnit - studentUnit;
                                                    }
                                            } else if ( requireType.equals("LD") ){
                                                    if(requireUnit > studentUnit){
                                                            lowerRemained = requireUnit - studentUnit;
                                                    }
                                            } else if ( requireType.equals("TE") ){
                                                    if(requireUnit > studentUnit){
                                                            techRemained = requireUnit - studentUnit;
                                                    }
                                            } else if( !totalCaled && requireType.equals("TU") ){
                                                    if(requireUnit > studentUnit){
                                                            totalRemained = requireUnit - totalUnit;
                                                    }
                                                    totalCaled = true;
                                            }

                                    }
                            }
                    }
                    %>
                    <h3>Remain Requirement</h3> 
                    <table border="2">
                    <tr>
                        <th>Student_SSN</th>
                        <th>Lower_Div</th>
                        <th>Upper_Div</th>
                        <th>Tech_Elec</th>
                        <th>Total_Unit</th>
                    </tr>
                    
                    <tr>
						<td><%=student_ssn%></td>
						<td><%=lowerRemained%></td>
						<td><%=upperRemained%></td>
						<td><%=techRemained%></td>
						<td><%=totalRemained%></td>
					</tr>

  
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
          		if (pstmt1 != null) {
          			try {
          				pstmt2.close();
          			} catch (SQLException e) {
          			} // Ignore
          			pstmt1 = null;
          		}
          		if (pstmt2 != null) {
          			try {
          				pstmt2.close();
          			} catch (SQLException e) {
          			} // Ignore
          			pstmt2 = null;
          		}
          		if (pstmt3 != null) {
          			try {
          				pstmt3.close();
          			} catch (SQLException e) {
          			} // Ignore
          			pstmt3 = null;
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
<a href="Undergraduate_remain_requirement.jsp">Refresh</a>

</body>
</html>
