#!/bin/bash

# ==============================================================================
# Script Gerador de Aplicação Java Spring Boot + Gemini API (WebClient Original)
# ==============================================================================

PROJECT_DIR="taranis-finance-ai"
rm -rf $PROJECT_DIR

echo "🚀 Criando a estrutura do projeto em: $PROJECT_DIR..."

mkdir -p "$PROJECT_DIR/src/main/java/com/taranisblack/finance/model"
mkdir -p "$PROJECT_DIR/src/main/java/com/taranisblack/finance/service"
mkdir -p "$PROJECT_DIR/src/main/java/com/taranisblack/finance/controller"
mkdir -p "$PROJECT_DIR/src/main/resources/static"
mkdir -p "$PROJECT_DIR/src/main/resources/dados"

cd "$PROJECT_DIR" || exit

echo "🔐 Criando arquivo .env na raiz do projeto..."
cat << 'EOF' > .env
GOOGLE_API_KEY=sua_chave_real_do_gemini_aqui
EOF

echo "📄 Criando arquivo pom.xml..."
cat << EOF > pom.xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" 
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.3.4</version>
        <relativePath/>
    </parent>

    <groupId>com.taranisblack</groupId>
    <artifactId>$PROJECT_DIR</artifactId>
    <version>1.0.0</version>
    <name>$PROJECT_DIR</name>
    <description>App Spring Boot com Gemini API (WebClient)</description>

    <properties>
        <java.version>17</java.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-webflux</artifactId>
        </dependency>
        <dependency>
            <groupId>com.fasterxml.jackson.core</groupId>
            <artifactId>jackson-databind</artifactId>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
EOF

