package com.historymind.history_service.error;

public enum ErrorCode {

    INVALID_REQUEST(400, "Invalid request"),
    AI_TIMEOUT(504, "AI service timeout"),
    AI_RESPONSE_INVALID(502, "Invalid AI response"),
    AI_SERVICE_ERROR(502, "AI service error"),
    INTERNAL_ERROR(500, "Internal server error");

    private final int status;
    private final String message;

    ErrorCode(int status, String message) {
        this.status = status;
        this.message = message;
    }

    public int getStatus() { return status; }
    public String getMessage() { return message; }
}

