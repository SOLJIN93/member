<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.io.*, java.sql.*"%>
<%	request.setCharacterEncoding("UTF-8"); %>
<%
	// (1) 변수부
	String sw = request.getParameter("sw");
	//System.out.println("sw :"+sw);

	String existId ="";
	if(sw.equals("up") || sw.equals("up"))	existId = request.getParameter("existId");

	//System.out.println("existId :"+existId);
	String id = request.getParameter("id");
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

	<!-- (2) 출력부 -->
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>아이디 중복 점검</title>
	</head>

	<body>
	<!-- (2-1) 알림 -->
		<center>
		<table width="94%" bgcolor="#b0e0e6">
			<tr><td align="center">아이디 중복 점검</td></tr>
		</table></br>

	<!-- (2-2) 버턴 -->
		<table width="94%">
			<tr><td align="right">
				<input type="button" value="확인 " onClick="retBtn()">
			</td></tr>
		</table><br/>

	<!-- (2-3) 중복 점검 -->
	<%
		Class.forName("com.mysql.cj.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/shmall?serverTimezone=UTC&useSSL=false", "root", "12345678");

		String sql = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;

		boolean exist = false;
		try {
			if(sw.equals("in")) {
				sql = "SELECT COUNT(id) FROM member WHERE id=?";

				psmt = conn.prepareStatement(sql);
				psmt.setString(1, id);

				rs = psmt.executeQuery();
				int x = 0;
				if(rs.next())	x = rs.getInt(1);
				//System.out.println("x :"+x);
				if(x>0)			exist = true; // x>0 중복 : 사용 불가능 : 

			} else if(sw.equals("up")) {
				sql = "SELECT COUNT(id) FROM member WHERE id=? && NOT id=?";

				psmt = conn.prepareStatement(sql);
				psmt.setString(1, id); // 수정 id
				//System.out.println("id :"+id);
				psmt.setString(2, existId);// 기존 id
				//System.out.println("existId :"+existId);

				rs = psmt.executeQuery();
				int x = 0;
				if(rs.next())	x = rs.getInt(1); // 첫번째 결과값 :count
				//System.out.println("x :"+x);
				if(x>0)			exist = true; // x>0 중복 : 사용 불가능 : 
			}
	%>

		<table width="94%" border="0" rules="none" bgcolor="#b0e0e6">
			<tr><td>&nbsp;</td></tr>

	<%		if(exist==true) {	%>
				<tr><td>&nbsp;&nbsp; <%=id%>은(는) 이미 사용중인 ID입니다.</td></tr>
	<%		} else {	%>
				<tr><td>&nbsp;&nbsp; <%=id%>은(는) 사용할 수 있는 ID입니다.</td></tr>
	<%		}	%>
				<tr><td>&nbsp;</td></tr>
		</table>
		</center>
	<%
			rs.close();
			psmt.close();
		} catch (SQLException e) {
			out.println("ex :"+ e);
		}
		conn.close();
	%>
	<!-- (2-4) 제거 및 점검 표시 -->
	<script type="text/javascript">
		function retBtn() {
			var exist = '<%=exist%>';
			var sw = '<%=sw%>';

			if(exist=='true') { // 중복일 때 제거
				if(sw=='in') {
					opener.document.inForm.id.value = '';
					opener.document.inForm.id.focus();
				} else if(sw=='up') {
					opener.document.upForm.id.value = '';
					opener.document.upForm.id.focus();
				} 
			} else {
				if(sw=='in') {
					opener.document.inForm.idCheck.value = 'check';
				}
			}
			self.close();
		}
	</script>
	</body>
</html>