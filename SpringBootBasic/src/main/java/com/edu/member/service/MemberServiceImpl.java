package com.edu.member.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.edu.member.dao.MemberDao;
import com.edu.member.domain.MemberVo;

//member와 관련된 모든 비즈니스 로직 처리 => interface 구현
@Service
public class MemberServiceImpl implements MemberService {

  // dependency injection 레벨로 동작
  @Autowired
  public MemberDao memberDao;

  @Override
  public List<MemberVo> memberSelectList(String searchOption, String keyword) {
    Map<String, Object> map = new HashMap<>();
    
    map.put("searchOption", searchOption);
    map.put("keyword", keyword);
    
    return memberDao.memberSelectList(map);
  }
  
  @Override
  public MemberVo memberExist(String email, String password) {
    return memberDao.memberExist(email, password);
  }

  @Override
  public int memberInsertOne(MemberVo memberVo) {
    return memberDao.memberInsertOne(memberVo);
  }

  @Override
  public MemberVo memberSelectOne(int no) {
    return memberDao.memberSelectOne(no);
  }

  @Override
  public int memberUpdateOne(MemberVo memberVo) {
    return memberDao.memberUpdateOne(memberVo);
  }

  @Override
  public int memberDeleteOne(int no) {
    return memberDao.memberDeleteOne(no);
  }

  
}
