package com.edu.member.dao;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.edu.member.domain.MemberVo;

@Repository
public class MemberDaoImpl implements MemberDao {

  // sql과 관련된 모든 코드를 위임받아 처리(쿼리문만 존재)
  @Autowired
  private SqlSession sqlSession;
  
  final String namespace = "com.edu.member.";
  
  @Override
  public List<MemberVo> memberSelectList() {
    // xml 파일의 쿼리문을 가져옴 => id로 접근
    return sqlSession.selectList(namespace + "memberSelectList");
  }

  @Override
  public MemberVo memberExist(String email, String password) {
    
    HashMap<String, Object> paramMap = new HashMap<>();
    paramMap.put("email", email);
    paramMap.put("pwd", password);
    
    return sqlSession.selectOne(namespace + "memberExist", paramMap);
  }

  @Override
  public int memberInsertOne(MemberVo memberVo) {
    return sqlSession.insert(namespace + "memberInsertOne", memberVo);
  }

  @Override
  public MemberVo memberSelectOne(int no) {  
    return sqlSession.selectOne(namespace + "memberSelectOne", no);
  }

  @Override
  public int memberUpdateOne(MemberVo memberVo) {
    return sqlSession.update(namespace + "memberUpdateOne", memberVo);
  }

  @Override
  public int memberDeleteOne(int no) {
    return sqlSession.delete(namespace + "memberDeleteOne", no);
  }

}
