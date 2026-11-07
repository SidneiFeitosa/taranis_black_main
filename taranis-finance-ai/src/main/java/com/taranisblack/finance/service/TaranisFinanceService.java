package com.taranisblack.finance.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

@Service
public class TaranisFinanceService {

    private final GeminiApiClient geminiApiClient;
    private final ObjectMapper objectMapper;

    private static final String PROMPT_TEMPLATE_ENTREGA = """
        Você é um consultor financeiro e de processos sênior de IA especializado na Taranis Black (Rota 4).
        Com base exclusivamente nos três arquivos de base fornecidos:
        1. 05_Financas_Orcado_vs_Realizado.txt (DRE, EBITDA de R$ 5,77mi vs R$ 9,85mi, fretes de R$ 960k, PDD de R$ 1,11M).
        2. 06_Descritivo_Processo_Operacional_SIPOC.txt (Fluxo em 5 passos, gargalo de 48h em crédito, ERP legado e planilhas isoladas).
        3. 04_Base_Colaboradores_People_Analytics.txt (Turnover de 22,5% e impacto de colaboradores).

        Gere os dados formatados em um objeto JSON válido contendo exatamente as chaves abaixo:
        - NomeCompleto
        - EmailAluno
        - TurmaCoorte
        - ResumoExecutivo
        - CenarioProblema (Detalhe explicitamente a conciliação manual entre 3 planilhas e o ERP legado, o atraso de 5 dias no fechamento, o ciclo de 48h em crédito, a PDD de R$ 1,11M e o turnover de 22,5%)
        - RecomendacaoPrioritaria
        - MetricasSucesso
        - CasosDeUso
        - ClassificacaoIA
        - SupervisaoHumana
        - MatrizEsforco
        - PlanoMudanca
        - PoliticaIA
        - RiscosLGPD
        - ComiteAuditoria
        - MatrizSIPOC
        - DiagramaIshikawa
        - TopCausas
        - PromptsProcessamento
        - DashboardRelatorioGerado
        - AnomaliasIdentificadas
        - ProjecaoTrimestre
        - Evidencia1_Artefato
        - Evidencia1_Descricao
        - Evidencia1_Link
        - Evidencia1_Print
        - Evidencia1_NotaUso
        - Evidencia2_Artefato
        - Evidencia2_Descricao
        - Evidencia2_Link
        - Evidencia2_Print
        - Evidencia2_NotaUso
        - Evidencia3_Artefato
        - Evidencia3_Descricao
        - Evidencia3_Link
        - Evidencia3_Print
        - Evidencia3_NotaUso
        - Evidencia4_Artefato
        - Evidencia4_Descricao
        - Evidencia4_Link
        - Evidencia4_Print
        - Evidencia4_NotaUso
        - Evidencia5_Artefato
        - Evidencia5_Descricao
        - Evidencia5_Link
        - Evidencia5_Print
        - Evidencia5_NotaUso

        Responda APENAS com o JSON válido, sem NENHUM texto adicional, sem crases, sem markdown.
        """;
        
    public TaranisFinanceService(GeminiApiClient geminiApiClient, ObjectMapper objectMapper) {
        this.geminiApiClient = geminiApiClient;
        this.objectMapper = objectMapper;
    }

    public Mono<String> gerarAnaliseParaTemplate(String foco) {
        String promptCompleto = PROMPT_TEMPLATE_ENTREGA + "\nFoco adicional: " + foco;

        return geminiApiClient.generateContent("gemini-2.5-flash", promptCompleto)
            .map(jsonResponse -> {
                try {
                    JsonNode root = objectMapper.readTree(jsonResponse);
                    JsonNode textNode = root.at("/candidates/0/content/parts/0/text");
                    if (!textNode.isMissingNode() && !textNode.isNull()) {
                        String rawText = textNode.asText();
                        return rawText.replaceAll("(?s)```json\\s*(.*?)\\s*```", "$1")
                                      .replaceAll("(?s)```\\s*(.*?)\\s*```", "$1")
                                      .trim();
                    }
                } catch (Exception e) {
                    // Retorna o JSON bruto caso venha estruturado diferente
                }
                return jsonResponse;
            });
    }
}
