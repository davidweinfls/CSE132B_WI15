<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Review Schedule Page</title>
</head>
<body>

<h2>Review Schedule Form</h2>
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
          <%@ page import="java.text.*"%>
          <%-- -------- Open Connection Code -------- --%>
          <%
          
          Connection conn = null;
          PreparedStatement pstmt = null;
          PreparedStatement pstmt1 = null;
          PreparedStatement pstmt2 = null;
          PreparedStatement pstmt3 = null;
          ResultSet rs = null;
          ResultSet rs1 = null;
          
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
          
          <%-- -------- Original Form -------- --%>
          <%            
          	if (action == null) {
          		rs = statement.executeQuery("SELECT Class.class_name, Section.section_id "
          				+ "FROM Class, Section "
          				+ "WHERE Class.year = 2009 AND Class.quarter = 'Spring' "
          				+ "AND Section.class_id = Class.class_id "
          				+ "ORDER BY Class.class_name");
      	  %>
               <table border="2">
               <tr>
                   <th>Class_Name</th>
                   <th>Section_Id</th>
                   <th>Start_Date(MM/DD)</th>
                   <th>End_Date(MM/DD)</th>
                   <th></th>
               </tr>
        <%      
               while (rs.next()) {
        %>
       			<tr>
       				<form action="Review_schedule.jsp" method="POST">
       					<input type="hidden" name="action" value="show_slots"/>
                  			<input type="hidden" name="sec_id" value="<%=rs.getInt("section_id")%>"/>
       					<td><%=rs.getString("class_name")%></td>
       					<td><%=rs.getInt("section_id")%></td>
       					<td><input value="" name="start_date" size="20"/></td>
                   		<td><input value="" name="end_date" size="20"/></td>
       					<td><input type="submit" value="Select"></td>
       				</form>
       			</tr>
       	<%
               }
        } // end of original form %>
          
          <%-- -------- display_review_session_schedule -------- --%>
          <%
              // Check if an insertion is requested
              if (action != null && action.equals("show_slots")) {
              	String startDate = request.getParameter("start_date").concat("/2009");
              	String endDate = request.getParameter("end_date").concat("/2009");
              	int sectionId = Integer.parseInt(request.getParameter("sec_id"));
              	
              	Calendar startDateDate = Calendar.getInstance();
              	startDateDate.setTime(new SimpleDateFormat("MM/dd/yyyy").parse(startDate));
              	Calendar endDateDate = Calendar.getInstance(); 
                endDateDate.setTime(new SimpleDateFormat("MM/dd/yyyy").parse(endDate));
              	
              	String startWeekday = startDateDate.getTime().toString().substring(0,3);
              	String endWeekday = endDateDate.getTime().toString().substring(0,3);
				long endt = endDateDate.getTime().getTime() / (1000 * 60 * 60 * 24);
				long begt = startDateDate.getTime().getTime() / (1000 * 60 * 60 * 24);
              	int days = 1+(int)(endt - begt);

              	// Select the time to avoid based students who are in this section and their schedule
              	rs = statement.executeQuery("SELECT DISTINCT(Meeting.start_time, Meeting.end_time, "
              			+ "Meeting.day, Section.section_id), "
              			+ "Meeting.start_time, Meeting.end_time, Meeting.day, Section.section_id "
              			+ "FROM Class, Section, Section_Enrolllist, Meeting, Student "
              			+ "WHERE Class.year = 2009 AND Class.quarter = 'Spring' "
              			+ "AND Section.class_id = Class.class_id "
              			+ "AND Section.section_id = Section_Enrolllist.section_id "
              			+ "AND Meeting.section_id = Section.section_id "
              			+ "AND Section_Enrolllist.Student_id in "
              			+ "(SELECT DISTINCT s.student_id "
              			+ "FROM Student s, Section_Enrolllist e "
              			+ "WHERE s.student_id = e.student_id "
              			+" AND e.section_id = " + sectionId + ")");
              		
              	ArrayList<String> sTime = new ArrayList<String>();
              	ArrayList<String> eTime = new ArrayList<String>();
              	ArrayList<String> wDay = new ArrayList<String>();
              	
              	// keep all time slots by default
              	boolean[] skip = new boolean[5*12];
              		
              	for( int i = 0; i < skip.length; i++ ){
              		skip[i] = false;
              	}
              			
              	while( rs.next() ){
              		sTime.add(rs.getString("start_time"));
              		eTime.add(rs.getString("end_time"));
              		wDay.add(rs.getString("day"));
              	}
              	
              	Hashtable<String, Integer> wDayTable = new Hashtable<String, Integer>();
             	
              	wDayTable.put("Mon", 0);
              	wDayTable.put("Tue", 1);
              	wDayTable.put("Wed", 2);
              	wDayTable.put("Thu", 3);
              	wDayTable.put("Fri", 4);

              	
              	for(int i = 0; i < wDay.size(); i++ ){
              		int wDayInt = wDayTable.get(wDay.get(i));
              		// get the first 2 char of string start time to skip it
              		int startSkip = Integer.parseInt(sTime.get(i).substring(0,2)); 
              		// get the first 2 char of string end time to skip it
              		int endSkip = Integer.parseInt(eTime.get(i).substring(0,2));
              		// if end on XX:00, XX should not be skipped
              		if( eTime.get(i).substring(3,5).equals("00") ){
              			endSkip--;
              		}
              		/*
              		endSkip: included
              		
              		Mon
              		
              		start:9:00 -> 9
              		end:14:00 -> 13
              		
              		index: 1,2,3,4,5
              		*/
              		for(; startSkip <= endSkip; startSkip++ ){
              			int toSkip = wDayInt * 12 + startSkip - 8;
              			skip[toSkip] = true;
              		}
              	}
              	
              	ArrayList<String> sessionTime = new ArrayList<String>();
              	
              	// use a for loop to check the availability for each weekday within the time prriod
              	// add them into sessionTime arrayList for printing further
                for( ; days > 0; days-- ){
                	String curMonth = startDateDate.getTime().toString().substring(4, 7);
                	if( curMonth.equals("Apr") || curMonth.equals("May") || curMonth.equals("Jun") ){
	                  	if( !startWeekday.equals("Sat") && !startWeekday.equals("Sun")){
    	              		int currentWeekDay = wDayTable.get(startWeekday);
        	          		for( int cur = 0; cur < 12; cur++ ){
            	      			int sHour = cur + 8;
                  			int eHour = cur + 9;
                	  			if( !skip[currentWeekDay*12 + cur] ){
                  					sessionTime.add(startDateDate.getTime().toString().substring(0,10) 
                  							+ " " + sHour + ":00 - " + eHour + ":00" );
                  				}
                  			}
                  		}
                	}
                  	
					// update start day info
              		startDateDate.add(Calendar.DATE, 1);
              		startWeekday = startDateDate.getTime().toString().substring(0,3);
                }
              	
				conn.setAutoCommit(false);
				
				
           %>
                 <table border="2">
                 <tr>
                     <th>Request Section Id</th>
                     <th>Available Review Session Time Slot</th>
                 </tr>
           <%
              	for (int ct = 0; ct < sessionTime.size(); ct++) {
           %>
	           <tr>
					<td><%=sectionId%></td>
					<td><%=sessionTime.get(ct)%></td>
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
<a href="Review_schedule.jsp">Refresh</a>

</body>
</html>
