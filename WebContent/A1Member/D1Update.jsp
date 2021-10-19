<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.io.*, java.sql.*"%>
<%	request.setCharacterEncoding("UTF-8"); %>
<%
	// (1) 변수부
	// (1-1) 수신 변수
	String upId[] = request.getParameterValues("upId");
	String existId=null;
	if(upId!=null) {
		existId = upId[0]; // 목록 id, 라디오 버턴이므로 배열 0
	} else { // D2UpProcess 반환
		existId = request.getParameter("id"); // 수정 id
	}
	//System.out.println("id :"+ id);

	String nowPage = request.getParameter("nowPage");
	String schItem = request.getParameter("schItem");
	String schWord = request.getParameter("schWord");
%>

<%
	// (1-2) 테이블 변수
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/shmall?serverTimezone=UTC&useSSL=false","root", "12345678");

	String sql = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;

	String nickName=null, password=null, name=null, tel1=null, tel2=null, tel3=null;
	String bYear=null, job=null, email=null, zipCode=null, doroAddress=null, doroAddress2=null, jibunAddress=null, jibunAddress2=null;
	int eMonth=0, eDay=0, bMonth=0, bDay=0;

	try {
		sql = "SELECT * FROM member WHERE id=?";
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, existId);

		rs = psmt.executeQuery();
		if(rs.next()) {
			//id = rs.getString("id");
			nickName = rs.getString("nickName");
			password = rs.getString("password");

			name = rs.getString("name");

			String phone = rs.getString("phone");
			if(phone !=null) {			
				tel1 = phone.substring(0, 3);
				tel2 = phone.substring(4, 8);
				tel3 = phone.substring(9, 13);
			} else {
				tel1 = "";
				tel2 = "";
				tel3 = "";
			}
			String birthday = rs.getString("birthday");
			if(birthday !=null) {
				bYear = birthday.substring(0, 4);
				String bMonth2 = birthday.substring(5, 7);
				bMonth = Integer.parseInt(bMonth2);	// 월의 "0"을 제거

				String bDay2 = birthday.substring(8, 10);
				bDay = Integer.parseInt(bDay2);		// 일의 "0"을 제거
			//	System.out.println("bDay2 :"+ bDay2);		
			} else {
				bMonth = 0;
				bDay = 0;
			}
			
			job = rs.getString("job");
			email = rs.getString("email");
			zipCode	= rs.getString("zipCode");
			doroAddress = rs.getString("doroAddress");
			doroAddress2 = rs.getString("doroAddress2");
			jibunAddress = rs.getString("jibunAddress");
			jibunAddress2 = rs.getString("jibunAddress2");
			if(doroAddress2==null)	doroAddress2 = "";
			if(jibunAddress2==null)	jibunAddress2 = "";
		}

		rs.close();
		psmt.close();
	} catch (SQLException e) {
		out.println("ex :"+ e);
	}
	conn.close();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
	<!-- (2) 출력부 -->
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>회원 수정</title>

	<!-- (2-1) 자바스크립트  -->
	<!-- (2-1-1) 유효성 검사 및 폼 전송 -->
		<script>
			function isNum(input) {
				
				for(var ii=0; ii<input.length; ii++) {
					// isNaN(): is Not A Number : 숫자인지를 판별한다. 아니면 false를 반환 
					if(isNaN(input.charAt(ii)))
						return false;
				}
				return true;
			}

			function upBtn() {

				if(document.upForm.id.value=='') {
					alert("아이디를 입력하십시오.");
					document.upForm.id.focus();
					return;
				}

				if(document.upForm.password.value=='') {
					alert("비밀번호를 입력하십시오.");
					document.upForm.password.focus();
					return;
				}

				if(document.upForm.password2.value=='') {
					alert("비밀번호를 재입력하십시오.");
					document.upForm.password2.focus();
					return;
				}

				if(document.upForm.password.value!=document.upForm.password2.value) {
					alert("비밀번호가 맞지 않습니다.");
					document.upForm.password2.focus();
					return;
				}

				if(document.upForm.name.value=='') {
					alert("이름을 입력하십시오.");
					document.upForm.name.focus();
					return;
				}

				// 전화번호	
				if(document.upForm.tel1.value=='') {
					alert("본인 전화번호 첫자리를 입력하십시오.");
					document.upForm.tel1.focus();
					return;
				}
				if(document.upForm.tel1.value.length!=3) {
					alert ("본인 전화번호 첫자리를 잘못 입력하였습니다.");
					document.upForm.tel1.focus();
					return;
				}

				if(!isNum(document.upForm.tel1.value)) {
					alert("본인 전화번호 첫자리는 숫자만 입력이 가능합니다.");
					document.upForm.tel1.focus();
					return;
				}

				if(document.upForm.tel2.value=='') {
					alert("본인 전화번호 두번째 자리를 입력하십시오.");
					document.upForm.tel2.focus();
					return;
				}
				if(document.upForm.tel2.value.length!=4) {
					alert ("본인 전화번호 두번째 자리를 잘못 입력하였습니다.");
					document.upForm.tel2.focus();
					return;
				}

				if(!isNum(document.upForm.tel2.value)) {
					alert("본인 전화번호 두번째 자리는 숫자만 입력이 가능합니다.");
					document.upForm.tel2.focus();
					return;
				}
				if(document.upForm.tel3.value=='') {
					alert("본인 전화번호 세번째 자리를 입력하십시오.");
					document.upForm.tel3.focus();
					return;
				}
				if(document.upForm.tel3.value.length!=4) {
					alert ("본인 전화번호 세번째 자리는 잘못 입력하였습니다.");
					document.upForm.tel3.focus();
					return;
				}

				if(!isNum(document.upForm.tel3.value)) {
					alert("본인 전화번호 세번째 자리는 숫자만 입력이 가능합니다.");
					document.upForm.tel3.focus();
					return;
				}

				// 생년월일
				if(document.upForm.bYear.value=='') {
					alert("생일 년도를 입력하십시오.");
					document.upForm.bYear.focus();
					return;
				}
				if(document.upForm.bYear.value.length!=4) {
					alert ("생일 년도를 4자리로 입력하였습니다.");
					document.upForm.bYear.focus();
					return;
				}

				if(!isNum(document.upForm.bYear.value)) {
					alert("생일 년도는 숫자만 입력이 가능합니다.");
					document.upForm.bYear.focus();
					return;
				}

				if(document.upForm.bMonth.value=='') {
					alert("생일 월을 입력하십시오.");
					document.upForm.bMonth.focus();
					return;
				}

				if(!isNum(document.upForm.bMonth.value)) {
					alert("생일 월은 숫자만 입력이 가능합니다.");
					document.upForm.bMonth.focus();
					return;
				}
				if(document.upForm.bMonth.value.length==1) {
					var bMonth2 = document.upForm.bMonth.value
					document.upForm.bMonth.value = "0" + bMonth2;
				}	
				if(document.upForm.bDay.value=='') {
					alert("생일의 일을 입력하십시오.");
					document.upForm.bDay.focus();
					return;
				}

				if(!isNum(document.upForm.bDay.value)) {
					alert("생일의 일은 숫자만 입력이 가능합니다.");
					document.upForm.bDay.focus();
					return;
				}
				if(document.upForm.bDay.value.length==1) {
					var bDay2 = document.upForm.bDay.value
					document.upForm.bDay.value = "0" + bDay2;
				}

				// 직업
				if(document.upForm.selJob.value=='직업 선택') {
					alert("직업을 선택하십시오.");
					document.upForm.selJob.focus();
					return;
				}
				
				// 이메일		
				if(document.upForm.email.value=='') {
					alert("이메일을 입력하십시오.");
					document.upForm.email.focus();
					return;
				}

				allEmail = document.upForm.email.value; 
				count = 0; 
				for(i=0; i<allEmail.length; i++) { 
					if(allEmail.charAt(i)=="@") { 
						count++; 
					}
				}

				if(count!="1") { 
					alert("이메일을 잘못 기입하셨습니다."); 
					document.upForm.email.value = ""; 
					document.upForm.email.focus(); 
					return false; 
				}

				if(document.upForm.zipCode.value=='') {
					alert("우편번호를  입력해 주십시오.");
					document.upForm.zipCode.focus();
					return;
				}

				if(document.upForm.doroAddress.value=='') {
					alert("주소를 입력해 주십시오.");
					document.upForm.address1.focus();
					return;
				}

				document.upForm.action = "D2UpProcess.jsp"
				document.upForm.submit();
			}

			function retBtn() {
				document.retForm.action = "A1MemList.jsp";
				document.retForm.submit();
			}

			function idBtn() {
				if(document.upForm.id.value=='') {
					alert("아이디를 입력하십시오.");
					return;
				}
				window.open("B2FindId.jsp?sw=up&existId=<%=existId%>&id="+document.upForm.id.value, "IdCheck", "width=320,height=200,menubar=no,scrollbars=no");
			}

		</script>

	<!-- (2-1-2) 우편번호 -->
		<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
		<script>

			function zipBtn() {
				new daum.Postcode({
					oncomplete: function(data) {
						// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

						// 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
						// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
						var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
						var extraRoadAddr = ''; // 도로명 조합형 주소 변수

						// 법정동명이 있을 경우 추가한다. (법정리는 제외)
						// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
						if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
							extraRoadAddr += data.bname;
						}
						// 건물명이 있고, 공동주택일 경우 추가한다.
						if(data.buildingName !== '' && data.apartment === 'Y') {
							extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
						}
						// 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
						if(extraRoadAddr !== '') {
							extraRoadAddr = ' (' + extraRoadAddr + ')';
						}
						// 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
						if(fullRoadAddr !== '') {
							fullRoadAddr += extraRoadAddr;
						}

						// 우편번호와 주소 정보를 해당 필드에 넣는다.
						document.getElementById('zipCodeId').value = data.zonecode; //5자리 새우편번호 사용
						document.getElementById('doroAddressId').value = fullRoadAddr;
						document.getElementById('jibunAddressId').value = data.jibunAddress;

						// 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
						if(data.autoRoadAddress) {
							//예상되는 도로명 주소에 조합형 주소를 추가한다.
							var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
					   //	 document.getElementById('guide').innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';

						} else if(data.autoJibunAddress) {
							var expJibunAddr = data.autoJibunAddress;
						//	document.getElementById('guide').innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';

						} else {
						//	document.getElementById('guide').innerHTML = '';
						}
					}
				}).open();
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
						<font size="3" color="gray">수정은 항에 입력과 수정 버턴을, 취소는 목록 버턴을 누르십시오.!!</font>
					</marquee></td>
				<td width="20%" align="center">관리자</td></tr>
		</table><br/>

	<!-- (2-3) 버턴 -->
		<table width="94%">
			<tr><td align="right">
					<input type="button" value="수정 " onClick="upBtn()">&nbsp;&nbsp;&nbsp;
					<input type="button" value="목록 " onClick="retBtn()">&nbsp;&nbsp;&nbsp;
			</td></tr>
		</table><br/>
		</center>

	<!-- (2-4) 수정 폼 -->
		<center>
		<form name="upForm" method="post">
			<input type="hidden" name="existId" value="<%=existId%>">
			<input type="hidden" name="nowPage" value="<%=nowPage%>">
			<input type="hidden" name="schItem" value="<%=schItem%>">
			<input type="hidden" name="schWord" value="<%=schWord%>">

		<table width="94%" bgcolor="#b0e0e6">
			<tr><td width="15%">&nbsp;</td>
				<td width="35%">&nbsp;</td>
				<td width="15%">&nbsp;</td>
				<td width="35%">&nbsp;</td></tr>

			<tr><td>&nbsp;&nbsp; 아  이  디 :</td>
				<td><input type="text" name="id" size="15"  value="<%=existId%>">&nbsp;&nbsp;&nbsp;&nbsp; 
					<input type="button" value="중복 확인" onClick="idBtn()"></td>
					
				<td>애칭(닉네임) :</td>
				<td><input type="text" name="nickName" size="10" value="<%=nickName%>"></td></tr>
				
			<tr><td>&nbsp;&nbsp; 비 밀 번 호 :</td>
				<td><input type="password" name="password" size="15" value="<%=password%>"></td>

				<td>비밀번호 확인 : </td>
				<td><input type="password" name="password2" size="15" value="<%=password%>"></td></tr>
			<tr><td colspan="4">&nbsp;</td></tr>

			<tr><td>&nbsp;&nbsp; 이	름 :</td>
				<td><input type="text" name="name" size="15" value="<%=name%>"></td>

				<td>전 화 번 호 :</td>
				<td><input type="text" name="tel1" size="4" maxlength="3" value="<%=tel1%>">
					- <input type="text" name="tel2" size="4" maxlength="4" value="<%=tel2%>">
					- <input type="text" name="tel3" size="4"  maxlength="4" value="<%=tel3%>"></td></tr>
			<tr><td colspan="4">&nbsp;</td></tr>

			<tr><td>&nbsp;&nbsp; 생	  일 :</td>
					<td><input type="text" name="bYear" size="4" maxlength="4" value="<%=bYear%>">년 &nbsp;
						<input type="text" name="bMonth" size="4" maxlength="2" value="<%=bMonth%>">월 &nbsp;
						<input type="text" name="bDay" size="4" maxlength="2" value="<%=bDay%>">일</td>

				<td>직       업 : </td>
				<td><select name=selJob>
						<option value="<%=job%>" selected><%=job%></option>
						<option value="회사원">회사원</option>
						<option value="전문직">전문직</option>
						<option value="학생">학생</option>
						<option value="자영업">자영업</option>
						<option value="공무원">공무원</option>
						<option value="의료인">의료인</option>
						<option value="법조인">법조인</option>
						<option value="주부">주부</option>
						<option value="기타">기타</option>
					</select></td></tr>		
			<tr><td colspan="4">&nbsp;</td></tr>

			<tr><td>&nbsp;&nbsp; 이  메  일 :</td>
				<td colspan="3"><input type='text' name='email' size="30" value="<%=email%>"></td></tr>
			<tr><td colspan="4">&nbsp;</td></tr>

			<tr><td>&nbsp;&nbsp; 우 편 번 호 :</td>
				<td  colspan="3">
					<input type="text" name="zipCode" id="zipCodeId" size="3" value="<%=zipCode%>" onFocus="this.blur()">&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="button" value="우편번호" onClick="zipBtn()"></td></tr>

			<tr><td>&nbsp;&nbsp; 도로명 주소 :</td>
				<td colspan="3">
					<input type="text" name="doroAddress" id="doroAddressId" size="50" value="<%=doroAddress%>">&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="text" name="doroAddress2" size="30" value="<%=doroAddress2%>"></td></tr>
			<tr><td>&nbsp;&nbsp; 지번명 주소 :</td>
				<td colspan="3">
					<input type="text" name="jibunAddress" id="jibunAddressId" size="50" value="<%=jibunAddress%>">&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="text" name="jibunAddress2" size="30" value="<%=jibunAddress2%>"></td></tr>
			<tr><td colspan="4">&nbsp;</td></tr>
		</table><br/>
		</form>
		</center>

	<!-- (2-5) 반환 폼  -->
		<form name="retForm" method="post">
			<input type="hidden" name="nowPage" value="<%=nowPage%>">
			<input type="hidden" name="schItem" value="<%=schItem%>">
			<input type="hidden" name="schWord" value="<%=schWord%>">
		</form>
	</body>
</html>