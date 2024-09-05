<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<title>회원 정보 수정</title>
<script type="text/javascript">
function movePageMemberListFnc() {
	location.href = "./list";
}

function movePageDeleteFnc(memberId) {
	const url = "/member/delete/" + memberId;
	
	fetch(url, { method: 'DELETE'})
	 .then(function(res) {
		  // return res.json();
		  
		  if (res.ok) {
			  return res.text();
		  } else {
			  throw new Error("회원 삭제 실패");
		  }
	})
	 .then(function(data) {
		  console.log(data);
		 
		  location.href = "./list";
		  
	})
	 .catch(function(error) {
		  alert(error.message || "회원 삭제 시 통신에 문제 발생");
	});
	
}

async function movePageDeleteFnc(memberId) {
    const url = "/member/delete/" + memberId;

    try {
        const res = await fetch(url, {
            method: 'DELETE'
        });

        if (!res.ok) {
            throw new Error("회원 삭제 실패");
        }

        const data = await res.text();
        alert(data);
        location.href = "./list";

    } catch (error) {
        alert(error.message || "회원 삭제 시 통신에 문제 발생");
    }
}
</script>
</head>

<body>
	<jsp:include page="/WEB-INF/views/Header.jsp" />

	<h1>회원정보</h1>
	<form action='./update' method='post'>
		<div>
			<label for="memberNo">번호</label> 
			<input type='text' id="memberNo" name='memberNo'
				value='${requestScope.memberVo.memberNo}' readonly='readonly' />
		</div>
		
		<div>
			<label for="memberName">이름</label> 
			<input type='text' id="memberName" name='memberName'
				value='${memberVo.memberName}' />
		</div>
		
		<div>
			<label for="email">이메일</label> 
			<input type='text' id="email" name='email'
				value='${memberVo.email}' />
		</div>
		
		<div>
			<label for="createDate">가입일</label> 
			<fmt:formatDate value="${memberVo.createdDate}" pattern="yyyy-mm-dd hh:mm:ss"/>
		</div>
		
		<div>
			<input type='submit' value='정보 수정' /> 
			<input type='button' value='삭제'
				onclick='movePageDeleteFnc(${memberVo.memberNo});' /> 
			<input type='button' value='회원목록으로 이동' onclick='movePageMemberListFnc();' />
		</div>


	</form>

	<jsp:include page="/WEB-INF/views/Tail.jsp" />
</body>
</html>