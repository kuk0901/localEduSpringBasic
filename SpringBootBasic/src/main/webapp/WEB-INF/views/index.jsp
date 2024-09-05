<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>	
<meta charset="UTF-8">
<title>Insert title here</title>
<script>
	function pageMoveLoginFnc() {
		location.href = './member/login';
	}
</script>
</head>
<body>
<jsp:include page="/WEB-INF/views/Header.jsp" />

  <h1>Hello Spring Boot</h1>
  <p>Projects</p>

  <button onclick="pageMoveLoginFnc();">Sign In</button>
<jsp:include page="/WEB-INF/views/Tail.jsp" />
</body>
</html>

