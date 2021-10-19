<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
 <script type="text/javascript">

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

</script>


</head>
<body>
<form name="inForm" method="post">
<input name="email1" type="text" class="box" id="email1" size="15"> @ <input name="email2" type="text" class="box" id="email2" size="20">
<select name="selEmail" class="box" id="email_select" onChange="swEmail();">
    <option value="" selected>선택하십시오</option>
    <option value="naver.com">naver.com</option>
    <option value="hotmail.com">hotmail.com</option>
    <option value="hanmail.com">hanmail.com</option>
    <option value="yahoo.co.kr">yahoo.co.kr</option>
    <option value="1">직접입력</option>
</select>
</form>
</body>
</html>