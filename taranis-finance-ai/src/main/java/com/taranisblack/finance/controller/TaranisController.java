package com.taranisblack.finance.controller;

import com.taranisblack.finance.model.FinanceReportDTO;
import com.taranisblack.finance.service.TaranisFinanceService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Mono;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/taranis")
public class TaranisController {

    @Autowired
    private TaranisFinanceService financeService;

    @Autowired
    private ObjectMapper objectMapper;

    @GetMapping(value = "/analise-ia", produces = MediaType.APPLICATION_JSON_VALUE)
    public Mono<ResponseEntity<FinanceReportDTO>> obterAnaliseTemplate(@RequestParam(defaultValue = "Geral") String foco) {
        return financeService.gerarAnaliseParaTemplate(foco)
            .map(jsonAi -> {
                try {
                    FinanceReportDTO dto = objectMapper.readValue(jsonAi, FinanceReportDTO.class);
                    return ResponseEntity.ok(dto);
                } catch (Exception e) {
                    FinanceReportDTO fallback = new FinanceReportDTO();
                    fallback.setPropriedades("NomeCompleto", "Consultor ONE G11");
                    fallback.setPropriedades("EmailAluno", "aluno@one.com.br");
                    fallback.setPropriedades("ResumoExecutivo", jsonAi);
                    return ResponseEntity.ok(fallback);
                }
            });
    }

    @GetMapping(value = "/evidencia", produces = MediaType.APPLICATION_JSON_VALUE)
    public Mono<ResponseEntity<FinanceReportDTO>> obterEvidencia() {
        return obterAnaliseTemplate("Geral");
    }

    @GetMapping(value = "/export/csv", produces = "text/csv")
    public Mono<ResponseEntity<String>> exportarCsvDinamico() {
        return obterAnaliseTemplate("Geral").map(responseEntity -> {
            FinanceReportDTO dto = responseEntity.getBody();
            Map<String, Object> props = (dto != null && dto.getPropriedades() != null) ? dto.getPropriedades() : Map.of();

            List<String> colunas = new ArrayList<>(props.keySet());
            StringBuilder csv = new StringBuilder();

            // Escreve o cabeçalho dinamicamente
            csv.append(String.join(",", colunas)).append("\n");

            // Escreve os valores dinamicamente usando List.add()
            List<String> valores = new ArrayList<>();
            for (String col : colunas) {
                Object val = props.get(col);
                String valStr = (val != null) ? val.toString() : "";
                valores.add("\"" + escapeCsv(valStr) + "\"");
            }
            csv.append(String.join(",", valores)).append("\n");

            HttpHeaders headers = new HttpHeaders();
            headers.set(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=template_rota4_financas_Entrega_ia.csv");

            return ResponseEntity.ok()
                    .headers(headers)
                    .body(csv.toString());
        });
    }

    private String escapeCsv(String text) {
        if (text == null) return "";
        return text.replace("\"", "\"\"");
    }
}
