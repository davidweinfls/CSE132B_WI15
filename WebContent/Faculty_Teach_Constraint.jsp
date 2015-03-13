<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Faculty Teach Constraint Page</title>
</head>
<body>

<h2>Faculty Teach Constraint Form</h2>
<table>
    <tr>
        <td valign="top">
            <%-- -------- Include menu HTML code -------- --%>
            <%-- <jsp:include page="/hearder.html" /> --%>
        </td>
        <td>
            <%-- Import the java.sql package --%>
            <%@ page import="java.sql.*"%>
            <%-- -------- Open Connection Code -------- --%>
            <%
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            ResultSet rs1 = null;
            ResultSet rs2 = null;
            
            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/cse132b?" +
                    "user=postgres&password=postgres");
                Statement stmt = conn.createStatement();
                
             // Create triggers
                String func = 
                	"CREATE OR REPLACE FUNCTION checkTeachingOverlap() RETURNS TRIGGER AS $retTeaching$ " +
                	"BEGIN " +
                	"DROP TABLE IF EXISTS New_Faculty_Section; " +
               		"CREATE TABLE New_Faculty_Section AS ( " +
               		"SELECT NEW.faculty_ssn, Meeting.meeting_id, " + 
               		"Meeting.start_time, Meeting.end_time, Meeting.day, Meeting.section_id " +
               		"FROM Meeting " +
               		"WHERE NEW.section_id = Meeting.section_id); " +
               		"DROP TABLE IF EXISTS Faculty_Section; " +
               		"CREATE TABLE Faculty_Section AS ( " +
               		"SELECT Faculty_Teach_Section.faculty_ssn, Meeting.meeting_id,  " +
               		"Meeting.start_time, Meeting.end_time, Meeting.day, Meeting.section_id " +
               		"FROM Meeting, Faculty_Teach_Section " +
               		"WHERE Faculty_Teach_Section.section_id = Meeting.section_id); " +
               		"IF EXISTS( SELECT * " +
               		"FROM New_Faculty_Section, Faculty_Section " +
               		"WHERE New_Faculty_Section.section_id <> Faculty_Section.section_id " +
               		"AND New_Faculty_Section.day = Faculty_Section.day " +
               		"AND New_Faculty_Section.faculty_ssn = Faculty_Section.faculty_ssn    " +
               		"AND (Faculty_Section.start_time, Faculty_Section.end_time)  " +
                	"OVERLAPS (New_Faculty_Section.start_time, New_Faculty_Section.end_time)) " +
                	"THEN RETURN NULL; " +
               		"ELSE RETURN NEW; " +
             	  	"END IF; " +
               		"END; " +
                	"$retTeaching$ LANGUAGE plpgsql;";
                pstmt = conn.prepareStatement(func);
                int rowCount2 = pstmt.executeUpdate();
                
                String trigger = 
                	"DROP TRIGGER IF EXISTS TeachingOverlap ON Faculty_Teach_Section;" +
        			"CREATE TRIGGER TeachingOverlap " +
					"BEFORE INSERT ON Faculty_Teach_Section " +
					"FOR EACH ROW EXECUTE PROCEDURE checkTeachingOverlap();";
        		pstmt = conn.prepareStatement(trigger);
        		int rowCount3 = pstmt.executeUpdate();
        		
        		String func2 = 
        			"CREATE OR REPLACE FUNCTION checkTeachingOverlapUpdate() RETURNS TRIGGER AS $retTeachingUpdate$ " +
        			"BEGIN " +
        			"DROP TABLE IF EXISTS New_Faculty_Section; " +
        			"CREATE TABLE New_Faculty_Section AS ( " +
        			"SELECT NEW.faculty_ssn, Meeting.meeting_id, " +
        			"Meeting.start_time, Meeting.end_time, Meeting.day, Meeting.section_id " +
        			"FROM Meeting " +
        			"WHERE NEW.section_id = Meeting.section_id); " +
        			"DROP TABLE IF EXISTS Faculty_Section; " +
        			"CREATE TABLE Faculty_Section AS ( " +
        			"SELECT Faculty_Teach_Section.faculty_ssn, Meeting.meeting_id, " + 
        			"Meeting.start_time, Meeting.end_time, Meeting.day, Meeting.section_id " +
        			"FROM Meeting, Faculty_Teach_Section " +
        			"WHERE Faculty_Teach_Section.section_id = Meeting.section_id); " +
        			"IF EXISTS( SELECT * " +
        			"FROM New_Faculty_Section, Faculty_Section " +
        			"WHERE New_Faculty_Section.section_id <> Faculty_Section.section_id " +
        			"AND New_Faculty_Section.day = Faculty_Section.day " +
        			"AND New_Faculty_Section.faculty_ssn = Faculty_Section.faculty_ssn " +
        			"AND (Faculty_Section.start_time, Faculty_Section.end_time)  " +
        			"OVERLAPS (New_Faculty_Section.start_time, New_Faculty_Section.end_time)) " +
        			"THEN RETURN NULL; " +
        			"ELSE RETURN NEW; " +
        			"END IF; " +
        			"END; " +
        			"$retTeachingUpdate$ LANGUAGE plpgsql;";
        		pstmt = conn.prepareStatement(func2);
                int rowCount4 = pstmt.executeUpdate();
                        
                String trigger2 = 
                	"DROP TRIGGER IF EXISTS TeachingOverlapUpdate ON Faculty_Teach_Section;" +
                	"CREATE TRIGGER TeachingOverlapUpdate " +
					"BEFORE Update ON Faculty_Teach_Section " +
					"FOR EACH ROW EXECUTE PROCEDURE checkTeachingOverlapUpdate();";
                pstmt = conn.prepareStatement(trigger);
                int rowCount5 = pstmt.executeUpdate();
                
            %>
            
            <%-- -------- INSERT Code -------- --%>
            <%
                String action = request.getParameter("action");
                // Check if an insertion is requested
                if (action != null && action.equals("insert")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    // INSERT student values INTO the students table.
                    int beforeCount = 0;
                    rs = stmt.executeQuery( "SELECT count(*) FROM Faculty_teach_section" );
                    rs.next();
                    beforeCount = rs.getInt("count");
                    		
                    pstmt = conn
                    .prepareStatement("INSERT INTO Faculty_teach_section (faculty_ssn, section_id) " + 
                    	"VALUES (?, ?)");
                    
                    pstmt.setString(1, request.getParameter("faculty_ssn"));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("section_id")));
                    int rowCount = pstmt.executeUpdate();

                    int afterCount = 0;
                    rs = stmt.executeQuery( "SELECT count(*) FROM Faculty_teach_section" );
                    rs.next();
                    afterCount = rs.getInt("count");
                    
                    if( beforeCount == afterCount ){
                    	%>
                    	<p>Error when inserting, time conflicts for another class the professor teaches.</p>
                    	<%
                    }
                    
                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                }
            %>
            
            <%-- -------- UPDATE Code -------- --%>
            <%
                // Check if an update is requested
                if (action != null && action.equals("update")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

/*                    rs2 = stmt.executeQuery( "SELECT * FROM Faculty_teach_section WHERE faculty_ssn = '" +
                    		request.getParameter("faculty_ssn") + "' and section_id = " + 
                    		Integer.parseInt(request.getParameter("section_id")));
                    rs2.next();
                    String fac = rs2.getString("faculty_ssn");
                    int sec = rs2.getInt("section_id");*/
                    // Create the prepared statement and use it to
                    // UPDATE student values in the Students table.			
                    pstmt = conn
                        .prepareStatement("UPDATE Faculty_teach_section SET faculty_ssn = ?, section_id = ?" +
                        		" WHERE faculty_ssn = ? AND section_id = ?");
                            
                    pstmt.setString(1, request.getParameter("faculty_ssn"));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("section_id")));
                    String oldSsn = request.getParameter("f_ssn");
                    pstmt.setString(3, oldSsn);
                    int oldSid = Integer.parseInt(request.getParameter("s_id"));
                    pstmt.setInt(4, oldSid);
                    int rowCount = pstmt.executeUpdate();
                    
                    rs2 = stmt.executeQuery( "SELECT * FROM Faculty_teach_section WHERE faculty_ssn = '" +
                    		oldSsn + "' and section_id = " + oldSid);       
                                        
                    if( rs2.next() ){
                    	%>
                    	<p>Error when updating, time conflicts for another class the professor teaches.</p>
                    	<%
                    	
                    }
                    
                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
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
                        .prepareStatement("DELETE FROM Faculty_teach_section WHERE " +
                        		"faculty_ssn = ? AND section_id = ?");

                    pstmt.setString(1, request.getParameter("f_ssn"));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("s_id")));
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
                rs = statement.executeQuery("SELECT * FROM Faculty_teach_section ORDER BY faculty_ssn");
            %>
            
            <!-- Add an HTML table header row to format the results -->
            <table border="2">
            <tr>
            	<th>Faculty_ssn</th>
                <th>Section_id</th>
            </tr>
            
            <!-- An empty row with blankets for user to type in -->
            <tr>
                <form action="Faculty_Teach_Constraint.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <th><input value="" name="faculty_ssn" size = "10"/></th>
                    <th><input value="" name="section_id" size="10"/></th>
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
                  		<input type="hidden" name="f_ssn" value="<%=rs.getString("faculty_ssn")%>"/>
                  		<input type="hidden" name="s_id" value="<%=rs.getInt("section_id")%>"/>
					<%-- Get the student_id --%>
					<td><input value=<%=rs.getString("faculty_ssn")%> name="faculty_ssn" size="10"/></td>
					<td><input value=<%=rs.getInt("section_id")%> name="section_id" size="10"/></td>
					<!-- Update button -->
					<td><input type="submit" value="Update"></td>
				</form>
				<form action="Faculty_Teach_Constraint.jsp" method="POST">
					<input type="hidden" name="action" value="delete" /> 
						<input type="hidden" name="f_ssn" value="<%=rs.getString("faculty_ssn")%>"/>
                  		<input type="hidden" name="s_id" value="<%=rs.getInt("section_id")%>"/>
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
