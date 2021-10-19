<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.*, java.io.*, java.sql.*"%>
<%	request.setCharacterEncoding("UTF-8"); %>
<%
	// (1) 변수부
	String delId[] = request.getParameterValues("delId");

	String nowPage = request.getParameter("nowPage");
	String schItem = request.getParameter("schItem");
	String schWord = request.getParameter("schWord");
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

	<!-- (2) 출력부 -->
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>삭제 처리</title>

	<!-- (2-1) 폼 전송  -->
		<script>
			function retScript() {
				document.retForm.action = "A1MemList.jsp";
				document.retForm.submit();
			}
		</script>
	</head>

<body>
	<!-- (2-2) 반환 폼 -->
		<form name="retForm" method="post">
			<input type="hidden" name="nowPage" value="<%=nowPage%>">
			<input type="hidden" name="schItem" value="<%=schItem%>">
			<input type="hidden" name="schWord" value="<%=schWord%>">
		</form>

	<!-- (2-3) 삭제 및 복귀 -->	
	<%
		String id = null;
		if(delId!=null) {

			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/shmall?serverTimezone=UTC&useSSL=false", "root", "12345678");

			String sql = null;
			PreparedStatement psmt = null;

			for(int i=0; i<delId.length; i++) {
				id = delId[i];

				try {
					sql = "DELETE FROM member WHERE id=?";
					psmt = conn.prepareStatement(sql);
					psmt.setString(1, id);
					psmt.executeUpdate();
					psmt.close();

				} catch(SQLException e) {
					out.println("ex :"+ e);
				}
			}
			conn.close();
		}
		//response.sendRedirect("A1MemList.jsp");
	%>

	<script>
		alert("삭제하였습니다.");
		retScript();
	</script>
	</body>
</html>
