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

#container {
	border: 1px solid;
}

#container>tr {
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
  
	function storeFileMakeUlFnc(freeBoardFileList) {
		const storeFileListUl = $("#storeFileList");
		
		storeFileListUl.html("");
		let listItem = null;
		
		if(freeBoardFileList.length == 0) {
			listItem = $("<li>저장된 파일이 없습니다.</li>");
			storeFileListUl.html(listItem);
		  
			return;
		}
		
		let liHtmlStr = "";
		
		for (let i = 0; i < freeBoardFileList.length; i++) {
			listItem = document.createElement("li");
		
			// mapper에서 작성한 alias를 칼럼으로 사용 => originalFileName => 화면에서 사용
			// src="/img/" 경로는 WebMvcConfig class를 통해 자동 치환
			liHtmlStr = freeBoardFileList[i].originalFileName + "&nbsp;&nbsp;" + freeBoardFileList[i].freeBoardFileSize 
				+ "(kb)" + "<img alt='image not found' src='/img/" + freeBoardFileList[i].storedFileName + "' style='width: 150px;'" 
				+ " fileId='" + freeBoardFileList[i].freeBoardFileId + "' />"
				+ "<span><input type='button' value='수정' />"
				+ "<input type='button' value='삭제' id='imgFileDel" + i + "' /></span>"; // 별개로 수행되어야 함 => id를 별개로 줌
			 
		  listItem.innerHTML = liHtmlStr;
		  storeFileListUl.append(listItem);
		}
		
		// ^= : "시작하는" 연산자로, 지정된 값으로 시작하는 속성을 선택
		// 해당 태그들에 이벤트 등록(바인딩을 위해 jQuery on() 사용)
		$("input[id^='imgFileDel']").on("click", function (e) {
	    e.preventDefault();
	    
	    const parentLi = $(this).closest("li"); // DOM 트리 탐색, 가장 가까운 li 요소를 찾음
	    const imgTag = parentLi.find("img");
	    
	    parentLi.html("<span delfileid='" + imgTag.attr("fileId") + "'>이미지가 삭제되었습니다.</span>");
	  });
		
	} // 파일 ui 제작 함수 end
	
	
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
			
			// 이미지 업로드 UI
			htmlStr += '<div id="fileContainer" style="border: 1px solid;">';
			htmlStr += '<label for="inputFreeBoardFile">파일</label>';
			htmlStr += '<input type="file" id="inputFreeBoardFile" name="freeBoardFileList" multiple="multiple" />';
			htmlStr += '<ul id="fileList" class="fileUploadList"></ul>';
			htmlStr += '</div>';
			
			htmlStr += '<div>';
			htmlStr += '<span>';
			htmlStr += '<button onclick="pageMoveFreeBoardListFnc();">이전페이지</button>';
			htmlStr += '<button id="btnFreeBoardInsert">작성 완료</button>';
			htmlStr += '</span>';
			htmlStr += '</div>';
			
			containerTag.html(htmlStr);
			
			const inputFreeBoardFile = document.getElementById("inputFreeBoardFile"); // multiple => Array
			const fileListUl = document.getElementById("fileList");
			
			inputFreeBoardFile.addEventListener("change", function(e) {
		        fileListUl.innerHTML = ""; // initialize
		        
		        for (let i = 0; i < inputFreeBoardFile.files.length; i++) {
		          let listItem = document.createElement("li");
		          listItem.innerHTML = inputFreeBoardFile.files[i].name + "&nbsp;&nbsp;" + inputFreeBoardFile.files[i].size + "(byte)";
		          fileListUl.appendChild(listItem);   
		        }
		        
		      }); // 이벤트 등록 end
		});
		
		// 동적 이벤트 등록
		// 게시판 추가 버튼 작동
		$("#container").on("click", "#btnFreeBoardInsert", function(event) {
			event.preventDefault();
		  
		  const inputMemberNoTag = $("#inputMemberNo");
		  const freeBoardTitleTag = $("#freeBoardTitle");
		  const freeBoardContentTag = $("#freeBoardContent");
		  
		  const inputFreeBoardFileArr = $("#inputFreeBoardFile")[0].files;
		  
		  const formDataObj = new FormData();
		  
		  formDataObj.append("freeBoardId", 0);
		  formDataObj.append("memberNo", inputMemberNoTag.val());
		  formDataObj.append("freeBoardTitle", freeBoardTitleTag.val());
		  formDataObj.append("freeBoardContent", freeBoardContentTag.val());
		  
// 		  const jsonDataObj = {
// 				  freeBoardId: 0,
// 				  memberNo: inputMemberNoTag.val(),
// 				  freeBoardTitle: freeBoardTitleTag.val(),
// 				  freeBoardContent: freeBoardContentTag.val(),
// 				  createDate: null,
// 				  updateDate: null
// 		  };
				  
		  // file data 처리, file이 존재하는 경우에만 담음
			if (inputFreeBoardFileArr.length > 0) {
			  for (let i = 0; i < inputFreeBoardFileArr.length; i++) {
				  // file은 name이 같으면 안 되기에 index 활용
				  // input 태그 생성 및 name="value" 형태로 설정
				  formDataObj.append("inputFreeBoardFileArr" + i, inputFreeBoardFileArr[i]);
				}
			}
				  
		  $.ajax({
			  url: "/freeBoard/",
			  method: "POST",
//			  contentType: "application/json", // json은 파일 처리 불가
        contentType: false, 
        processData: false, // jQuery에서 브라우저가 자동으로 content-type을 설정하도록 함
//        data: JSON.stringify(jsonDataObj),
        data: formDataObj,
// 			  dataType: "json",
			  success: function(data) {
				 alert("156 line: 파일 추가? " + data);
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
       const freeBoardVo = data.freeBoardVo;
       const freeBoardFileList = data.freeBoardFileList;
       
       let createDate = new Date(freeBoardVo.createDate).toLocaleString("ko-KR", {
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
       htmlStr += '<input type="text" id="freeBoardTitle" name="freeBoardTitle" value="' + freeBoardVo.freeBoardTitle + '" size="100px" />';
       htmlStr += '</td>';
       htmlStr += '</tr>';
       
       htmlStr += '<tr>';
       htmlStr += '<td class="tableSubject">작성자</td>';
       htmlStr += '<td class="tableValue">' + freeBoardVo.memberName + '</td>';
       htmlStr += '<td class="tableSubject">게시판 번호</td>';
       htmlStr += '<td class="tableValue">';
       htmlStr += '<input id="freeBoardId" name="freeBoardId" value="' + freeBoardVo.freeBoardId+ '" readonly="readonly" />';
       htmlStr += '</td>';
       htmlStr += '</tr>';
       
       htmlStr += '<tr>';
       htmlStr += '<td class="tableSubject">이메일</td>';
       htmlStr += '<td class="tableValue">' + freeBoardVo.email + '</td>';
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
       
       // 이미지 업로드 UI
       htmlStr += '<div id="fileContainer" style="border: 1px solid;">';
       htmlStr += '<label for="inputFreeBoardFile">파일</label>';
       htmlStr += '<input type="file" id="inputFreeBoardFile" name="freeBoardFileList" multiple="multiple" />';
       htmlStr += '<ul id="storeFileList" class="fileUploadList"></ul>';
       htmlStr += '</div>';
       
       // 권한의 여부
       const inputSessionMemberNoTag = $("#inputMemberNo");
       
       if (freeBoardVo.memberNo == inputSessionMemberNoTag.val()) {
    	   htmlStr += '<div>';
         htmlStr += '<span>';
         htmlStr += '<button onclick="pageMoveFreeBoardListFnc();">이전페이지</button>';
         htmlStr += '<button onclick="restRequestFreeBoardUpdateCtrFnc();">수정 완료</button>';
         htmlStr += '</span>';
         htmlStr += '</div>';
       } else {
    	   htmlStr += '<div>';
         htmlStr += '<span>';
         htmlStr += '<button onclick="pageMoveFreeBoardListFnc();">이전페이지</button>';
         htmlStr += '</span>';
         htmlStr += '</div>';
       }    
       
       containerTag.html(htmlStr);
       
       const freeBoardContentTag = $("#freeBoardContent");
       freeBoardContentTag.text(freeBoardVo.freeBoardContent);
       
       storeFileMakeUlFnc(freeBoardFileList);
       
       const inputFreeBoardFile = document.getElementById("inputFreeBoardFile");
       const fileListUl = document.getElementById("fileList");
       
       inputFreeBoardFile.addEventListener("change", function(e) {
         fileListUl.innerHTML = ""; // initialize
         
         for (let i = 0; i < inputFreeBoardFile.files.length; i++) {
           let listItem = document.createElement("li");
           listItem.innerHTML = inputFreeBoardFile.files[i].name + "&nbsp;&nbsp;" + inputFreeBoardFile.files[i].size + "(byte)";
           fileListUl.appendChild(listItem);   
         }
         
       }); // 이벤트 등록 end
       
      },
      error: function(xhr, status) {
        alert(xhr.status);
        alert(status);
      }
    }); // ajax end
      
	}
	
// 자유게시판 DB 정보 수정
  function restRequestFreeBoardUpdateCtrFnc(tableTdTag) {
   
	  const inputMemberNoTag = $("#inputMemberNo");
    const freeBoardIdTag = $("#freeBoardId");
    const freeBoardTitleTag = $("#freeBoardTitle");
    const freeBoardContentTag = $("#freeBoardContent");
    
    // 파일 처리를 위해(RESTful API 사용) Form 데이터 생성
    const formDataObj = new FormData();
    
    formDataObj.append("freeBoardId", freeBoardIdTag.val());
    formDataObj.append("memberNo", inputMemberNoTag.val());
    formDataObj.append("freeBoardTitle", freeBoardTitleTag.val());
    formDataObj.append("freeBoardContent", freeBoardContentTag.val());
	
    const storeFileListUl = $("#storeFileList");
    console.log(storeFileListUl);
    
    // 이미지를 삭제할 예정인 데이터 수집 => id(PK)만 필요(DB 의존)
    storeFileListUl.find('span[delfileid]').each(function(i, item) {
    	  formDataObj.append('delFreeBoardFileIdList', $(item).attr("delfileid")); // name=""형태로 input 생성해 form 데이터에 append
    });
    
    // 새로운 파일 데이터 수집 => 태그의 모든 데이터 필요
    const inputFreeBoardFileArr = $("#inputFreeBoardFile")[0].files;
    
    if (inputFreeBoardFileArr.length > 0) {
    	for (var i = 0; i < inputFreeBoardFileArr.length; i++) {
    		formDataObj.append("inputFreeBoardFileArr" + i, inputFreeBoardFileArr[i]);
    	}
    }
    
    $.ajax({
      url: "/freeBoard/" + freeBoardIdTag.val(),
      method: "PATCH",
      contentType: false,
      processData: false,
      data: formDataObj,
      success: function(resultMap) {
//        alert("381line: 메시지만 띄워보기: " + resultMap);
       const freeBoradVo = resultMap.freeBoardVo;
       const freeBoardFileList = resultMap.freeBoardFileList;
       
       
       let createDate = new Date(freeBoradVo.createDate).toLocaleString("ko-KR", {
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
	   	         <input type="text" id="freeBoardTitle" name="freeBoardTitle" value="\${freeBoradVo.freeBoardTitle}" size="100px" />
	   	       </td>
	   	     </tr>
	   	     
	   	     <tr>
	   	       <td class="tableSubject">작성자</td>
	   	       <td class="tableValue">\${freeBoradVo.memberName}</td>
	   	       <td class="tableSubject">게시판 번호</td>
	   	       <td class="tableValue">
	   	         <input id="freeBoardId" name="freeBoardId" value="\${freeBoradVo.freeBoardId}" readonly="readonly" />
	   	       </td>
	   	     </tr>
	   	     
	   	     <tr>
	   	       <td class="tableSubject">이메일</td>
	   	       <td class="tableValue">\${freeBoradVo.email}</td>
	   	       <td class="tableSubject">작성일자</td>
	   	       <td class="tableValue">\${createDate}</td>
	   	     </tr>
	   	     
	   	     <tr>
	   	       <td style="width: 980px;" colspan="4">
	   	         <textarea id="freeBoardContent" name="freeBoardContent" rows="10" cols="100" style="width: 990px;"></textarea>
	   	       </td>
	   	     </tr>
	   	   </table>
	   	   
		   	 <div id="fileContainer" style="border: 1px solid black;">
				    <label for="inputFreeBoardFile">파일</label>
				    <input type="file" id="inputFreeBoardFile" name="freeBoardFileList" multiple>
				    <ul id="fileList" class="fileUploadList"></ul>
				    <ul id="storeFileList" class="fileUploadList"></ul>
				 </div>
	   	   
	   	   <div>
	   	     <span>
	   	       <button onclick="pageMoveFreeBoardListFnc();">이전페이지</button>
	   	       <button onclick="restRequestFreeBoardUpdateCtrFnc();">수정 완료</button>
	   	       <input type="button" value="삭제하기" 
	   	    	   onclick="restRequestFreeBoardDeleteCtrFnc(\${freeBoardVo.freeBoardId}, \${freeBoardVo.memberNo}, 1);" />
	   	     </span>
	   	   </div>
    	 `;
       
       containerTag.html(htmlStr);
       
       const freeBoardContentTag = $("#freeBoardContent");
       freeBoardContentTag.text(freeBoradVo.freeBoardContent);
       
       storeFileMakeUlFnc(freeBoardFileList);
       
      },
      error: function(xhr, status) {
        console.log(xhr.status);
        console.log(status);
        
        const errorMassage = xhr.responseJSON ? xhr.responseJSON.errorMsg : "알 수 없는 오류가 발생했습니다.";
        alert("오류: " + errorMassage);
      }
    }); // ajax end
      
  }
	
	function restRequestFreeBoardDeleteCtrFnc(freeBoardId, memberNo, curPageStr) {
		  
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
					<td class="aTagStyle"
						onclick="restRequestFreeBoardUpdateFnc(this);">
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