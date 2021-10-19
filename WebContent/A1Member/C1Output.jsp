<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.io.*, java.sql.*"%>
<%	request.setCharacterEncoding("UTF-8"); %>
<%
	// (1) 변수부
	String aname = "관리자"; 

	// (1-1) 수신 변수
	String id = request.getParameter("id");
	String nowPage = request.getParameter("nowPage");
	String schItem = request.getParameter("schItem");
	String schWord = request.getParameter("schWord");
%>

<%
	// (1-2) 테이블 변수
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/shmall?serverTimezone=UTC&useSSL=false","root", "12345678");

	PreparedStatement psmt = null;
	ResultSet rs = null;
	String sql = null;

	String nickName=null, password=null, name=null, phone=null, birthday=null, job=null, email=null;
	String zipCode=null, doroAddress=null, doroAddress2=null, jibunAddress=null, jibunAddress2=null, regDate=null;

	try {
		sql = "SELECT * FROM member WHERE id=?";
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, id);

		rs = psmt.executeQuery();
		while(rs.next()) {
			//id = rs.getString("id");
			nickName = rs.getString("nickName");
			password = rs.getString("password");
			name = rs.getString("name");
			phone = rs.getString("phone");
			birthday = rs.getString("birthday");
			job = rs.getString("job");
			email = rs.getString("email");
			zipCode = rs.getString("zipCode");
			doroAddress = rs.getString("doroAddress");
			doroAddress2 = rs.getString("doroAddress2");
			jibunAddress = rs.getString("jibunAddress");
			jibunAddress2 = rs.getString("jibunAddress2");
			if(doroAddress2==null)	doroAddress2 = "";
			if(jibunAddress2==null)	jibunAddress2 = "";

			regDate = rs.getString("regDate");
		}
		rs.close();
		psmt.close();
	} catch(SQLException e) {
		out.println("ex :"+ e);
	}
	conn.close();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

	<!-- (2) 출력부 -->
<html>
	<head>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8">
		<title>회원 출력</title>

	<!-- (2-1) 폼 전송  -->
		<script>
			function retBtn() {
				document.retForm.action="A1MemList.jsp";
				document.retForm.submit();
			}
		</script>
	</head>

	<body>
	<!-- (2-2) 알림 -->
		<center>
		<table width="94%" bgcolor="#b0e0e6">
			<tr><td width="20%" align="center">우리들 쇼핑몰</td>
				<td width="54%">
					<marquee direction="left" style="color: navy;" onmouseover="stop()" onmouseout="start()">
						<font size="3" color="gray">목록 버턴은 목록 화면으로 복귀합니다.!!</font>
					</marquee></td>
				<td width="20%" align="center">관리자</td></tr>
		</table></br>

	<!-- (2-3) 버턴 -->
		<table width="94%">
			<tr><td align="right">
					<input type="button" value="목록 " onClick="retBtn()">&nbsp;&nbsp;&nbsp;
			</td></tr>
		</table><br/>

	<!-- (2-4) 출력 폼 -->
		<table width="94%" border="0" rules="none" bgcolor="#b0e0e6">
			<tr><td width="15%">&nbsp;</td>
				<td width="35%">&nbsp;</td>
				<td width="15%">&nbsp;</td>
				<td width="35%">&nbsp;</td></tr>

			<tr><td>&nbsp;&nbsp; 아  이  디 :</td>
				<td><%=id%></td>

				<td>적립 포인트 :</td>
				<td><%=nickName%></td></tr>
	
			<tr><td>&nbsp;&nbsp; 비 밀 번 호 :</td>
				<td><%=password%></td>
				<td colspan="2">&nbsp;</td></tr>
			<tr><td colspan="4">&nbsp;</td></tr>

			<tr><td>&nbsp;&nbsp; 이     름 :</td>
				<td><%=name%></td>
	
				<td>전 화 번 호 :</td>
				<td><%=phone%></td></tr>
				
			<tr><td>&nbsp;&nbsp; 생    일  :</td>
				<td><%=birthday%></td>
	
				<td>직    업  :</td>
				<td><%=job%></td></tr>
			<tr><td colspan="4">&nbsp;</td></tr>

			<tr><td>&nbsp;&nbsp; 이  메  일 :</td>
				<td colspan="3"><%=email%></td></tr>
			<tr><td colspan="4">&nbsp;</td></tr>

			<tr><td>&nbsp;&nbsp; 우 편 번 호 :</td>
				<td  colspan="3"><%=zipCode%></td></tr>
			<tr><td>&nbsp;&nbsp; 도로명 주소 :</td>
				<td  colspan="3">
					<%=doroAddress%>&nbsp;&nbsp;&nbsp;&nbsp; <%=doroAddress2%></td></tr>

			<tr><td>&nbsp;&nbsp; 지번명 주소 :</td>
				<td  colspan="3">
					<%=jibunAddress%>&nbsp;&nbsp;&nbsp;&nbsp;<%=jibunAddress2%></td></tr>
			<tr><td colspan="4">&nbsp;</td></tr>

			<tr><td>&nbsp;&nbsp; 등록 일자 :</td>
				<td colspan="3"><%=regDate%></td></tr>
			<tr><td colspan="4">&nbsp;</td></tr>

		</table></br>
		</center>

	<!-- (2-5) 반환 폼 -->
		<form name="retForm" method="post">
			<input type="hidden" name="id" value="<%=id%>">
			<input type="hidden" name="nowPage" value="<%=nowPage%>">
			<input type="hidden" name="schItem" value="<%=schItem%>">
			<input type="hidden" name="schWord" value="<%=schWord%>">
		</form>
	</body>
</html>
