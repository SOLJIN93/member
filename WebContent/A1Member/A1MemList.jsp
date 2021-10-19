<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="java.util.*, java.io.*, java.sql.*"%>
<%@ page import="shmall.prt.A1MemPrint"%>
<%	request.setCharacterEncoding("UTF-8"); %>
<%
	// (1) 변수부
	// (1-1) 수신 변수
	String schItem = request.getParameter("schItem");
	if(schItem==null)	schItem = request.getParameter("selItem"); // 자체 검색

	if(schItem==null || ((String)schItem).trim().length()==0) 	schItem = "";
	//System.out.println("schItem :"+schItem);

	String schWord =  request.getParameter("schWord");	// 검색어
	if(schWord==null || ((String)schWord).trim().length()==0) 	schWord = "";
	//System.out.println("schWord :"+schWord);

	String sNowPage = request.getParameter("nowPage");	// 현재 페이지
	if(sNowPage==null || ((String)sNowPage).trim().length()==0) sNowPage = "1";
	int nowPage = Integer.parseInt(sNowPage);

	String onPrt = request.getParameter("onPrt");	// 인쇄
	if(onPrt==null || ((String)onPrt).trim().length()==0) onPrt = "off";

	if(onPrt.equals("on")) {
		A1MemPrint prt = new A1MemPrint(schItem, schWord);
		//System.out.println("schWord :"+schWord);
	}

	// (1-2) 페이지 및 블록 변수 : 초기값
	int totRecord	= 0;		// 전체 레코드수
	//int nowPage 	= 1;		// 현재 페이지
	int pageSize	= 5;		// 페이지당 레코드 수 
	int totPage		= 0;		// 전체 페이지 수

	int nowBlock 	= 1;		// 현재 블록
	int blockSize	= 5;		// 블록당 페이지수 , 블록 : 페이지 출력 공간
	int totBlock	= 0;		// 전체 블록수 

	int startPage	= 0;		// 블럭당 페이지 시작 번호
	int endPage		= 0;		// 블럭당 페이지 마지막 번호
%>

<%
	// (1-3) 테이블 변수 : totRecord
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/shmall?serverTimezone=UTC&useSSL=false", "root", "12345678");

	String sql = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;

	try {
		// 집계함수 COUNT() : 행 개수 구하기
		// 조건이 없을 때 : COUNT(*)와 COUNT(no)로 구하면 null을 포함한 개수를 구하는데 비해 COUNT(id)는 null을 제외한 개수
		// 조건이 있을 때 : COUNT(*)와 COUNT(id)는 같다.
		if(schWord.equals("null") || schWord.equals("")) {
			sql = "SELECT COUNT(id) FROM member";
			psmt = conn.prepareStatement(sql);
		} else {
			// where 조건의 schItem은 항명이므로 쿼리문 실행 전에 설정되어 있어야 한다. 
			sql = "SELECT COUNT(id) FROM  member WHERE " + schItem + " LIKE ?";
			psmt = conn.prepareStatement(sql);
			psmt.setString(1, "%" + schWord + "%");
		}
/*
		// 실행
		sql = "SELECT * FROM member WHERE " + schItem + " LIKE '%" + schWord + "%'";
		psmt = conn.prepareStatement(sql);

		// 안됨 
		sql = "SELECT COUNT(id) FROM  member WHERE ? LIKE ?";
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, " + schItem + ");
		psmt.setString(2, "%" + schWord + "%");
*/
		rs = psmt.executeQuery();
		if(rs.next()) 	totRecord = rs.getInt(1); // 첫번째 결과값 :count, "id"가 아님 
		//System.out.println("totRecord :"+totRecord);
		rs.close();
		psmt.close();
	} catch(SQLException e) {
		out.println("e :"+ e);
	}
	//conn.close();

