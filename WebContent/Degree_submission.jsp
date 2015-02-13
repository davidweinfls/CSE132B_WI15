<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Degree Submission Page</title>
</head>
<body>

<h2>Degree Submission Entry Form</h2>
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
            
            
            
            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/cse132b?" +
                    "user=sendvt&password=postgres");
            %>

            <%-- -------- INSERT Code -------- --%>
            <%
           		String action = request.getParameter("action");
                // Check if an insertion is requested
                if (action != null && action.equals("insert")) {
         	
                    Integer tempSid;
                    String tempDegree;
                   	boolean stuDegreeMatch = false;
                   	boolean concentration = false;
                   	String masterCon = null;
                   	
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
                   	
                    
                	// get the infomation from the table and validate
                	tempSid = Integer.parseInt(request.getParameter("student_id"));
                	tempDegree = request.getParameter("degree");
                	
                	String department = null;
                	
                	// Create the statement
                    Statement stmt = conn.createStatement();

                	// Check if the student is working on a master degree
                	if( tempDegree.equals("master") ){
                		rs = stmt.executeQuery("SELECT * from Master where master_id = " + tempSid);
                		if( rs.next() ){
            				masterCon = rs.getString("con_name");
                			rs = stmt.executeQuery("SELECT in_dept from Graduate where grad_id = " + tempSid);
                			if( rs.next() ){
                    			stuDegreeMatch = true;
                    			concentration = true;
                				department = rs.getString("in_dept");
                			}
                		}
                	}
                	
                	// Check if the student is working on a phd degree
                	else if( tempDegree.equals("phd") ){
                		rs = stmt.executeQuery("SELECT * from Phd where phd_id = " + tempSid);
                		if( rs.next() ){
                			rs = stmt.executeQuery("SELECT in_dept from Graduate where grad_id = " + tempSid);
                			if( rs.next() ){
                    			stuDegreeMatch = true;
                				department = rs.getString("in_dept");
                			}
                		}	
                	}
                	
                	// Check if the student is working on a bs/ba degree
                	else if( tempDegree.equals("bs") || tempDegree.equals("ba") ){
                		rs = stmt.executeQuery("SELECT * from Undergraduate where u_id = " + tempSid);
                		if( rs.next() ){
                			rs = stmt.executeQuery("SELECT major from Undergraduate where u_id = " + tempSid);
                			if( rs.next() ){
                    			stuDegreeMatch = true;
                				department = rs.getString("major");
                			}
                		}
                	}
                	
                	// after getting the major/department info, find requirements of certain degree
                	if( stuDegreeMatch ) {
                		rs = stmt.executeQuery("SELECT require_id from Dept_requirement where dept_name = '" +
                				department + "'");
                		
                		boolean conti = true;
                		
                		HashSet<Integer> classTaken = new HashSet<Integer>();
                		HashSet<Integer> courseTaken = new HashSet<Integer>();
                		
                		// check each requirement of that degree, students need to meet all of them
                		while( rs.next() && conti ){
                			int requireId = rs.getInt("require_id");
                			
                			ResultSet rs2 = null;
                			Statement stmt2 = conn.createStatement();
                			// find the exact requirement
                			rs2 = stmt2.executeQuery( "SELECT * from Requirement where require_id = " + requireId );
                			if( rs2.next() ){
                				// only check the exact degree
                				if( (rs2.getString("degree").equals(tempDegree)) ) { 
                					int units = rs2.getInt("units");
                					int gpa = rs2.getInt("gpa");
                					// gather information from section enroll list
                					
                					int studentUnit = 0;
                					double gradePointTotal = 0;
                					
                					ResultSet rs3 = null;
                					Statement stmt3 = conn.createStatement();
                					
                					
                					// select the classes that student has taken to calculate the units and gpa
                					rs3 = stmt3.executeQuery(" SELECT Section_Enrolllist.grade_option AS unit, "
                							+ "Student_Class.grade AS grade, "
                							+ "Student_Class.class_id AS class "
                							+ "From Section_Enrolllist, Student_Class, Section "
                							+ "WHERE Section_Enrolllist.section_id = Section.section_id "
                							+ "AND Section.class_id = Student_Class.class_id "
                							+ "AND Section_Enrolllist.student_id = Student_class.student_id");
                					
                					while( rs3.next() ){
                						classTaken.add(rs3.getInt("class"));
                						String strUnit = rs3.getString("unit");
                						if( !(strUnit.equals("SU")) ){
                							String strGrade = rs3.getString("grade");
                							if( !(strGrade.equals("WIP")) ){
                								int unit = Integer.parseInt(strUnit);
                								studentUnit = studentUnit + unit;
                								gradePointTotal = gradePointTotal + unit * gpaTable.get(strGrade);
                							}
                						}
                					}
                					
                					double studentGpa = gradePointTotal / studentUnit;
                					
                					if( studentGpa < gpa || studentUnit < units ){
                						conti = false;
                					}
                				}
                			}
                		
                		}
                		
                		
                		// if conti, then all the conditions have been met
                		// should check concentration if master students
                		if( conti && tempDegree.equals("master") ) {
                			// find the list of courses the master student has taken
                			Iterator<Integer> classesTaken = classTaken.iterator();
                			while( classesTaken.hasNext() ){
                				Statement stmt4 = conn.createStatement();
                				ResultSet rs4 = stmt4.executeQuery( "SELECT DISTINCT Course.course_id AS course "
                						+ " FROM Course, Class" 
                						+ " WHERE Class.class_id = " + classesTaken.next()
                						+ " AND Course.course_name = Class.class_name" );
                				if( rs4.next() ){
                					courseTaken.add(rs4.getInt("course"));
                				}
                				else{
                					conti = false;
                				}
                			}
                			
                			// based on the concentration of the master student, find the list of course requirement
                			// of the concentration
                			Statement stmt5 = conn.createStatement();
                			ResultSet rs5 = stmt5.executeQuery( "SELECT * FROM Concentration_course"
                					+ " WHERE Concentration_course.con_name = '" + masterCon + "'");
                			while( rs5.next() && conti ){
                				if( !(courseTaken.remove(rs5.getInt("course_id"))) ){
                					conti = false;
                				}
                			}
                		}
                		
                		
                		// insert
                		
                		int degreeID = -1;
                		
                		// check if the degree exists
                		if( conti ){
                			rs = stmt.executeQuery("SELECT degree_id FROM Prev_degree"
                              		+ " WHERE degree = '" + tempDegree + "'"
                              		+ " AND institute = 'UCSD'");
                			  
                			if( rs.next() ){
                				degreeID = rs.getInt("degree_id");
                			}
                			else{
                				conti = false;
                			}
                		}
                		
                		if(conti && degreeID != -1){
                			
                			// insert into the thesis committee table
              				// Begin transaction
                            conn.setAutoCommit(false);

                            // Create the prepared statement and use it to
                            // INSERT thesis committee values INTO the Thesis_committee table.
                            pstmt = conn
                            	.prepareStatement("INSERT INTO Other_degree (degree_id, student_id)" + 
                            	" VALUES (?, ?)");
                            pstmt.setInt(1, degreeID);
                            pstmt.setInt(2, tempSid);
                            int rowCount = pstmt.executeUpdate();

                            // Commit transaction
                            conn.commit();

                      		conn.setAutoCommit(true);	
                		}
                		
                	}

                    
                }
            %>
            
            <%-- -------- UPDATE Code -------- --%>
            <%
                // Check if an update is requested
                if (action != null && action.equals("update")) {

                	// get updated degree level and institute
                	String tempDegLevel = request.getParameter("degree_level");
                	String tempInstitute = request.getParameter("institute");
                	
                	ResultSet rs6 = null;
                	Statement stmt6  = conn.createStatement();
                	
                	rs6 = stmt6.executeQuery("SELECT degree_id FROM Prev_degree"
                      		+ " WHERE degree = '" + tempDegLevel + "'"
                      		+ " AND institute = '" + tempInstitute + "'");
        			
                	boolean conti = true;
                	
                	int degreeID = -1;
                	
                	if( rs6.next() ){
                		degreeID = rs6.getInt("degree_id");
                	}
                	else{
        				conti = false;
        			}
                	
                	if( conti ){
                	
                	
                    	// Begin transaction
                    	conn.setAutoCommit(false);

                    	// Create the prepared statement and use it to
                    	// UPDATE student values in the Students table.
                    	pstmt = conn
                        	.prepareStatement("UPDATE Other_degree SET degree_id = ? " 
                    		+ " WHERE student_id = ? AND degree_id = ?");

                    	pstmt.setInt(1, degreeID);
                    	pstmt.setInt(2, Integer.parseInt(request.getParameter("s_id")));
                    	pstmt.setInt(3, Integer.parseInt(request.getParameter("d_id")));
                   	 
                    	int rowCount = pstmt.executeUpdate();

                    	// Commit transaction
                    	conn.commit();
                    	conn.setAutoCommit(true);
                	}
                }
            %>
            
            <%-- -------- DELETE Code -------- --%>
            <%
                // Check if a delete is requested
                if (action != null && action.equals("delete")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    // DELETE students FROM the Students table.
                    pstmt = conn
                        .prepareStatement("DELETE FROM Other_degree WHERE student_id = ? AND degree_id = ?");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("s_id")));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("d_id")));
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>
            
            <%-- -------- SELECT Statement Code -------- --%>
            <%
                // Create the statement
                Statement statement = conn.createStatement();

                // Use the created statement to SELECT
                // the student attributes FROM the Student table.
                rs = statement.executeQuery(
                		"SELECT Other_degree.degree_id AS degree_id, Other_degree.student_id AS student_id, "
                		+ " Prev_degree.degree AS degLevel, Prev_degree.institute as institute "
                		+ " FROM Other_degree, Prev_degree WHERE Other_degree.degree_id = Prev_degree.degree_id"
                		+ " ORDER BY student_id");
            %>
            
            <!-- Add an HTML table header row to format the results -->
            <table border="2">
            <tr>
                <th>Student_ID</th>
                <th>Degree</th>
                <th>Institute</th>
                <th>Degree_ID</th>
                
            </tr>
            
            <!-- An empty row with blankets for user to type in -->
            <tr>
                <form action="Degree_submission.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <th><input value="" name="student_id" size="10"/></th>
                    <th><input value="" name="degree" size="10"/></th>
                    <!-- Insert button, designed to submit a committee thesis info -->
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
						<input type="hidden" name="s_id" value="<%=rs.getInt("student_id")%>"/>
                  		<input type="hidden" name="d_id" value="<%=rs.getInt("degree_id")%>"/>
					<%-- Get the student_id --%>
					<td><input value=<%=rs.getInt("student_id")%> name="student_id" size="10"/></td>
					<td><input value=<%=rs.getString("degLevel")%> name="degree_level" size="10"/></td>
					<td><input value=<%=rs.getString("institute")%> name="institute" size="10"/></td>
					<td><input value=<%=rs.getInt("degree_id")%> name="degree_id" size="10"/></td>
					
					
					<!-- Update button -->
					<td><input type="submit" value="Update"></td>
				</form>
				<form action="Degree_submission.jsp" method="POST">
					<input type="hidden" name="action" value="delete" /> 
					<input type="hidden" name="s_id" value="<%=rs.getInt("student_id")%>"/>
                  	<input type="hidden" name="d_id" value="<%=rs.getInt("degree_id")%>"/>
					<%-- Delete Button --%>
					<td><input type="submit" value="Delete" /></td>
				</form>
			</tr>
			<%
				}
			%>

            <%-- -------- Close Connection Code -------- --%>
            <%
            	// Close the ResultSet
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


</body>
</html>
