<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.io.*, java.sql.*"%>
<%@ page import="java.text.*" %>
<%	request.setCharacterEncoding("UTF-8"); %>
<%
	// (1) 변수부
	String nowPage = request.getParameter("nowPage");
	String schItem = request.getParameter("schItem");
	String schWord = request.getParameter("schWord");
	//System.out.println("nowPage :"+ nowPage);

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
	<!-- (2) 출력부 -->
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>회원 가입</title>

	<!-- (2-1) 자바 스크립트  -->
	<!-- (2-1-1) 유효성 검사 및 폼 전송  -->
		<script>
			function isNum(input) {
				for(var ii=0; ii<input.length; ii++) {
					// isNaN(): is Not A Number : 숫자인지를 판별한다. 아니면 false를 반환 
					if(isNaN(input.charAt(ii)))
						return false;
				}
				return true;
			}

			// 이메일 선택
			function swEmail() {
				if(inForm.selEmail.value == '1') {
					inForm.email2.readonly = false;
					inForm.email2.value = '';
					inForm.email2.focus();
				} else {
					inForm.email2.readonly = true;
					inForm.email2.value = inForm.selEmail.value;
				}
			}

			function inBtn() { // 유효성 검사

				if(document.inForm.id.value=='') {
					alert("아이디를 입력하십시오.");
					document.inForm.id.focus();
					return;
				}

				if(document.inForm.idCheck.value=='unCheck') {
					alert("아이디 중복 점검을 하십시오.");
					document.inForm.id.focus();
					return;
				}

				if(document.inForm.password.value=='') {
					alert("비밀번호를 입력하십시오.");
					document.inForm.password.focus();
					return;
				}

				if(document.inForm.password2.value=='') {
					alert("비밀번호를 재입력하십시오.");
					document.inForm.password2.focus();
					return;
				}

				if(document.inForm.password.value!=document.inForm.password2.value) {
					alert("비밀번호가 맞지 않습니다.");
					document.inForm.password2.focus();
					return;
				}

				if(document.inForm.name.value=='') {
					alert("본인 이름을 입력하십시오.");
					document.inForm.name.focus();
					return;
				}
				
				// 전화번호	
				if(document.inForm.selTel1.value=='') {
					alert("본인 전화번호 첫자리를 입력하십시오.");
					document.inForm.selTel1.focus();
					return;
				}
/*
				if(document.inForm.selTel1.value.length!=3) {
					alert ("본인 전화번호 첫자리를 잘못 입력하였습니다.");
					document.inForm.selTel1.focus();
					return;
				}

				if(!isNum(document.inForm.selTel1.value)) {
					alert("본인 전화번호 첫자리는 숫자만 입력이 가능합니다.");
					document.inForm.selTel1.focus();
					return;
				}
*/
				if(document.inForm.tel2.value=='') {
					alert("본인 전화번호 두번째 자리를 입력하십시오.");
					document.inForm.tel2.focus();
					return;
				}

				if(document.inForm.tel2.value.length!=4) {
					alert ("본인 전화번호 두번째 자리를 잘못 입력하였습니다.");
					document.inForm.tel2.focus();
					return;
				}

				if(!isNum(document.inForm.tel2.value)) {
					alert("본인 전화번호 두번째 자리는 숫자만 입력이 가능합니다.");
					document.inForm.tel2.focus();
					return;
				}

				if(document.inForm.tel3.value=='') {
					alert("본인 전화번호 세번째 자리를 입력하십시오.");
					document.inForm.tel3.focus();
					return;
				}

				if(document.inForm.tel3.value.length!=4) {
					alert ("본인 전화번호 세번째 자리는 잘못 입력하였습니다.");
					document.inForm.tel3.focus();
					return;
				}

				if(!isNum(document.inForm.tel3.value)) {
					alert("본인 전화번호 세번째 자리는 숫자만 입력이 가능합니다.");
					document.inForm.tel3.focus();
					return;
				}

				// 생년월일
				if(document.inForm.bYear.value=='') {
					alert("생일 년도를 입력하십시오.");
					document.inForm.bYear.focus();
					return;
				}

				if(document.inForm.bYear.value.length!=4) {
					alert ("생일 년도를 4자리로 입력하였습니다.");
					document.inForm.bYear.focus();
					return;
				}

				if(!isNum(document.inForm.bYear.value)) {
					alert("생일 년도는 숫자만 입력이 가능합니다.");
					document.inForm.bYear.focus();
					return;
				}

				if(document.inForm.bMonth.value=='') {
					alert("생일 월을 입력하십시오.");
					document.inForm.bMonth.focus();
					return;
				}

				if(!isNum(document.inForm.bMonth.value)) {
					alert("생일 월은 숫자만 입력이 가능합니다.");
					document.inForm.bMonth.focus();
					return;
				}

				if(document.inForm.bMonth.value.length==1) {
					var bMonth2 = document.inForm.bMonth.value
					document.inForm.bMonth.value = "0" + bMonth2;
				}	

				if(document.inForm.bDay.value=='') {
					alert("생일의 일을 입력하십시오.");
					document.inForm.bDay.focus();
					return;
				}

				if(!isNum(document.inForm.bDay.value)) {
					alert("생일의 일은 숫자만 입력이 가능합니다.");
					document.inForm.bDay.focus();
					return;
				}

				if(document.inForm.bDay.value.length==1) {
					var bDay2 = document.inForm.bDay.value
					document.inForm.bDay.value = "0" + bDay2;
				}

				// 직업
				if(document.inForm.selJob.value=='직업 선택') {
					alert("직업을 선택하십시오.");
					document.inForm.selGrade.focus();
					return;
				}
	
				// 이메일
				if(document.inForm.email1.value=='') {
					alert("이메일을 입력하십시오.");
					document.inForm.email.focus();
					return;
				}

				if(document.inForm.email2.value=='') {
					alert("이메일을 입력하십시오.");
					document.inForm.email.focus();
					return;
				}
/*
				allEmail = document.inForm.email.value;
				count = 0;
				for(i=0; i<allEmail.length; i++) {
					if(allEmail.charAt(i)=="@") {
						count++;
					}
				}

				if(count!="1") {
					alert("이메일을 잘못 기입하셨습니다.");
					document.inForm.email.value = "";
					document.inForm.email.focus();
					return false;
				}
*/
				if(document.inForm.zipCode.value==''||	document.inForm.doroAddress.value=='') {
					alert("주소를 제대로 입력해 주십시오.");
					document.inForm.zipCode.focus();
					return;
				}

				document.inForm.action="B3InProcess.jsp";
				document.inForm.submit();
			}

			// 리셋
			function resetBtn() { // 입력항 초기화
				document.inForm.reset();
			}
			
			function retBtn() {
				document.retForm.action = "A1MemList.jsp";
				document.retForm.submit();
			}
			// 아이디 확인
			function idBtn() { // 아이디 사용 가능 검사
				if(document.inForm.id.value=='') {
					alert("아이디를 입력하십시오.");
					return;
				}
				window.open("B2FindId.jsp?sw=in&id="+document.inForm.id.value, "IdCheck", "width=600,height=200,menubar=no,scrollbars=yes");
			}
			
			// 아이디 키 확인
			function pressKey() {
				document.inForm.idCheck.value = "unCheck";
			}
		</script>

	<!-- (2-1-2) 우편 번호  -->
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
						if(data.buildingName !=='' && data.apartment==='Y') {
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
		
	<!-- (2-1-3) 숫자 키패드  -->
		<link rel="stylesheet" href="KeyCss/jquery.keypad.css">
		<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
		<script src="KeyJs/jquery.plugin.min.js"></script>
		<script src="KeyJs/jquery.keypad.js"></script>
		<script>
			$(function() {
				$('#keypad1').keypad();
				$('#keypad2').keypad();
				$('#keypad3').keypad();
				$('#keypad4').keypad();
				$('#keypad5').keypad();
			});
		</script>

	</head>

	<body>
	<!-- (2-2) 알림 -->
		<center>
		<table width="94%" bgcolor="#b0e0e6">
			<tr><td width="20%" align="center">우리들 쇼핑몰</td>
				<td width="54%">
					<marquee direction="left" style="color: navy;" onmouseover="stop()" onmouseout="start()">
						<font size="3" color="gray">입력할 때에는 반듯이 아이디의 중복 버턴과 우편 번호 버턴을 이용하여야 합니다.!!</font>
					</marquee></td>
				<td width="20%" align="center">관리자</td></tr>
		</table><br/>

	<!-- (2-3) 버턴 -->
		<table width="94%">
			<tr><td align="right">
				<input type="button" value="입력 " onClick="inBtn()">&nbsp;&nbsp;&nbsp;
				<input type="button" value="새로 작성 " onClick="resetBtn()">&nbsp;&nbsp;&nbsp;
				<input type="button" value="목록 " onClick="retBtn()">&nbsp;&nbsp;&nbsp;
			</td></tr>
		</table><br/>

	<!-- (2-4) 입력 폼 -->
		<form name="inForm" method="post">
			<input type="hidden" name="nowPage" value="<%=nowPage%>">
			<input type="hidden" name="schItem" value="<%=schItem%>">
			<input type="hidden" name="schWord" value="<%=schWord%>">
	
		<table width="94%" bgcolor="#b0e0e6">
			<tr><td width="15%">&nbsp;</td>
				<td width="35%">&nbsp;</td>
				<td width="15%">&nbsp;</td>
				<td width="35%">&nbsp;</td></tr>

			<tr><td>&nbsp;&nbsp; 아  이  디 :</td>
				<td><input type="text" name="id" size="15" onkeydown="pressKey()" maxlength="8">&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="button" value="중복 확인" onClick="idBtn()"></td>
					<input type="hidden" name = "idCheck" value="unCheck">

				<td>애칭(닉네임) :</td>
				<td><input type="text" name="nickName" size="10" maxlength="8"></td></tr>
				
			<tr><td>&nbsp;&nbsp; 비 밀 번 호 :</td>
				<td><input type="password" name="password" size="15" maxlength="8"></td>

				<td>비밀번호 확인 : </td>
				<td><input type="password" name="password2" size="15" maxlength="8"></td></tr>
			<tr><td colspan="4">&nbsp;</td></tr>

			<tr><td>&nbsp;&nbsp; 이	  름 :</td>
				<td><input type="text" name="name" size="15"></td>

				<td>전 화 번 호 :</td>
				<td><select name="selTel1" style="width:60px;">
						<option value="010">010</option>
						<option value="011">011</option>
						<option value="016">016</option>
						<option value="017">017</option>
						<option value="019">019</option>
					</select>

					- <input type="text" name="tel2" size="4" maxlength="4" id="keypad1">
					- <input type="text" name="tel3" size="4"  maxlength="4" id="keypad2"></td></tr>

			<tr><td>&nbsp;&nbsp; 생년월일 :</td>
				<td><input type="text" name="bYear" size="4" maxlength="4" id="keypad3">년 &nbsp;
					<input type="text" name="bMonth" size="4" maxlength="2" id="keypad4">월 &nbsp;
					<input type="text" name="bDay" size="4" maxlength="2" id="keypad5">일</td>			
	
				<td>직       업 : </td>
				<td><select name=selJob>
						<option selected>직업 선택</option>
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
				<td colspan="3">
						<input type='text' name='email1' size="15"> @ <input type='text' name='email2' size="20">&nbsp;&nbsp;&nbsp;&nbsp; 
						<select name="selEmail" style="width:100px;" onChange="swEmail();">
							<option value="" selected>선택</option>
							<option value="naver.com">naver.com</option>
							<option value="gmail.com">gmail.com</option>
							<option value="hanmail.com">hanmail.com</option> 
							<option value="1">직접 입력</option>
						</select></td></tr>
			<tr><td colspan="4">&nbsp;</td></tr>

			<tr><td>&nbsp;&nbsp; 우 편 번 호 :</td>
				<td colspan="3">
					<input type="text" name="zipCode" id="zipCodeId" size="6" onFocus="this.blur()">&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="button" value="우편번호" onClick="zipBtn()"></td></tr>

			<tr><td>&nbsp;&nbsp; 도로명 주소 :</td>
				<td colspan="3">
					<input type="text" name="doroAddress" id ="doroAddressId" size="50" maxlength="80" onFocus="this.blur()">&nbsp;&nbsp;&nbsp;&nbsp; 
					<input type="text" name="doroAddress2" size="30" maxlength="80"></td></tr>

			<tr><td>&nbsp;&nbsp; 지번명 주소 :</td>
				<td colspan="3">
					<input type="text" name="jibunAddress" id ="jibunAddressId" size="50" maxlength="80" onFocus="this.blur()">&nbsp;&nbsp;&nbsp;&nbsp; 
					<input type="text" name="jibunAddress2" size="30" maxlength="80"></td></tr>
			<tr><td colspan="4">&nbsp;</td></tr>
		</table><br/>
		</form>
		</center>

	<!-- (2-5) 반환 폼 -->
		<form name="retForm" method="post">
			<input type="hidden" name="nowPage" value="<%=nowPage%>">
			<input type="hidden" name="schItem" value="<%=schItem%>">
			<input type="hidden" name="schWord" value="<%=schWord%>">
		</form>
	</body>
</html>