/*	나머지가 있으면 페이지를 하나 더 만들어야 하기 때문에 절상을 하여야 한다.
	절상(ceil())은 나머지지가 있으면 무조건 올림이다. 이에 비해 절하(floor())는 내림이다. */
	// (1-4) 페이지 및 블록 변수 : 절상
	totPage = (int)Math.ceil((double)totRecord/pageSize); // 전체 페이지수
	nowBlock = (int)Math.ceil((double)nowPage/blockSize); // 현재 블록 계산
	totBlock = (int)Math.ceil((double)totPage/blockSize); // 전체 블록 계산
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

	<!-- (2) 출력부 -->
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>회원 목록</title>

	<!-- (2-1) 유효성 검사 및 폼 전송  -->
		<script>
			function schBtn() { // 목록 화면 : 검색 목록 출력
				if(document.schForm.schWord.value=="") {
					alert("검색어를 입력하십시오.");
					document.schForm.schWord.focus();
					return;
				}
					document.schForm.action = "A1MemList.jsp";
					document.schForm.submit();
			}

			function allBtn() { // 목록 화면 : 전체 목록 출력
				document.allForm.action = "A1MemList.jsp";
				document.allForm.submit();
			}

			function inBtn() { // 입력 화면
				document.inForm.action = "B1Input.jsp";
				document.inForm.submit();
			}

			function upBtn() { // 수정 화면 : check한 upId에는 선택한 라디오 버턴의 id(기본 키) 값이 있음 
				var check = "";
				if(typeof(listForm.upId.length)=="undefined") {// 라디오 버턴이 한개 일 때
					if(document.getElementById('upIdId').checked) check = 1;

				} else {
					for(i=0; i<listForm.upId.length; i++) {
						if(listForm.upId[i].checked==true) {
							check = listForm.upId[i].value;
						}
					}
				}

				if(check=="") {
					alert("수정 확인란을 선택하십시오.");
					document.listForm.upId.focus();
					return;
				}

				document.listForm.action = "D1Update.jsp";
				document.listForm.submit();
			}
