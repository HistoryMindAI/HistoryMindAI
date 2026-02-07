package com.historymind.history_service.service;

import com.historymind.history_service.dto.ChatResponse;
import com.historymind.history_service.error.AppException;
import com.historymind.history_service.error.ErrorCode;
import org.springframework.stereotype.Component;

@Component
public class AiResponseValidator {

    public void validate(ChatResponse res) {

        if (res == null) {
            throw new AppException(ErrorCode.AI_RESPONSE_INVALID);
        }

        if (res.isNo_data()) {
            return; // hợp lệ
        }

        if (res.getAnswer() == null || res.getAnswer().isBlank()) {
            throw new AppException(ErrorCode.AI_RESPONSE_INVALID);
        }

        if (res.getAnswer().length() > 3000) {
            throw new AppException(ErrorCode.AI_RESPONSE_INVALID);
        }
    }
}
