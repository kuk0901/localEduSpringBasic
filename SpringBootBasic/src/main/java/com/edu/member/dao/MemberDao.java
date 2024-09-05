package com.edu.member.dao;

import java.util.List;

import com.edu.member.domain.MemberVo;

public interface MemberDao {

  List<MemberVo> memberSelectList();

  public MemberVo memberExist(String email, String password);
  public int memberInsertOne(MemberVo memberVo);
  
  public MemberVo memberSelectOne(int no);
  public int memberUpdateOne(MemberVo memberVo);
  public int memberDeleteOne(int no);
}