/*
			// 위 upBtn()은 수정 페이지에 배열 변수 upId[]를 전송하는제 비해 주석 처리한 upBtn()는 일반 변수 upId를 전송 
			// 주석 처리한 upBtn()의 문제점은 위 upBtn()의 check와 같이 수정할 라디오 버턴을 점검할 수 없다.   
			function upBtn() {
				var ary = document.getElementsByName("upIdId").length;

				for(var i=0; i<ary; i++) {
					if(document.getElementsByName("upIdId")[i].checked == true) {
						document.listForm.id.value = document.getElementsByName("upIdId")[i].value;
						document.listForm.action = "D1Update.jsp";
						document.listForm.submit();
					}
				}
			}
*/
			function delBtn() { // 삭제 화면 : check한 delId에는 선택한 체크 박스의 id(기본 키) 값이 있음 
				var check = "";
				if(typeof(listForm.delId.length)=="undefined") {// 체크 박스가 한개 일 때
					if(document.getElementById('delIdId').checked) check = 1;

				} else {
					for(i=0; i<listForm.delId.length; i++) {
						if(listForm.delId[i].checked==true) {
							check = listForm.delId[i].value;
						}
					}
				}

				if(check=="") {
					alert("삭제 확인란을 선택하십시오.");
					document.listForm.delId.focus();
					return;
				}

				var ans = confirm("삭제 하겠습니까?");
				if(ans==true) {
					document.listForm.action = "E1DelProcess.jsp";
					document.listForm.submit();
				}
			}

			function prtBtn() { // 인쇄
				document.prtForm.action = "A1MemList.jsp";
				document.prtForm.submit();
			}

			function outAnk(id) { // 출력 화면
				document.listForm.id.value = id;
				document.listForm.action = "C1Output.jsp";
				document.listForm.submit();
			}

			function blockAnk(page) { // 목록 화면 : 블록 처리
				document.blockForm.nowPage.value =page;
				document.blockForm.action="A1MemList.jsp";
				document.blockForm.submit();
			}

			function pageAnk(page) { // 목록 화면 : 페이지 처리
				document.blockForm.nowPage.value = page;
				document.blockForm.action = "A1MemList.jsp";
				document.blockForm.submit();
			}

		</script>
	</head>


	<body>
	<!-- (2-2) 제목, 알림 -->
		<center>
		<table width="94%">
			<tr height="30"><td width="22%">&nbsp;</td>
				<th width="50%" align="center" bgcolor="#b0e0e6">회원 관리</th>
				<td width="22%">&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>

			<tr bgcolor="#b0e0e6">
				<td width="20%" align="center">총회원 :<%=totRecord%>명</td>
				<td width="54%">
					<marquee direction="left" style="color: navy;" onmouseover="stop()" onmouseout="start()">
						<font size="3" color="gray">검색은 조건항의 선택과 검색어 입력 후 검색 버턴을 누르면 목록에 나타납니다. 전체 버턴은 검색과 상관없이 전체 목록을 나타냅니다.!!</font>
					</marquee></td>
				<td width="20%" align="center">현재 화면 :<%=nowPage%>/<%=totPage%></td></tr>
		</table><br/>

	<!-- (2-3) 버턴 : 검색 폼 -->
		<table width="94%">
			<tr>
				<form  name="schForm"  method="post">
				<!--<td>&nbsp;&nbsp;&nbsp; -->
				<td style="padding-left:20px;"/>
					<select name="selItem" size="1" >
						<option value="name">이름</option>
						<option value="birthday">생년월일(YYYY-MM-DD)</option>
						<option value="regDate">등록일자(YYYY-MM-DD)</option>
					</select>
					<input type="text" size="16" name="schWord">
					<input type="button"  value="검색" onClick="schBtn()">&nbsp;&nbsp;&nbsp;
					<input type="button"  value="전체" onClick="allBtn()">&nbsp;&nbsp;&nbsp;
				</td>
				</form>

				<td align="right"  style="padding-right:20px;">
					<input type="button" value="가입" onClick="inBtn()">&nbsp;&nbsp;&nbsp;
					<input type="button" value="수정" onClick="upBtn()">&nbsp;&nbsp;&nbsp;
					<input type="button" value="삭제" onClick="delBtn()">&nbsp;&nbsp;&nbsp;
					<!-- img src="Image/delete.gif" onClick="delBtn()">&nbsp;&nbsp;&nbsp;-->
					<!--<input type="button" value="인쇄" onClick="prtBtn();">&nbsp;&nbsp;&nbsp; -->
					<input type="button" value="인쇄" onClick="prtBtn();">
				</td>
			</tr>
		</table><br/>
		</center>

	<!-- (2-4) 목록 폼 -->
		<center>
			<form  name="listForm" method="post">
		<!-- <form  name="listForm" id="idPrint" method="post"> -->
			<input type="hidden" name="id">
			<input type="hidden" name="nowPage" value="<%=nowPage%>">
			<input type="hidden" name="schItem" value="<%=schItem%>">
			<input type="hidden" name="schWord" value="<%=schWord%>">

		<table width="94%" border="0" rules="none" bgcolor="#b0e0e6">
	<!-- (2-4-1) 목록명 -->
			<tr><td>&nbsp;</td></tr>
			<tr style ="height:25px; text-align:center; border-bottom:1px #000000 solid;">
				<td width="10%" align="center">번호</td>
				<td width="25%" align="center">이름</td>
				<td width="20%" align="center">생년월일</td>
				<td width="25%" align="center">등록 일자</td>
				<td width="10%" align="center">수정</td>
				<td width="10%" align="center">삭제</td></tr>

	<!-- (2-4-2) 목록 데이터 -->
	<%
		int startNum = (nowPage-1) * pageSize;	// 페이지당 레코드 시작 번호

		try {
			if(schWord.equals("null") || schWord.equals("")) {
				sql = "SELECT * FROM member ORDER BY regDate DESC, name ASC LIMIT ?, ?";
				psmt = conn.prepareStatement(sql);
				psmt.setInt(1, startNum);
				psmt.setInt(2, pageSize);
			} else {
				sql = "SELECT * FROM member WHERE " + schItem + " LIKE ? ORDER BY regDate DESC, name ASC LIMIT ?, ?";
				psmt = conn.prepareStatement(sql);
				psmt.setString(1, "%" + schWord + "%");
				psmt.setInt(2, startNum);
				psmt.setInt(3, pageSize);
			}

			rs = psmt.executeQuery();
			int recNum = startNum + 1;//번호
			while(rs.next()) {	// pageSize 내에 출력 

				//if(recNum%2==0)		out.println("<tr bgcolor='#F0F0F0'>");
				//else 			out.println("<tr bgcolor='#FFFFFF'>");

				String id = rs.getString("id");
				String name = rs.getString("name");
				String birthday = rs.getString("birthday");
				String regDate 	= rs.getString("regDate");
	%>
			<tr><td align="center"><%=recNum%></td>
				<td align="center"><a href="javascript:outAnk('<%=id%>')"><%=name%></a></td>
				<td align="center"><%=birthday%></td>
				<td align="center"><%=regDate%></td>
<!-- 수정 -->		<td align="center"><input type="radio" name="upId" id="upIdId" value="<%=id%>"></td>
<!-- 삭제 -->		<td align="center"><input type="checkbox" name="delId" id="delIdId" value="<%=id%>"></td></tr>
	<%
				recNum++;
			} // while
			rs.close();
			psmt.close();
		} catch(SQLException e) {
			out.println("ex :"+ e);
		}
		conn.close();
	%>
			<tr><td colspan="7">&nbsp;</td></tr>
		</table><br/>
	<%
		if(totRecord==0) {
			out.println("<br/><br/>");
			out.println("<center>");
			out.println("등록된 데이터가 없습니다.");
			out.println("</center>");
		}
	%>
		</form>
		</center>

	<!-- (2-5) 페이지 및  블록 처리 -->
		<div align="center">
	<%
		startPage = (nowBlock -1)*blockSize + 1; //
		endPage = ((startPage+blockSize)<=totPage)?  (startPage+blockSize): totPage+1;

		if(totPage!=0) {
			if(nowBlock>1) { // pre 출력
				int prePage = blockSize*(nowBlock-2)+1;
	%>
					<a href="javascript:blockAnk('<%=prePage%>')">이전(pre)...</a>
	<%		} %>
						&nbsp;
	<%		for( ; startPage<endPage; startPage++) { // 페이지 출력 %>
					<a href="javascript:pageAnk('<%=startPage %>')">
	<%			if(startPage==nowPage) { %>
					<font color="blue"> 
	<%			} %>
					[<%=startPage %>]
	<%			if(startPage==nowPage) { %>
					</font> 
	<%			} %>
					</a>
	<%		}//for	%>
					&nbsp;
	<%
			if(totBlock>nowBlock) { // next 출력
				int nextPage = blockSize*nowBlock+1;
	%>
	
				<a href="javascript:blockAnk('<%=nextPage%>')">.....이후(next)</a>
	<%		} %>
					&nbsp;
	<%	} %>
		</div>

	<!-- (2-6) 기타 폼 -->	
		<form name="blockForm" method="post">
			<input type="hidden" name="id">
			<input type="hidden" name="nowPage" value="<%=nowPage%>">
			<input type="hidden" name="schItem" value="<%=schItem%>">
			<input type="hidden" name="schWord" value="<%=schWord%>">
		</form>

		<form name="allForm" method="get">
			<input type="hidden" name="nowPage" value="1">
		</form>

		<!-- inForm이 아닌 listForm으로 처리할 경우 데이터가 없을 때 오류	 -->
		<form name="inForm"  method="post">
			<input type="hidden" name="nowPage" value="<%=nowPage%>">
			<input type="hidden" name="schItem" value="<%=schItem%>">
			<input type="hidden" name="schWord" value="<%=schWord%>">
		</form>
		
		<form name="prtForm" method="post">
			<input type="hidden" name="onPrt" value="on">
			<input type="hidden" name="nowPage" value="<%=nowPage%>">
			<input type="hidden" name="schItem" value="<%=schItem%>">
			<input type="hidden" name="schWord" value="<%=schWord%>">
		</form>
	</body>
</html>