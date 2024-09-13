package com.edu.member.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.edu.member.domain.MemberVo;
import com.edu.member.service.MemberService;

import jakarta.servlet.http.HttpSession;

@RequestMapping("/member") // url 맵핑
@Controller // 컨트롤러 annotation
public class MemberController {
  
  // MemberController에 대한 모든 logger 확인 가능
  private Logger log = LoggerFactory.getLogger(MemberController.class);
  private final String logTitleMsg = "==MemberController==";

  // 자동으로 spring bean 객체 생성
  @Autowired
  private MemberService memberService;

  // 로그인 화면 이동
  @GetMapping("/login")
  public String login(HttpSession session, Model model) {
    log.info(logTitleMsg);
    log.info("login");

    return "member/LoginFormView";
  }

  // 로그인 회원정보 조회 및 검증
  @PostMapping("/login")
  public String getLogin(String email, String password, HttpSession session, Model model) {
    log.info(logTitleMsg);
    log.info("Welcome MemberController getLogin! " + email + ", " + password);

    MemberVo memberVo = memberService.memberExist(email, password);

    String viewUrl = "";

    if (memberVo != null) {
      session.setAttribute("member", memberVo);

      // url pattern
      viewUrl = "redirect:/member/list";
    } else {
      model.addAttribute("email", email);
      
      // jsp
      viewUrl = "/member/LoginFailView";
    }

    return viewUrl;
  }

  // 로그아웃
  @GetMapping("/logout")
  public String logout(HttpSession session, Model model) {
    log.info(logTitleMsg);
    log.info("logout");

    session.invalidate();
    
    String viewUrl = "redirect:/member/login";

    return viewUrl;
  }

  // class 영역에서의 url과 메서드 영역에서의 url을 합친 최종 url
  @GetMapping("/list")
  public String getMemberList(@RequestParam(defaultValue = "all") String searchOption
      , @RequestParam(defaultValue = "") String keyword, Model model) {
    log.info(logTitleMsg);
    log.info("@GetMapping getMemberList searchOption: {}, keyword: {}", searchOption, keyword);

    // service
    List<MemberVo> memberList = memberService.memberSelectList(searchOption, keyword);
   
    Map<String, Object> searchMap = new HashMap<>();

    searchMap.put("searchOption", searchOption);
    searchMap.put("keyword", keyword);
    
    model.addAttribute("memberList", memberList);
    model.addAttribute("searchMap", searchMap);

    return "member/MemberListView";
  }
  
  @GetMapping("/add")
  public String memberAdd(Model model) {
    log.info(logTitleMsg);
    log.info("@GetMapping memberAdd");
    
    return "member/MemberFormView";
  }
  
  // 회원 추가 DB
  @PostMapping("/add")
//  public String memberAdd(MemberVo memberVo, @RequestParam List<String> email2, Model model) {
  public String memberAdd(MemberVo memberVo, Model model) {
    log.info(logTitleMsg);
    log.info("@PostMapping memberAdd: {}", memberVo);
//    log.info("email2: {}", email2);
    
    memberService.memberInsertOne(memberVo);
  
    return "redirect:/member/list";
  }
  
  // 회원 상세 페이지
  @GetMapping("/detail")
  public String memberDetail(@RequestParam int memberNo, Model model) {
    log.info(logTitleMsg);
    log.info("@GetMapping memberDetail memberNo: {}", memberNo);

    // service
    MemberVo memberVo = memberService.memberSelectOne(memberNo);

    model.addAttribute("memberVo", memberVo);

    return "member/MemberDetailView";
  }
  
  @GetMapping("/update")
  public String memberUpdate(int memberNo, Model model) {
    log.info(logTitleMsg);
    log.info("@GetMapping memberUpdate memberNo: {}", memberNo);
    
    // service
    MemberVo memberVo = memberService.memberSelectOne(memberNo);

    model.addAttribute("memberVo", memberVo);
    
    return "member/MemberUpdateFormView";
  }
  
  @PostMapping(value = "/update")
  public String memberUpdate(MemberVo memberVo, RedirectAttributes redirectAttributes) {
    log.info(logTitleMsg);
    log.info("@PostMapping memberUpdate memberVo: {}", memberVo);
    
    memberService.memberUpdateOne(memberVo);
    
    redirectAttributes.addAttribute("memberNo", memberVo.getMemberNo());
    
    return "redirect:/member/detail";
  }
  
  @DeleteMapping("/delete/{memberNo}")
  public ResponseEntity<String> memberDelete(@PathVariable("memberNo") int memberNo) {
    log.info(logTitleMsg);
    log.info("@DeleteMapping memberDelete memberNo: {}", memberNo);
    
    memberService.memberDeleteOne(memberNo);
    
    return ResponseEntity.ok("회원 삭제 성공");
  }
}
