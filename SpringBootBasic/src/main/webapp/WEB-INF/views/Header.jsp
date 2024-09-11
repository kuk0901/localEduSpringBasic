<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<script>
function pageMoveMemberListFnc() {
	  location.href = "/member/list";
}

function pageMoveFreeBoardListFnc() {
    location.href = "/freeBoard/list";
}
</script>

<div style="background-color: #dd7c73; color: #fff; height: 20px; padding: 5px;">
	SPMS(Simple Project Management System)
	
	<span style="border: 1px solid greenyellow; color: greenyellow; cursor: pointer;" onclick="pageMoveMemberListFnc();">회원</span>
	<span style="border: 1px solid greenyellow; color: greenyellow; cursor: pointer;" onclick="pageMoveFreeBoardListFnc();">자유게시판</span>
	
	<c:if test="${sessionScope.member.email ne null}">
		<span style="float: right; text-align: right;">
			${member.memberName}
			<input id="inputMemberNo" type="hidden" value="${member.memberNo}" />
			<!-- 공통단의 코드들은 가능한 절대 경로로 설정해야 어떤 구조에서든 동작 -->
			<a style="color: #86eb86;" href="${sessionScope.rootPath}/member/logout">(로그아웃)</a>
		</span>
	</c:if>
	
	
</div>
