<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Probation Page</title>
</head>
<body>

<h2>Probation Entry Form</h2>
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

                	Integer startYear;
                	Integer endYear;
                	Integer proId;
                    String startQuarter = "";
                    String endQuarter = "";

                    boolean insert = false;
                   
                	// get the infomation from the table and validate
                	
                    proId = Integer.parseInt(request.getParameter("pro_id"));
                	startYear = Integer.parseInt(request.getParameter("start_year"));
                	endYear = Integer.parseInt(request.getParameter("end_year"));
                	startQuarter = request.getParameter("start_quarter");
            		endQuarter = request.getParameter("end_quarter");
            		
                	if( startYear < endYear ) {
                		insert = true;	
                	}
                	else if( startYear.equals(endYear) ) {
                		
                		// winter * ANY
                		// ANY * fall
                		// A * A
                		// spring * summer
                		if( startQuarter.equals("winter") || endQuarter.equals("fall") || 
                				startQuarter.equals(endQuarter) ||
                				( startQuarter.equals("spring") && endQuarter.equals("summer") ) ){
                			insert = true;
                		}
                	}

                	if (insert) {
                		// Create the statement
                    	Statement stmt = conn.createStatement();

	                    // Create the prepared statement and use it to
    	                // SELECT faculty_department.
        	            rs = stmt.executeQuery("SELECT * from Student where student_id = " + proId);
            	    	if( rs.next () ){
                       		conn.setAutoCommit(false);

           		            // Create the prepared statement and use it to
            	            // INSERT probation values INTO the probation table.
       	                    pstmt = conn.prepareStatement(
       	                    	"INSERT INTO Probation (pro_id, start_year, end_year, start_quarter, end_quarter, reason)" + 
                                		" VALUES (?, ?, ?, ?, ?, ?)");

                            pstmt.setInt(1, proId);
                            pstmt.setInt(2, startYear);
                            pstmt.setInt(3, endYear);
                            pstmt.setString(4, startQuarter);
                            pstmt.setString(5, endQuarter);
                            pstmt.setString(6, request.getParameter("reason"));
                        	
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

                    // Begin transaction
                    conn.setAutoCommit(false);

                    Integer startYear;
                	Integer endYear;
                    String startQuarter = "";
                    String endQuarter = "";

                    boolean update = false;
                   
                	// get the infomation from the table and validate
                	
                	startYear = Integer.parseInt(request.getParameter("start_year"));
                	endYear = Integer.parseInt(request.getParameter("end_year"));
                	startQuarter = request.getParameter("start_quarter");
            		endQuarter = request.getParameter("end_quarter");
            		
                	if( startYear < endYear ) {
                		update = true;	
                	}
                	else if( startYear.equals(endYear) ) {
                		
                		// winter * ANY
                		// ANY * fall
                		// A * A
                		// spring * summer
                		if( startQuarter.equals("winter") || endQuarter.equals("fall") || 
                				startQuarter.equals(endQuarter) ||
                				( startQuarter.equals("spring") && endQuarter.equals("summer") ) ){
                			update = true;
                		}
                	}
                	
                	if( update ){
                    	// Create the prepared statement and use it to
                    	// UPDATE student values in the Students table.
                    	pstmt = conn
                        	.prepareStatement("UPDATE Probation SET start_year = ?, end_year = ?, "
                        		+ "start_quarter = ?, end_quarter = ?, reason = ? "
                  				+ " WHERE pro_id = ? AND start_year = ? AND end_year = ? AND "
                                + "start_quarter = ? AND end_quarter = ? ");

                    	pstmt.setInt(1, startYear);
                    	pstmt.setInt(2, endYear);
                    	pstmt.setString(3, startQuarter);
                    	pstmt.setString(4, endQuarter);
                    	pstmt.setString(5, request.getParameter("reason"));
                    	pstmt.setInt(6, Integer.parseInt(request.getParameter("p_id")));
                    	pstmt.setInt(7, Integer.parseInt(request.getParameter("sy")));
                    	pstmt.setInt(8, Integer.parseInt(request.getParameter("ey")));
                    	pstmt.setString(9, request.getParameter("sq"));
                   		pstmt.setString(10, request.getParameter("eq"));
                    
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
                        .prepareStatement("DELETE FROM Probation "
                        		+ " WHERE pro_id = ? AND start_year = ? AND end_year = ? AND "
                                + "start_quarter = ? AND end_quarter = ? ");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("p_id")));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("sy")));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("ey")));
                    pstmt.setString(4, request.getParameter("sq"));
                    pstmt.setString(5, request.getParameter("eq"));
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
                rs = statement.executeQuery("SELECT * FROM Probation");
            %>
            
            <!-- Add an HTML table header row to format the results -->
            <table border="2">
            <tr>
                <th>Probatiom_ID</th>
                <th>Start_year</th>
                <th>End_year</th>
                <th>Start_quarter</th>
                <th>End_quarter</th>
                <th>Reason</th>
            </tr>
            
            <!-- An empty row with blankets for user to type in -->
            <tr>
                <form action="Probation.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <th><input value="" name="pro_id" size="10"/></th>
                    <th><input value="" name="start_year" size="10"/></th>
                    <th><input value="" name="end_year" size="10"/></th>
                    <th><input value="" name="start_quarter" size="10"/></th>
                    <th><input value="" name="end_quarter" size="10"/></th>
                    <th><input value="" name="reason" size="10"/></th>
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
						<input type="hidden" name="p_id" value="<%=rs.getInt("pro_id")%>"/>
						<input type="hidden" name="sy" value="<%=rs.getInt("start_year")%>"/>
                  		<input type="hidden" name="ey" value="<%=rs.getInt("end_year")%>"/>
                  		<input type="hidden" name="sq" value="<%=rs.getString("start_quarter")%>"/>
                  		<input type="hidden" name="eq" value="<%=rs.getString("end_quarter")%>"/>
                  		
                  		
					<%-- Get the student_id --%>
					<td><input value=<%=rs.getInt("pro_id")%> name="pro_id" size="10"/></td>
					<%-- Get the is_phd --%>
					<td><input value=<%=rs.getInt("start_year")%> name="start_year" size="10"/></td>
					<%-- Get the faculty_ssn --%>
					<td><input value=<%=rs.getInt("end_year")%> name="end_year" size="10"/></td>
					<%-- Get the faculty_ssn --%>
					<td><input value=<%=rs.getString("start_quarter")%> name="start_quarter" size="10"/></td>
					<%-- Get the faculty_ssn --%>
					<td><input value=<%=rs.getString("end_quarter")%> name="end_quarter" size="10"/></td>
					<%-- Get the faculty_ssn --%>
					<td><input value=<%=rs.getString("reason")%> name="reason" size="10"/></td>
					<!-- Update button -->
					<td><input type="submit" value="Update"></td>
				</form>
				<form action="Probation.jsp" method="POST">
					<input type="hidden" name="action" value="delete" /> 
					<input type="hidden" name="p_id" value="<%=rs.getInt("pro_id")%>"/>
					<input type="hidden" name="sy" value="<%=rs.getInt("start_year")%>"/>
                  	<input type="hidden" name="ey" value="<%=rs.getInt("end_year")%>"/>
                  	<input type="hidden" name="sq" value="<%=rs.getString("start_quarter")%>"/>
                  	<input type="hidden" name="eq" value="<%=rs.getString("end_quarter")%>"/>
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
