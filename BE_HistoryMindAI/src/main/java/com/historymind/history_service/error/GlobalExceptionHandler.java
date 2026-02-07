package com.historymind.history_service.error;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(AppException.class)
    public ResponseEntity<?> handle(AppException ex) {
        ErrorCode code = ex.getCode();
        return ResponseEntity
                .status(code.getStatus())
                .body(Map.of(
                        "code", code.name(),
                        "message", code.getMessage()
                ));
    }
}
