package com.edu.util;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Component("fileUtils")
public class FileUtils {
  
  private static final String FILE_PATH = "C:\\upload";
  
  public List<Map<String, Object>> parseInsertFileInfo(int parentId, MultipartHttpServletRequest mhr) throws Exception {
    Iterator<String> iterator = mhr.getFileNames(); // iterator로만 저장되어 있음 주의
    MultipartFile multipartFile = null;
    String originalFileName = null;
    String originalFileExtension = null;
    String storedFileName = null;
    
    List<Map<String, Object>> fileList = new ArrayList<Map<String, Object>>();  
    Map<String, Object> fileInfoMap = null; // 하나의 column
    
    File file = new File(FILE_PATH); // 경로 세팅
    
    // 경로에 폴더가 없는 경우 생성
    if (file.exists() == false) {
      file.mkdir();
    }
    
    // iterator.hasNext(): 원시 파일
    while (iterator.hasNext()) {
      multipartFile = mhr.getFile(iterator.next()); // 파일
      
      // 비어있지 않은 경우 파일을 list에 담음
      if (multipartFile.isEmpty() == false) {
        originalFileName = multipartFile.getOriginalFilename(); // 실제 파일명(확장자 포함)
        
        // server에서 사용을 위한 중복 제거용
        originalFileExtension = originalFileName.substring(originalFileName.lastIndexOf(".")); // 확장자 분리
        storedFileName = CommonUtils.getRandomString() + originalFileExtension;
        
        file = new File(FILE_PATH, storedFileName);
        multipartFile.transferTo(file); // 실제 파일 생성
        
        // DB 저장
        fileInfoMap = new HashMap<>();
        fileInfoMap.put("parentId", parentId); // PK
        fileInfoMap.put("originalFileName", originalFileName);
        fileInfoMap.put("storedFileName", storedFileName);
        fileInfoMap.put("fileSize", multipartFile.getSize());
        
        fileList.add(fileInfoMap);
      }
    
    }
    
    return fileList;
  }

  // 실제 파일 삭제 => DB를 기반으로 data를 가져와 파일이 존재할 경우 실제 파일 삭제
  public void parseDeleteFileInfo(List<Map<String, Object>> tempFileList) throws Exception {
    for (Map<String, Object> tempFileMap : tempFileList) {
      String storedFileName = (String) tempFileMap.get("STORED_FILE_NAME");
    
      File file = new File(FILE_PATH + "/" + storedFileName);
      
      if (file.exists()) {
        file.delete();
      } else {
        System.err.println("파일이 존재하지 않습니다.");
      }
    }
    
  }
}
