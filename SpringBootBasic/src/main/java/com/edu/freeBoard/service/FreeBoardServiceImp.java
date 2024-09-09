package com.edu.freeBoard.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.edu.freeBoard.dao.FreeBoardDao;
import com.edu.freeBoard.domain.FreeBoardVo;

@Service
public class FreeBoardServiceImp implements FreeBoardService {

  @Autowired
  public FreeBoardDao freeBoardDao;
  
  @Override
  public List<FreeBoardVo> freeBoardSelectList(int start, int end) {
    return freeBoardDao.freeBoardSelectList(start, end);
  }

  @Override
  public int freeBoardSelectTotalCount() {
    return freeBoardDao.freeBoardSelectTotalCount();
  }

  @Override
  public FreeBoardVo freeBoardSelectOne(int freeBoardId) {
    return freeBoardDao.freeBoardSelectOne(freeBoardId);
  }
  
  @Override
  public void freeBoardInsertOne(FreeBoardVo freeBoardVo) {
    freeBoardDao.freeBoardInsertOne(freeBoardVo);
  }

  @Override
  public void freeBoardUpdateOne(FreeBoardVo freeBoardVo) {
    freeBoardDao.freeBoardUpdateOne(freeBoardVo);
  } 

}
