<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.io.*, java.sql.*"%>
<%	request.setCharacterEncoding("UTF-8"); %>
<%
	// (1) 변수부
	String id 		= request.getParameter("id");
	String nickName = request.getParameter("nickName");
	String password = request.getParameter("password");

	String name 	= request.getParameter("name");

	String tel1 	= request.getParameter("selTel1");
	String tel2 	= request.getParameter("tel2");
	String tel3 	= request.getParameter("tel3");
	String phone 	= tel1 + "-" + tel2 + "-" + tel3;

	String bYear 	= request.getParameter("bYear");
	String bMonth 	= request.getParameter("bMonth");
	String bDay 	= request.getParameter("bDay");	
	String birthday = bYear + "-" + bMonth + "-" + bDay;

	String job 	= request.getParameter("selJob");

	String email1 	= request.getParameter("email1");
	String email2 	= request.getParameter("email2");
	String email = email1 + "@" + email2;

	String zipCode 		= request.getParameter("zipCode");
	String doroAddress 	= request.getParameter("doroAddress");
	String doroAddress2	= request.getParameter("doroAddress2");

	String jibunAddress = request.getParameter("jibunAddress");
	String jibunAddress2	= request.getParameter("inserJibun");
	if(doroAddress2==null)	doroAddress2 = "";
	if(jibunAddress2==null)	jibunAddress2 = "";

	String nowPage = request.getParameter("nowPage");
	String schItem = request.getParameter("schItem");
	String schWord = request.getParameter("schWord");
	//System.out.println("pname :"+ pname);
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

	<!-- (2) 출력부 -->
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>가입 처리</title>

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
		<!--  arert()가 동작하지 않아서 retForm을 뒤가 아닌  앞에 선언 : ? -->
		<!-- 폼이 있을 때 버턴의 실행 위치는 어떤 곳에 있든지 상관이 없지만 스크립트 함수의 위치는 반듯이 폼 아래에 있어야 한다.-->
  		<!-- 왜냐하면 버턴은 이벤트로 작동하는데 비해 스크립트 함수는 코드 순서로 작동하기 때문 이동 전에 전송할 폼을 파싱하기 때문이다.-->
		
		<form name="retForm" method="post">
			<input type="hidden" name="nowPage" value="<%=nowPage%>">
			<input type="hidden" name="schItem" value="<%=schItem%>">
			<input type="hidden" name="schWord" value="<%=schWord%>">
		</form>

	<!-- (2-3) 저장 및 복귀 -->
	<%
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/shmall?serverTimezone=UTC&useSSL=false","root", "12345678");
	
		String sql = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;

		try {
			sql = "INSERT INTO member(id, nickName, password, name, phone, ";
			sql = sql + "birthday, job, email, zipCode, doroAddress, doroAddress2, jibunAddress, jibunAddress2, regDate) ";
			sql = sql + "VALUES(?, ?, ?, ?, ?,  ?, ?, ?, ?, ?,  ?, ?, ?, curdate())";
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
			psmt.executeUpdate();
			psmt.close();
	%>
		<script>
				alert("입력하였습니다.");
				retScript();
		</script>
	<%
		} catch (SQLException e) {
			out.println(e);
		}
		conn.close();
	%>
	</body>
</html>