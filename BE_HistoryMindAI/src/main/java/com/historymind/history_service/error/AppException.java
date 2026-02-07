package com.historymind.history_service.error;

public class AppException extends RuntimeException {

    private final ErrorCode code;

    public AppException(ErrorCode code) {
        super(code.getMessage());
        this.code = code;
    }

    public ErrorCode getCode() {
        return code;
    }
}
