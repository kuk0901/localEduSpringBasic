package com.edu.util;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {
  
  @Override
  public void addResourceHandlers(ResourceHandlerRegistry registry) {
    // 경로 치환 => 화면에서 사용되는 경로가 자동으로 치환
    registry.addResourceHandler("/img/**").addResourceLocations("file:///C:upload/");
    
  }
  
}