echo "⚙️ Criando Dashboard..."
cat << 'EOF' > src/main/resources/static/index.html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>⚡</text></svg>" />
    <title>Dashboard Executivo | Taranis Black - Rota 4</title>
    <!-- Google Fonts para visual profissional -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #0f172a;
            --accent: #2563eb;
            --success: #16a34a;
            --warning: #d97706;
            --danger: #dc2626;
            --bg: #f8fafc;
            --card-bg: #ffffff;
            --text: #334155;
            --text-heading: #0f172a;
            --border: #e2e8f0;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Inter', sans-serif;
        }

        body {
            background-color: var(--bg);
            color: var(--text);
            line-height: 1.6;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        header {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            color: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        header h1 {
            font-size: 24px;
            font-weight: 700;
        }

        header p {
            font-size: 14px;
            color: #94a3b8;
        }

        .badge {
            background-color: var(--accent);
            color: white;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .actions-bar {
            display: flex;
            gap: 12px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        button, .btn {
            background-color: var(--accent);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: background 0.2s, transform 0.1s;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        button:hover, .btn:hover {
            opacity: 0.9;
            transform: translateY(-1px);
        }

        .btn-secondary {
            background-color: #475569;
        }

        .btn-success {
            background-color: var(--success);
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .card {
            background-color: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .card h3 {
            font-size: 16px;
            color: var(--text-heading);
            margin-bottom: 12px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .card p, .card div {
            font-size: 14px;
            color: var(--text);
        }

        .full-width {
            grid-column: 1 / -1;
        }

        .highlight-box {
            background-color: #f1f5f9;
            border-left: 4px solid var(--accent);
            padding: 16px;
            border-radius: 0 8px 8px 0;
            margin-top: 10px;
        }

        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 10px;
        }

        .metric-card {
            background: #f8fafc;
            border: 1px solid var(--border);
            padding: 15px;
            border-radius: 8px;
            text-align: center;
        }

        .metric-card h4 {
            font-size: 12px;
            color: #64748b;
            text-transform: uppercase;
            margin-bottom: 5px;
        }

        .metric-card span {
            font-size: 18px;
            font-weight: 700;
            color: var(--text-heading);
        }

        .loading {
            text-align: center;
            padding: 40px;
            font-size: 16px;
            color: #64748b;
        }

        footer {
            text-align: center;
            padding: 20px;
            font-size: 13px;
            color: #64748b;
            border-top: 1px solid var(--border);
            margin-top: 40px;
        }
    </style>
</head>
<body>

    <div class="container">
        <!-- Cabeçalho -->
        <header>
            <div>
                <h1>Taranis Black — Inteligência Financeira e Operacional</h1>
                <p>Programa Oracle Next Education (ONE G11) | Challenge Rota 4</p>
            </div>
            <span class="badge">Live AI Artifact</span>
        </header>

        <!-- Barra de Ações e Integração -->
        <div class="actions-bar">
            <button onclick="carregarAnalise()">🔄 Atualizar Análise da IA</button>
            <a href="/api/taranis/export/csv" class="btn btn-success">📥 Baixar CSV (Mala Direta Word)</a>
            <a href="/api/taranis/analise-ia" target="_blank" class="btn btn-secondary">🔗 Ver JSON Bruto</a>
        </div>

        <!-- Indicador de Carregamento -->
        <div id="loading" class="loading">🤖 Consultando o Gemini e processando dados da Taranis Black...</div>

        <!-- Grid de Conteúdo Dinâmico -->
        <div id="content-grid" class="grid" style="display: none;">
            
            <!-- Resumo Executivo -->
            <div class="card full-width">
                <h3>📊 Resumo Executivo para a CEO</h3>
                <div class="highlight-box">
                    <p id="resumoExecutivo">Carregando...</p>
                </div>
            </div>
            <!-- Fontes de Dados e Artefatos da Rota 4 -->
            <div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 20px; margin-top: 20px;">
                <h3 style="color: #1e293b; margin-top: 0; font-size: 1.1rem;">📂 Fontes de Dados e Artefatos Base da Rota 4</h3>
                <ul style="margin: 0; padding-left: 20px; color: #475569; font-size: 0.95rem; line-height: 1.6;">
                    <li><strong>DRE Orçado vs. Realizado:</strong> <code>05_Financas_Orcado_vs_Realizado.txt</code> (EBITDA de R$ 5,77mi vs R$ 9,85mi, PDD de R$ 1,11M e Fretes de R$ 960k)</li>
                    <li><strong>Processo Operacional & SIPOC:</strong> <code>06_Descritivo_Processo_Operacional_SIPOC.txt</code> (Gargalo de 48h em crédito e ERP legado)</li>
                    <li><strong>Base de People Analytics:</strong> <code>04_Base_Colaboradores_People_Analytics.txt</code> (280 colaboradores, turnover de 22,5%)</li>
                </ul>
            </div>
            <!-- Diagnóstico e Problema -->
            <div class="card">
                <h3>⚠️ Cenário & Gargalo Identificado</h3>
                <p id="cenarioProblema">Carregando...</p>
            </div>

            <!-- Ação Prioritária (Lean & IA) -->
            <div class="card">
                <h3>⚡ Recomendação Prioritária (Ação Lean)</h3>
                <p id="acaoPrioritaria">Carregando...</p>
            </div>

            <!-- Métricas de Impacto -->
            <div class="card full-width">
                <h3>🎯 Impactos e Metas de Sucesso</h3>
                <div class="metrics-grid">
                    <div class="metric-card">
                        <h4>Ciclo de Crédito</h4>
                        <span id="metricaSucesso">Carregando...</span>
                    </div>
                    <div class="metric-card">
                        <h4>Aluno Responsável</h4>
                        <span id="alunoNome">Consultor ONE</span>
                    </div>
                    <div class="metric-card">
                        <h4>Rota Ativa</h4>
                        <span id="rotaEscolhida">Rota 4</span>
                    </div>
                </div>
            </div>

        </div>

        <!-- Rodapé -->
        <footer>
            Oracle Next Education & Alura — Challenge Empresa Simulada Taranis Black (2026)
        </footer>
    </div>

    <!-- Script de Integração com o Backend Spring Boot -->
    <script>
        async function carregarAnalise() {
            const loadingEl = document.getElementById('loading');
            const gridEl = document.getElementById('content-grid');

            loadingEl.style.display = 'block';
            gridEl.style.display = 'none';

            try {
                const response = await fetch('/api/taranis/analise-ia?foco=DRE');
                if (!response.ok) throw new Error('Erro ao comunicar com a API');
                
                const data = await response.json();
                const props = data.propriedades || data;

                // 1. Resumo Executivo
                document.getElementById('resumoExecutivo').innerText = 
                    props.ResumoExecutivo || props.resumoExecutivo || 'Resumo executivo não retornado pela API.';
                
                // 2. Cenário / Gargalo (Atualizado para mapear CenarioProblema perfeitamente)
                document.getElementById('cenarioProblema').innerText = 
                    props.CenarioProblema || props.cenarioProblema || props.Cenario || 'Conciliação manual entre 3 planilhas e ERP legado.';
                
                // 3. Ação Prioritária
                document.getElementById('acaoPrioritaria').innerText = 
                    props.RecomendacaoPrioritaria || props.acaoPrioritaria || 'Automação de triagem e aprovação de crédito.';
                
                // 4. Tratamento seguro para as Métricas (evita o [object Object])
                let metricaTexto = props.MetricasSucesso || props.metricasSucesso || 'Redução do ciclo de 48h para < 1h.';
                if (typeof metricaTexto === 'object' && metricaTexto !== null) {
                    metricaTexto = Array.isArray(metricaTexto) ? metricaTexto.join(' • ') : Object.values(metricaTexto).join(' • ');
                }
                document.getElementById('metricaSucesso').innerText = metricaTexto;
                
                // 5. Aluno e Rota
                document.getElementById('alunoNome').innerText = 
                    props.NomeCompleto || props.alunoNome || 'Consultor ONE G11';
                
                document.getElementById('rotaEscolhida').innerText = 
                    props.TurmaCoorte ? `${props.TurmaCoorte} — Rota 4` : 'Rota 4 — Finanças e Operações';

                loadingEl.style.display = 'none';
                gridEl.style.display = 'grid';
            } catch (error) {
                console.error(error);
                loadingEl.innerHTML = '❌ Erro ao carregar os dados da API. Certifique-se de que a aplicação Spring Boot está rodando.';
            }
        }

        // Executa ao carregar a página
        window.onload = carregarAnalise;
    </script>
</body>
</html>
EOF

echo "📦 Criando Rotas (HomeController.java)..."
cat << 'EOF' > src/main/java/com/taranisblack/finance/controller/HomeController.java
package com.taranisblack.finance.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String index() {
        // Redireciona ou mapeia diretamente para o index.html na pasta static
        return "index.html";
    }
}
EOF

echo "⚙️ Criando arquivo application.properties..."
cat << 'EOF' > src/main/resources/application.properties
server.port=8000
spring.config.import=optional:file:.env[.properties]
google.api.key=${GOOGLE_API_KEY}
EOF

echo "📦 Criando DTO de Relatório (FinanceReportDTO.java)..."
cat << 'EOF' > src/main/java/com/taranisblack/finance/model/FinanceReportDTO.java
package com.taranisblack.finance.model;

import com.fasterxml.jackson.annotation.JsonAnyGetter;
import com.fasterxml.jackson.annotation.JsonAnySetter;
import lombok.Data;
import java.util.HashMap;
import java.util.Map;

@Data
public class FinanceReportDTO {
    
    private Map<String, Object> propriedades = new HashMap<>();

    @JsonAnyGetter
    public Map<String, Object> getPropriedades() {
        return propriedades;
    }

    @JsonAnySetter
    public void setPropriedades(String key, Object value) {
        propriedades.put(key, value);
    }
}
EOF

echo "🤖 Criando Cliente da API do Gemini via WebClient (GeminiApiClient.java)..."
cat << 'EOF' > src/main/java/com/taranisblack/finance/service/GeminiApiClient.java
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
EOF

echo "🤖 Criando Serviço de Análise e Triagem (TaranisFinanceService.java)..."
cat << 'EOF' > src/main/java/com/taranisblack/finance/service/TaranisFinanceService.java
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
EOF

echo "🌐 Criando Controller REST com Endpoints e Exportação (TaranisController.java)..."
cat << 'EOF' > src/main/java/com/taranisblack/finance/controller/TaranisController.java
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
EOF

echo "🚀 Criando classe principal (TaranisApplication.java)..."
cat << 'EOF' > src/main/java/com/taranisblack/finance/TaranisApplication.java
package com.taranisblack.finance;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class TaranisApplication {
    public static void main(String[] args) {
        SpringApplication.run(TaranisApplication.class, args);
    }
}
EOF


# Copia os arquivos de base e de entrega oficial para dentro da aplicação
cp "../../Challenge/Material de Apoio/04_Base_Colaboradores_People_Analytics.txt" "src/main/resources/dados/"
cp "../../Challenge/Material de Apoio/05_Financas_Orcado_vs_Realizado.txt" "src/main/resources/dados/"
cp "../../Challenge/Material de Apoio/06_Descritivo_Processo_Operacional_SIPOC.txt" "src/main/resources/dados/"
cp "../../Challenge/Entrega/template_rota4_financas_Entrega.csv" "src/main/resources/dados/"

echo "✅ Todos os arquivos foram copiados com sucesso para a pasta de recursos internos!"

cd ..
chmod -R 777 $PROJECT_DIR

echo "✅ Projeto WebClient recriado e pronto!"
echo "Para compilar e executar:"
echo "  cd $PROJECT_DIR"
echo "  mvn clean spring-boot:run"

echo "⚠️ Não esqueça de subir o .env novamente!"