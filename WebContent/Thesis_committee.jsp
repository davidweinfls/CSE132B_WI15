<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Thesis Committee Page</title>
</head>
<body>

<h2>Thesis Committee Entry Form</h2>
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
                    Boolean tempIsphd;
                    int numDepFaculty = 0;
                    int numNonDepFaculty = 0;
        			final int MIN_DEP_FACULTY = 3;
                    ArrayList<String> tempFacultyList = new ArrayList<String>();
                   
                	// get the infomation from the table and validate
                	tempSid = Integer.parseInt(request.getParameter("graduate_student_id"));
                	tempIsphd = Boolean.parseBoolean(request.getParameter("is_phd"));
                	
                	for( int i = 0; i < 10; i++ ) {
                		String facNum = new StringBuilder("faculty_ssn_").append(i).toString();
                		String facSSN = request.getParameter(facNum);
                		
                		if( facSSN != null && facSSN.length() != 0 ) {
                			System.out.println(facSSN);
                			tempFacultyList.add(facSSN);
                		}
                		else{
                			break;
                		}     		
                	}
                	
                	// Create the statement
                    Statement stmt = conn.createStatement();

                    // Create the prepared statement and use it to
                    // SELECT faculty_department.
                    rs = stmt.executeQuery("SELECT in_dept from Graduate where grad_id = " + tempSid);
                	rs.next();
                    String dept = rs.getString("in_dept");
                    
                	//check number of faculty from departments
                	if( tempFacultyList.size() >= MIN_DEP_FACULTY ) {
                		for( int j = 0; j < tempFacultyList.size(); j++ ) {
                			rs = stmt.executeQuery("SELECT dept_name FROM Faculty where ssn = '"+ 
                		         tempFacultyList.get(j) + "'" );
                			rs.next();
                			if( rs.getString("dept_name").equals(dept) ) {
                				numDepFaculty++;
                			}
                			else{
                				numNonDepFaculty++;
                			}
                		}
                		if( numDepFaculty >= MIN_DEP_FACULTY ){
                			if( !tempIsphd || numNonDepFaculty > 0 ){
                				// insert into the thesis committee table
                				// Begin transaction
                                conn.setAutoCommit(false);

                                // Create the prepared statement and use it to
                                // INSERT thesis committee values INTO the Thesis_committee table.
                                pstmt = conn
                                .prepareStatement("INSERT INTO Thesis_committee (stu_id, is_phd, faculty_ssn)" + 
                                " VALUES (?, ?, ?)");

                                pstmt.setInt(1, tempSid);
                                pstmt.setBoolean(2, tempIsphd);
                        		for( int k = 0; k < tempFacultyList.size(); k++ ) {
                                	pstmt.setString(3, tempFacultyList.get(k));
                                	int rowCount = pstmt.executeUpdate();
                                	// Commit transaction
                                    conn.commit();
                                    
                        		}
                        		conn.setAutoCommit(true);	
                			}
                			
                		}
                		
                	}
                    
                }
            %>
            
            <%-- -------- UPDATE Code -------- --%>
            <%
                // Check if an update is requested
                if (action != null && action.equals("update")) {

                	int tempStuId = Integer.parseInt(request.getParameter("g_sid"));
                	String oldFSSN = request.getParameter("f_ssn");
                	String newFSSN = request.getParameter("faculty_ssn");
                	boolean isPHD = false;
                	
                	
                	ResultSet rs2 = null;
                	Statement stmt2 = conn.createStatement();
                	
                	ResultSet rs3 = null;
                	Statement stmt3 = conn.createStatement();
                	
                	rs2 = stmt2.executeQuery("SELECT faculty_ssn FROM Thesis_committee WHERE "
                			+ "stu_id = " + tempStuId);
                	
                	rs3 = stmt3.executeQuery("SELECT distinct is_phd FROM Thesis_committee WHERE "
                			+ "stu_id = " + tempStuId);
                	
                	
                	if( rs3.next() ){
                		System.out.println(rs3.getString("is_phd"));
                		isPHD = rs3.getBoolean("is_phd");
                		
                	}

                	rs3 = stmt3.executeQuery("SELECT in_dept from Graduate where grad_id = " + tempStuId);
                	rs3.next();
                    String dept = rs3.getString("in_dept");
                	
                	final int MIN_PROF = 3;
                	int numDepFaculty = 0;
                	int numNonDepFaculty = 0;
                	
                	while( rs2.next() ){
                		String facSSN = rs2.getString("faculty_ssn");
                		if( !(facSSN.equals(oldFSSN)) ){
                			rs3 = stmt3.executeQuery("SELECT dept_name FROM Faculty where ssn = '"
                				+ facSSN + "'");
                			rs3.next();
                			if( rs3.getString("dept_name").equals(dept) ) {
                				numDepFaculty++;
                			}
                			else{
                				numNonDepFaculty++;
                			}
                		}
            		}
                	
                	rs3 = stmt3.executeQuery("SELECT dept_name FROM Faculty where ssn = '"
            				+ newFSSN + "'");
            		rs3.next();
            		
            		if( rs3.getString("dept_name").equals(dept) ) {
        				numDepFaculty++;
        			}
        			else{
        				numNonDepFaculty++;
        			}
                	
            		if( numDepFaculty >= MIN_PROF ){
            			if( !isPHD || numNonDepFaculty > 0 ){
            				
            				// Begin transaction
                            conn.setAutoCommit(false);

                            // Create the prepared statement and use it to
                            // UPDATE student values in the Students table.
                            pstmt = conn
                                .prepareStatement("UPDATE Thesis_committee SET faculty_ssn = ? " 
                            + " WHERE stu_id = ? AND faculty_ssn = ?");

                            pstmt.setString(1, request.getParameter("faculty_ssn"));
                            pstmt.setInt(2, Integer.parseInt(request.getParameter("g_sid")));
                            pstmt.setString(3, request.getParameter("f_ssn"));
                            
                            int rowCount = pstmt.executeUpdate();

                            // Commit transaction
                            conn.commit();
                            conn.setAutoCommit(true);
            			}
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
                        .prepareStatement("DELETE FROM Thesis_committee WHERE stu_id = ?");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("g_sid")));
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
                rs = statement.executeQuery("SELECT * FROM Thesis_committee");
            %>
            
            <!-- Add an HTML table header row to format the results -->
            <table border="2">
            <tr>
                <th>Graduate_Student_ID</th>
                <th>Is_Phd</th>
                <th>Faculty_SSN</th>
            </tr>
            
            <!-- An empty row with blankets for user to type in -->
            <tr>
                <form action="Thesis_committee.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <th><input value="" name="graduate_student_id" size="10"/></th>
                    <th><input value="" name="is_phd" size="10"/></th>
                    <th><input value="" name="faculty_ssn_0" size="10"/></th>
                    <th><input value="" name="faculty_ssn_1" size="10"/></th>
                    <th><input value="" name="faculty_ssn_2" size="10"/></th>
                    <th><input value="" name="faculty_ssn_3" size="10"/></th>
                    <th><input value="" name="faculty_ssn_4" size="10"/></th>
                    <th><input value="" name="faculty_ssn_5" size="10"/></th>
                    <th><input value="" name="faculty_ssn_6" size="10"/></th>
                    <th><input value="" name="faculty_ssn_7" size="10"/></th>
                    <th><input value="" name="faculty_ssn_8" size="10"/></th>
                    <th><input value="" name="faculty_ssn_9" size="10"/></th>
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
						<input type="hidden" name="g_sid" value="<%=rs.getInt("stu_id")%>"/>
                  		<input type="hidden" name="f_ssn" value="<%=rs.getString("faculty_ssn")%>"/>
					<%-- Get the student_id --%>
					<td><input value=<%=rs.getInt("stu_id")%> name="graduate_student_id" size="10"/></td>
					<%-- Get the is_phd --%>
					<td><input value=<%=rs.getBoolean("is_phd")%> name="is_phd" size="10"/></td>
					<%-- Get the faculty_ssn --%>
					<td><input value=<%=rs.getString("faculty_ssn")%> name="faculty_ssn" size="10"/></td>
					<!-- Update button -->
					<td><input type="submit" value="Update"></td>
				</form>
				<form action="Thesis_committee.jsp" method="POST">
					<input type="hidden" name="action" value="delete" /> 
					<input type="hidden" value="<%=rs.getInt("stu_id")%>" name="g_sid"/>
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

<a href="Welcome.html">Back</a>

</body>
</html>
