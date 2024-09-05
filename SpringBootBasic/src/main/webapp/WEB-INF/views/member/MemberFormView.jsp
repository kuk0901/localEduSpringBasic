<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>회원 등록</title>
<link rel="stylesheet" href="../css/index.css" />
<link rel="stylesheet" href="../css/listPage.css" />
<script type="text/javascript">
function movePageMemberList() {
	location.href = "./list";
}
</script>
</head>
<body>
<%-- 	<jsp:include page="/Header.jsp" /> --%>
	
	<h1>회원등록</h1>
	
	<form action='add' method='post'>
		이름: <input type='text' name='memberName' /><br /> 
		이메일: <input type='text' name='email' /><br /> 
		암호: <input type='password' name='password' /><br /> 
		
<!-- 		<input name='email2' value="아메" /><br />  -->
<!-- 		<input name='email2' value="라떼" /><br />  -->
<!-- 		<input name='email2' value="아니" /><br />  -->
		
		<input type='submit' value='추가' /> 
		<input type='reset' value='취소' onclick="movePageMemberList();" />
	</form>
	
<%-- 	<jsp:include page="/Tail.jsp" /> --%>
</body>
</html>