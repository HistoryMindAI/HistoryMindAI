package com.historymind.history_service.service;

import com.historymind.history_service.dto.ChatRequest;
import com.historymind.history_service.dto.ChatResponse;
import com.historymind.history_service.error.AppException;
import com.historymind.history_service.error.ErrorCode;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.time.Duration;
import java.util.concurrent.TimeoutException;

@Service
public class ChatService {

    private final WebClient webClient;
    private final AiResponseValidator validator;

    public ChatService(WebClient.Builder webClientBuilder,
                       AiResponseValidator validator) {

        this.webClient = webClientBuilder
                .baseUrl("http://localhost:8000")
                .build();
        this.validator = validator;
    }

    public Mono<ChatResponse> processChat(String query) {

        ChatRequest request = new ChatRequest(query);

        return webClient.post()
                .uri("/chat")
                .bodyValue(request)
                .retrieve()
                .onStatus(
                        status -> status.isError(),
                        res -> Mono.error(new AppException(ErrorCode.AI_SERVICE_ERROR))
                )
                .bodyToMono(ChatResponse.class)
                .timeout(Duration.ofSeconds(10))
                .doOnNext(validator::validate)
                .map(this::hallucinationGuard)
                .onErrorMap(e -> {
                    if (e instanceof AppException) return e;
                    if (e instanceof TimeoutException)
                        return new AppException(ErrorCode.AI_TIMEOUT);
                    return new AppException(ErrorCode.INTERNAL_ERROR);
                });
    }

    private ChatResponse hallucinationGuard(ChatResponse res) {
        if (!res.isNo_data() && res.getAnswer() != null &&
                res.getAnswer().toLowerCase().contains("tôi không chắc")) {
            res.setNo_data(true);
        }
        return res;
    }
}
