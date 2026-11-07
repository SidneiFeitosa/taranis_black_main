package com.taranisblack.finance.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.util.List;
import java.util.Map;

@Service
public class GeminiApiClient {

    private final String apiKey;

    public GeminiApiClient(@Value("${google.api.key}") String apiKey) {
        this.apiKey = apiKey;
    }

    public Mono<String> generateContent(String model, String prompt) {
        // Força a utilização do modelo correto e atualizado
        String cleanModel = "gemini-2.5-flash";
        
        Map<String, Object> requestBody = Map.of(
            "contents", List.of(
                Map.of(
                    "parts", List.of(
                        Map.of("text", prompt)
                    )
                )
            )
        );

        String url = "https://generativelanguage.googleapis.com/v1beta/models/" + cleanModel + ":generateContent?key=" + apiKey;

        return WebClient.create().post()
            .uri(url)
            .header("Content-Type", "application/json")
            .bodyValue(requestBody)
            .retrieve()
            .bodyToMono(String.class)
            .doOnNext(response -> System.out.println("✅ Sucesso absoluto na resposta do Gemini!"))
            .onErrorResume(e -> {
                String errorMsg = e.getMessage() != null ? e.getMessage() : "Erro desconhecido";
                System.err.println("❌ Erro detalhado na API do Gemini: " + errorMsg);
                
                String statusDetalhe;
                if (errorMsg.contains("429") || errorMsg.contains("RESOURCE_EXHAUSTED") || errorMsg.contains("quota")) {
                    statusDetalhe = "Cota diária gratuita do Gemini esgotada (Limite de 20 requisições/dia atingido). Tente novamente amanhã ou utilize outra chave de API.";
                } else if (errorMsg.contains("400") || errorMsg.contains("API_KEY_INVALID")) {
                    statusDetalhe = "Chave de API inválida ou não configurada corretamente no arquivo .env.";
                } else {
                    statusDetalhe = "Falha na comunicação com a API: " + errorMsg.replace("\"", "'");
                }

                // Retorna um JSON informando claramente que a IA não pôde responder, sem inventar dados
                String jsonErro = String.format(
                    "{\"alunoNome\":\"Consultor ONE G11\",\"alunoEmail\":\"aluno@one.com.br\",\"rotaEscolhida\":\"Rota 4 — Finanças e Operações\",\"cenarioProblema\":\"Indisponibilidade da IA\",\"resumoExecutivo\":\"Não foi possível obter a resposta da IA: %s\",\"acaoPrioritaria\":\"Verifique o status da chave ou aguarde o reset da cota.\",\"metricaSucesso\":\"N/A\"}",
                    statusDetalhe
                );

                return Mono.just(jsonErro);
            });
    }
}
