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

tr > th {
	background-color: gray;
}

.aTagStyle {
	cursor: pointer;
}

.aTagStyle:hover {
	color: lightgreen;
	background-color: gray;
}

#container {
  border: 1px solid;
}

#container > tr {
  width: 980px;
}

.tableSubject {
  width: 245px;
  background-color: gray;
}

.tableValue {
  width: 245px;
}

</style>

<script src="https://code.jquery.com/jquery-3.7.0.js"
	integrity="sha256-JlqSTELeR4TLqP0OG9dxM7yDPqX1ox/HfgiSLBj8+kM="
	crossorigin="anonymous"></script>

<script type="text/javascript">
	// jQuery
	$(function() {

		// 게시판 추가 화면
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
				htmlStr += '<button id="btnFreeBoardInsert">작성 완료</button>';
				htmlStr += '</span>';
				htmlStr += '</div>';
				
				containerTag.html(htmlStr);
			});
		
		// 동적 이벤트 등록
		// 게시판 추가 버튼 작동
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

	// 자유게시판 수정 form 화면 이동 혹은 생성
  function restRequestFreeBoardUpdateFnc(tableTdTag) {
	  const tableTdTafObj = $(tableTdTag);
      
    const parentTr = tableTdTafObj.parent();
    const freeBoardIdStr = parentTr.children().eq(0).text();
//     alert("freeBoardIdStr: " + freeBoardIdStr);
  
    $.ajax({
      url: "/freeBoard/" + freeBoardIdStr,
      method: "GET",
      dataType: "json",
      success: function(data) {
//        alert("도착: " + data);
       
       let createDate = new Date(data.createDate).toLocaleString("ko-KR", {
    	   year: "numeric",
    	   month: "2-digit",
    	   day: "2-digit",
    	   hour: "2-digit",
    	   minute: "2-digit",
    	   second: "2-digit"
       });
       
       const containerTag = $("#container");
       let htmlStr = "";
       
       htmlStr += '<table style="width: 1000px;">';
       
       htmlStr += '<tr>';
       htmlStr += '<td class="tableSubject">주제</td>';
       htmlStr += '<td style="width: 735px;" colspan="3">'
       htmlStr += '<input type="text" id="freeBoardTitle" name="freeBoardTitle" value="' + data.freeBoardTitle + '" size="100px" />';
       htmlStr += '</td>';
       htmlStr += '</tr>';
       
       htmlStr += '<tr>';
       htmlStr += '<td class="tableSubject">작성자</td>';
       htmlStr += '<td class="tableValue">' + data.memberName + '</td>';
       htmlStr += '<td class="tableSubject">게시판 번호</td>';
       htmlStr += '<td class="tableValue">';
       htmlStr += '<input id="freeBoardId" name="freeBoardId" value="' + data.freeBoardId+ '" readonly="readonly" />';
       htmlStr += '</td>';
       htmlStr += '</tr>';
       
       htmlStr += '<tr>';
       htmlStr += '<td class="tableSubject">이메일</td>';
       htmlStr += '<td class="tableValue">' + data.email + '</td>';
       htmlStr += '<td class="tableSubject">작성일자</td>';
       htmlStr += '<td class="tableValue">';
       htmlStr += createDate;
       htmlStr += '</td>';
       htmlStr += '</tr>';
       
       htmlStr += '<tr>';
       htmlStr += '<td style="width: 980px;" colspan="4">';
       htmlStr += '<textarea id="freeBoardContent" name="freeBoardContent"';
       htmlStr += ' rows="10" cols="100" style="width: 990px;">';
       htmlStr += '</textarea>';
       htmlStr += '</td>';
       htmlStr += '</tr>';
    	         
       htmlStr += '</table>';
       
       htmlStr += '<div>';
       htmlStr += '<span>';
       htmlStr += '<button onclick="pageMoveFreeBoardListFnc();">이전페이지</button>';
       htmlStr += '<button onclick="resetRequestFreeBoardUpdateCtrFnc();">수정 완료</button>';
       htmlStr += '</span>';
       htmlStr += '</div>';
       
       containerTag.html(htmlStr);
       
       const freeBoardContentTag = $("#freeBoardContent");
       freeBoardContentTag.text(data.freeBoardContent);
      },
      error: function(xhr, status) {
        alert(xhr.status);
        alert(status);
      }
    }); // ajax end
      
	}
	
