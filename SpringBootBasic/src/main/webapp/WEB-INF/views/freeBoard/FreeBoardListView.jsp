<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>자유게시판 목록</title>

<style type="text/css">
table, tr, th, td {
	border: 1px solid black;
	border-collapse: collapse;
}

tr>th {
	background-color: gray;
}

.aTagStyle {
	cursor: pointer;
}

.aTagStyle:hover {
	color: lightgreen;
	background-color: gray;
}
</style>

<script src="https://code.jquery.com/jquery-3.7.0.js"
	integrity="sha256-JlqSTELeR4TLqP0OG9dxM7yDPqX1ox/HfgiSLBj8+kM="
	crossorigin="anonymous"></script>

<script type="text/javascript">
	// jQuery
	$(function() {

		$('#aFreeBoardInsert').on('click', function(event) {
				const myObj = $(this);

				event.preventDefault(); // 이벤트의 기본 동작을 막음

				const containerTag = $("#container");
				let htmlStr = '';

				htmlStr += '<table style="width: 1000px;">';
				
				htmlStr += '<tr>';
				htmlStr += '<td class="tableSubject">주제</td>';
				htmlStr += '<td style="width: 735px;">'
				htmlStr += '<input type="text" id="freeBoardTitle" name="freeBoardTitle" value="" size="100px" />';
				htmlStr += '</td>';
				htmlStr += '</tr>';
				
				htmlStr += '<tr>';
				htmlStr += '<td style="width: 980px;" colspan="2">';
				htmlStr += '<textarea id="freeBoardContent" name="freeBoardContent" rows="10" cols="100" style="width: 990px;">';
				htmlStr += '</textarea>';
				htmlStr += '</td>';
				htmlStr += '</tr>';
				
				htmlStr += '</table>';
				
				htmlStr += '<div>';
				htmlStr += '<span>';
				htmlStr += '<button onclick="pageMoveFreeBoardListFnc();">이전페이지</button>';
				htmlStr += '<button id="btnFreeBoardInsert">수정페이지로 이동</button>';
				htmlStr += '</span>';
				htmlStr += '</div>';
				
				containerTag.html(htmlStr);
			});
		
		// 동적 이벤트 등록
		$("#container").on("click", "#btnFreeBoardInsert", function(event) {
			  const myObj = $(this);
			  
			  const inputMemberNoTag = $("#inputMemberNo");
			  const freeBoardTitleTag = $("#freeBoardTitle");
			  const freeBoardContentTag = $("#freeBoardContent");
			  
			  const jsonDataObj = {
					  freeBoardId: 0,
					  memberNo: inputMemberNoTag.val(),
					  freeBoardTitle: freeBoardTitleTag.val(),
					  freeBoardContent: freeBoardContentTag.val(),
					  createDate: null,
					  updateDate: null
			  };
			  
			  $.ajax({
				  url: "/freeBoard/",
				  method: "POST",
				  contentType: "application/json",
				  data: JSON.stringify(jsonDataObj),
				  dataType: "json",
				  success: function(data) {
					 alert(data);
					 location.href = "./list";
					},
				  error: function(xhr, status) {
						alert(xhr.status);
						alert(status);
					}
			  }); // ajax end
			  
		});

	}); // onload

	function pageMoveFreeBoardDetailFnc(tableTdTag) {

		let parentTr = tableTdTag.parentNode;

		let freeBoardIdStr = parentTr.children[0].textContent;

		let userSelectFreeBoardIdObj = document
				.getElementById('userSelectFreeBoardId');
		userSelectFreeBoardIdObj.value = freeBoardIdStr;

		let freeBoardListFormObj = document.getElementById('freeBoardListForm');
		freeBoardListFormObj.submit();

	}
</script>

</head>

<body>

	<jsp:include page="/WEB-INF/views/Header.jsp" />

	<div id="container">

		<h1>자유게시판 목록</h1>

		<p>
			<a id="aFreeBoardInsert" href="#">자유게시판 글쓰기</a>
		</p>

		<table>
			<tr>
				<th>번호</th>
				<th>주제</th>
				<th>작성자</th>
				<th>생성날짜</th>
				<th>수정날짜</th>
				<th>비고[삭제]</th>
			</tr>
			<c:forEach var="freeBoardVo" items="${freeBoardList}">
				<tr>
					<td>${freeBoardVo.freeBoardId}</td>
					<td class="aTagStyle" onclick="pageMoveFreeBoardDetailFnc(this);">
						${freeBoardVo.freeBoardTitle}</td>
					<td>${freeBoardVo.memberName}</td>
					<td>${freeBoardVo.createDate}</td>
					<td>${freeBoardVo.updateDate}</td>
					<td style="text-align: center;">[삭제]</td>
				</tr>
			</c:forEach>
		</table>

		<jsp:include page="/WEB-INF/views/common/Paging.jsp">
			<jsp:param value="${pagingMap}" name="pagingMap" />
		</jsp:include>

		<form id="pagingForm" action="./list" method="post">
			<input type="hidden" id="curPage" name="curPage"
				value="${pagingMap.pagingVo.curPage}" />
		</form>

	</div>

	<jsp:include page="/WEB-INF/views/Tail.jsp" />

	<form id='freeBoardListForm' action="./list" method="post">
		<input id='userSelectFreeBoardId' type="hidden" name="freeBoardId"
			value="">

	</form>


</body>
</html>