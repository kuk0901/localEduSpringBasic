package com.edu.freeBoard.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.edu.freeBoard.dao.FreeBoardDao;
import com.edu.freeBoard.domain.FreeBoardVo;
import com.edu.util.FileUtils;

import jakarta.transaction.Transactional;

@Service
public class FreeBoardServiceImp implements FreeBoardService {

  private static final Logger log = LoggerFactory.getLogger(FreeBoardServiceImp.class);
  
  @Autowired
  public FreeBoardDao freeBoardDao;
  
  @Autowired
  private FileUtils fileUtils;
  
  @Override
  public List<FreeBoardVo> freeBoardSelectList(int start, int end) {
    return freeBoardDao.freeBoardSelectList(start, end);
  }

  @Override
  public int freeBoardSelectTotalCount() {
    return freeBoardDao.freeBoardSelectTotalCount();
  }

  @Override
  public Map<String, Object> freeBoardSelectOne(int freeBoardId) {
    Map<String, Object> resultMap = new HashMap<>();
    
    FreeBoardVo freeBoardVo = freeBoardDao.freeBoardSelectOne(freeBoardId);
    resultMap.put("freeBoardVo", freeBoardVo);
    
    List<Map<String, Object>> freeBoardFileList = freeBoardDao.freeBoardFileSelectList(freeBoardId);
    resultMap.put("freeBoardFileList", freeBoardFileList);
        
    return resultMap;
  }
  
  @Override
  public void freeBoardInsertOne(FreeBoardVo freeBoardVo, MultipartHttpServletRequest mhr) throws Exception {
    freeBoardDao.freeBoardInsertOne(freeBoardVo);
    
    System.out.println("?????????: " + freeBoardVo.getFreeBoardId());
    List<Map<String, Object>> fileList = fileUtils.parseInsertFileInfo(freeBoardVo.getFreeBoardId(), mhr);
    
    for (int i = 0; i < fileList.size(); i++) {
      freeBoardDao.freeBoardFileInsertOne(fileList.get(i));
    }
  }

  @Transactional // 트랜잭션으로 만듦 => 하나라도 실패하는 경우 RollBack
  @Override
  public void freeBoardUpdateOne(FreeBoardVo freeBoardVo, MultipartHttpServletRequest mhr,
      List<Integer> delFreeBoardFileIdList) throws Exception {
    
    freeBoardDao.freeBoardUpdateOne(freeBoardVo);
    
    int parentSeq = freeBoardVo.getFreeBoardId();
    
    if (delFreeBoardFileIdList != null) {
      List<Map<String, Object>> tempFileList = freeBoardDao.fileSelectStoredFileName(delFreeBoardFileIdList);
      
      // JPA 명명규칙, 구문과 관련된 부분을 앞에 작성 - by를 기준으로 뒷부분에 행하는 변수 작성
      freeBoardDao.deleteFileByFreeFilIds(delFreeBoardFileIdList);
      
      if (tempFileList != null) {
        fileUtils.parseDeleteFileInfo(tempFileList);
      }
    } // if문
    
    // 재사용 사례
    List<Map<String, Object>> fileInsertList = fileUtils.parseInsertFileInfo(parentSeq, mhr);
    
    if (fileInsertList.isEmpty() == false) {
      for (Map<String, Object> map : fileInsertList) {
        freeBoardDao.freeBoardFileInsertOne(map);
      }
    }
  }


}
