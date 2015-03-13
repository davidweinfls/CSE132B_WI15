<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Review Session Page</title>
</head>
<body>

<h2>Review Session Form</h2>
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
            
            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/cse132b?" +
                    "user=postgres&password=postgres&stringtype=unspecified");
                Statement stmt = conn.createStatement();
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
                    rs = stmt.executeQuery( "SELECT count(*) FROM Meeting" );
                    rs.next();
                    beforeCount = rs.getInt("count");
                    		
                    pstmt = conn
                    .prepareStatement("INSERT INTO Meeting (type, mandatory, weekly, start_time, end_time, date, building_room, day, section_id)" + 
                    " VALUES ('review', ?, false, ?, ?, ?, ?, ?, ?)");
                    
                    pstmt.setBoolean(1, Boolean.parseBoolean(request.getParameter("mandatory")));
                    pstmt.setString(2, request.getParameter("start_time"));
                    pstmt.setString(3, request.getParameter("end_time"));
                    pstmt.setString(4, request.getParameter("date"));
                    pstmt.setString(5, request.getParameter("building_room"));
                    pstmt.setString(6, request.getParameter("day"));
                    pstmt.setInt(7, Integer.parseInt(request.getParameter("section_id")));
                    int rowCount = pstmt.executeUpdate();

                    int afterCount = 0;
                    rs = stmt.executeQuery( "SELECT count(*) FROM Meeting" );
                    rs.next();
                    afterCount = rs.getInt("count");
                    
                    if( beforeCount == afterCount ){
                    	%>
                    	<p>Error when inserting, time conflicts.</p>
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

                    rs = stmt.executeQuery( "SELECT * FROM Meeting WHERE meeting_id = " +
                    		Integer.parseInt(request.getParameter("m_id")) );
                    rs.next();
                    boolean man = rs.getBoolean("mandatory");
                    String sta = rs.getString("start_time");
                    String end = rs.getString("end_time");
                    String dat = rs.getString("date");
                    String bui = rs.getString("building_room");
                    String day = rs.getString("day");
                    int sec = rs.getInt("section_id");
                    // Create the prepared statement and use it to
                    // UPDATE student values in the Students table.
                    pstmt = conn
                        .prepareStatement("UPDATE Meeting SET mandatory = ?, start_time = ?, end_time = ?,"
                        	+ "	date = ?, building_room = ?, day = ? WHERE meeting_id = ?");

                    pstmt.setBoolean(1, Boolean.parseBoolean(request.getParameter("mandatory")));
                    pstmt.setString(2, request.getParameter("start_time"));
                    pstmt.setString(3, request.getParameter("end_time"));
                    pstmt.setString(4, request.getParameter("date"));
                    pstmt.setString(5, request.getParameter("building_room"));
                    pstmt.setString(6, request.getParameter("day"));
                    pstmt.setInt(7, Integer.parseInt(request.getParameter("m_id")));
                    int rowCount = pstmt.executeUpdate();
					
                    rs1 = stmt.executeQuery( "SELECT * FROM Meeting WHERE meeting_id = " +
                    		Integer.parseInt(request.getParameter("m_id")) );
                    if( rs1.next() && 
                    		man == rs1.getBoolean("mandatory") &&
                    		sta.equals( rs1.getString("start_time") ) &&
                    		end.equals(rs1.getString("end_time") ) &&
                    		dat.equals( rs1.getString("date") ) &&
                    		bui.equals( rs1.getString("building_room") ) &&
                    		day.equals( rs1.getString("day") ) &&
                    		sec == rs1.getInt("section_id") ){
                    	%>
                    	<p>Error when updating, time conflicts.</p>
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
                        .prepareStatement("DELETE FROM Meeting WHERE m_id = ?");

                    pstmt.setInt(1, Integer.parseInt(request.getParameter("m_id")));
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
                rs = statement.executeQuery("SELECT * FROM Meeting where type = 'review'");
            %>
            
            <!-- Add an HTML table header row to format the results -->
            <table border="2">
            <tr>
                <th>mandatory</th>
                <th>start_time</th>
                <th>end_time</th>
                <th>date</th>
                <th>building_room</th>
                <th>day</th>
                <th>section_id</th>
            </tr>
            
            <!-- An empty row with blankets for user to type in -->
            <tr>
                <form action="Review_session.jsp" method="POST">
                    <input type="hidden" name="action" value="insert"/>
                    <th><input value="" name="mandatory" size="5"/></th>
                    <th><input value="" name="start_time" size="10"/></th>
                    <th><input value="" name="end_time" size="10"/></th>
                    <th><input value="" name="date" size="10"/></th>
                    <th><input value="" name="building_room" size="10"/></th>
                    <th><input value="" name="day" size="10"/></th>
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
                  		<input type="hidden" name="m_id" value="<%=rs.getInt("meeting_id")%>"/>
					<%-- Get the student_id --%>
					<td><input value=<%=rs.getBoolean("mandatory")%> name="mandatory" size="5"/></td>
					<td><input value=<%=rs.getString("start_time")%> name="start_time" size="10"/></td>
					<td><input value=<%=rs.getString("end_time")%> name="end_time" size="10"/></td>
					<%-- Get the class_id --%>
					<td><input value=<%=rs.getString("date")%> name="date" size="10"/></td>
					<%-- Get the grade --%>
					<td><input value=<%=rs.getString("building_room")%> name="building_room" size="10"/></td>
					<td><input value=<%=rs.getString("day")%> name="day" size="10"/></td>
					<td><%=rs.getInt("section_id")%></td>
					<!-- Update button -->
					<td><input type="submit" value="Update"></td>
				</form>
				<form action="Review_session.jsp" method="POST">
					<input type="hidden" name="action" value="delete" /> 
					<input type="hidden" name="m_id" value="<%=rs.getInt("meeting_id")%>"/>
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