// 자유게시판 DB 정보 수정
  function resetRequestFreeBoardUpdateCtrFnc(tableTdTag) {
   
	  const inputMemberNoTag = $("#inputMemberNo");
	  
    const freeBoardIdTag = $("#freeBoardId");
    
    const freeBoardTitleTag = $("#freeBoardTitle");
    const freeBoardContentTag = $("#freeBoardContent");
    
    const jsonDataObj = {
        freeBoardId: freeBoardIdTag.val(),
        memberNo: inputMemberNoTag.val(),
        freeBoardTitle: freeBoardTitleTag.val(),
        freeBoardContent: freeBoardContentTag.val(),
        createDate: null,
        updateDate: null
    };
	
    $.ajax({
      url: "/freeBoard/" + jsonDataObj.freeBoardId,
      method: "PATCH",
      contentType: "application/json",
      data: JSON.stringify(jsonDataObj),
      dataType: "json",
      success: function(data) {
       alert("게시판 수정 도착: " + data);
       
       let createDate = new Date(data.createDate).toLocaleString("ko-KR", {
         year: "numeric",
         month: "2-digit",
         day: "2-digit",
         hour: "2-digit",
         minute: "2-digit",
         second: "2-digit"
       });
       
       const containerTag = $("#container");
       
       let htmlStr = `
	   	   <table style="width: 1000px;">
	   	     <tr>
	   	       <td class="tableSubject">주제</td>
	   	       <td style="width: 735px;" colspan="3">
	   	         <input type="text" id="freeBoardTitle" name="freeBoardTitle" value="\${data.freeBoardTitle}" size="100px" />
	   	       </td>
	   	     </tr>
	   	     
	   	     <tr>
	   	       <td class="tableSubject">작성자</td>
	   	       <td class="tableValue">\${data.memberName}</td>
	   	       <td class="tableSubject">게시판 번호</td>
	   	       <td class="tableValue">
	   	         <input id="freeBoardId" name="freeBoardId" value="\${data.freeBoardId}" readonly="readonly" />
	   	       </td>
	   	     </tr>
	   	     
	   	     <tr>
	   	       <td class="tableSubject">이메일</td>
	   	       <td class="tableValue">\${data.email}</td>
	   	       <td class="tableSubject">작성일자</td>
	   	       <td class="tableValue">\${createDate}</td>
	   	     </tr>
	   	     
	   	     <tr>
	   	       <td style="width: 980px;" colspan="4">
	   	         <textarea id="freeBoardContent" name="freeBoardContent" rows="10" cols="100" style="width: 990px;"></textarea>
	   	       </td>
	   	     </tr>
	   	   </table>
	   	   
	   	   <div>
	   	     <span>
	   	       <button onclick="pageMoveFreeBoardListFnc();">이전페이지</button>
	   	       <button onclick="resetRequestFreeBoardUpdateCtrFnc();">수정 완료</button>
	   	     </span>
	   	   </div>
    	 `;
       
       containerTag.html(htmlStr);
       
       const freeBoardContentTag = $("#freeBoardContent");
       freeBoardContentTag.text(data.freeBoardContent);
      },
      error: function(xhr, status) {
        console.log(xhr.status);
        console.log(status);
        
        const errorMassage = xhr.responseJSON ? xhr.responseJSON.errorMsg : "알 수 없는 오류가 발생했습니다.";
        alert("오류: " + errorMassage);
      }
    }); // ajax end
      
  }
	
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
					<td class="aTagStyle" onclick="restRequestFreeBoardUpdateFnc(this);">
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