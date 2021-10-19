<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.io.*, java.sql.*"%>
<%	request.setCharacterEncoding("UTF-8"); %>
<%
	// (1) 변수부
	String existId	= request.getParameter("existId"); // 목록 id
	String id		= request.getParameter("id"); // 수정 id
	String nickName 	= request.getParameter("nickName");
	String password = request.getParameter("password");

	String name 	= request.getParameter("name");

	String tel1 	= request.getParameter("tel1");
	String tel2 	= request.getParameter("tel2");
	String tel3 	= request.getParameter("tel3");
	String phone 	= tel1 + "-" + tel2 + "-" + tel3;

	String bYear 	= request.getParameter("bYear");
	String bMonth 	= request.getParameter("bMonth");
	String bDay 	= request.getParameter("bDay");
	String birthday = bYear + "-" + bMonth + "-" + bDay;
	
	String job		= request.getParameter("selJob");
	String email 	= request.getParameter("email");

	String zipCode 		= request.getParameter("zipCode");
	String doroAddress 	= request.getParameter("doroAddress");
	String doroAddress2	= request.getParameter("doroAddress2");
	//System.out.println("doroAddress :"+ doroAddress2);
	String jibunAddress = request.getParameter("jibunAddress");
	String jibunAddress2	= request.getParameter("jibunAddress2");

	String nowPage = request.getParameter("nowPage");
	String schItem = request.getParameter("schItem");
	String schWord = request.getParameter("schWord");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

	<!-- (2) 출력부 -->
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>수정 처리</title>

	<!-- (2-1) 폼 전송  -->
		<script>
			function retScript() {
				document.retForm.action = "D1Update.jsp";
				document.retForm.submit();
			} 
		</script> 
	</head>

	<body>
	<!-- (2-2) 반환 폼 -->
		<form name="retForm" method="post">
			<input type="hidden" name="id" value="<%=id%>">
			<input type="hidden" name="nowPage" value="<%=nowPage%>">
			<input type="hidden" name="schItem" value="<%=schItem%>">
			<input type="hidden" name="schWord" value="<%=schWord%>">
		</form>

	<!-- (2-3) 중복 아이디 검색, 저장 및 복귀 -->
	<%
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/shmall?serverTimezone=UTC&useSSL=false","root", "12345678");

		PreparedStatement psmt = null;
		ResultSet rs = null;
		String sql = null;
	
		try {
			sql = "SELECT COUNT(id) FROM member WHERE id=? && NOT id=?";
			psmt = conn.prepareStatement(sql);
			psmt.setString(1, id);  // 수정 id
			psmt.setString(2, existId); // 목록 id
	
			rs = psmt.executeQuery();
			boolean exist = false;
			int x = 0;
			if(rs.next())		x = rs.getInt(1);
			if(x>0)				exist = true; // x>0 중복 : 사용 불가능 : 
			//System.out.println("id :"+id);
			//System.out.println("existId :"+existId);
			//System.out.println("exist :"+exist);
			//System.out.println("name :"+name);
			rs.close();
			psmt.close();

			if(exist==true) {
%>
	<script>
				alert("입력한 아이디는 이미 사용중이므로 새로운 아이디를 입력하십시오 !");
				history.back(-1);
	</script>
<%
			} else {
				sql = "UPDATE member SET id=?, nickName=?, password= ?, name=?, phone=?, ";
				sql = sql + "birthday=?, job=?, email=?, zipCode=?, doroAddress=?, doroAddress2=?, jibunAddress=?, jibunAddress2=? "; 
				sql = sql + "WHERE id=?"; //id=?";
	
				psmt = conn.prepareStatement(sql);
				psmt.setString(1, id);
				psmt.setString(2, nickName);
				psmt.setString(3, password);
				psmt.setString(4, name);
				psmt.setString(5, phone);
				psmt.setString(6, birthday);
				psmt.setString(7, job);
				psmt.setString(8, email);
				psmt.setString(9, zipCode);
				psmt.setString(10, doroAddress);
				psmt.setString(11, doroAddress2);
				psmt.setString(12, jibunAddress);
				psmt.setString(13, jibunAddress2);
				psmt.setString(14, existId);
				psmt.executeUpdate();
				psmt.close();
	%>
	<script>
				alert("수정하였습니다.");
				retScript();
	</script>
	<%	
			}
		} catch (SQLException e) {
			out.println("ex :"+ e);
		}
		conn.close();
	%>

	</body>
</html>