package com.edu.member.service;

import java.util.List;

import com.edu.member.domain.MemberVo;

// member와 관련된 모든 비즈니스 로직 처리 => 인터페이스로 표준화
public interface MemberService {

  List<MemberVo> memberSelectList();
  public MemberVo memberExist(String email, String password);
  public int memberInsertOne(MemberVo memberVo);
  
  public MemberVo memberSelectOne(int no);
  public int memberUpdateOne(MemberVo memberVo);
  public int memberDeleteOne(int no);
}
