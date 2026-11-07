#!/bin/bash

machine="vmlinuxd"

# 1. Copia o arquivo .env para dentro da pasta do projeto se ele estiver na raiz
ENV_PATH=""
if [ -f "taranis-finance-ai/.env" ]; then
    ENV_PATH="taranis-finance-ai/.env"
    export GOOGLE_API_KEY=$(grep '^GOOGLE_API_KEY=' "$ENV_PATH" | cut -d '=' -f2 | tr -d '"' | tr -d "'" | tr -d '\r')
    if [ -n "$GOOGLE_API_KEY" ] && [ "$GOOGLE_API_KEY" != "sua_chave_real_do_gemini_aqui" ]; then
        primeiros="${GOOGLE_API_KEY:0:4}"
        ultimos="${GOOGLE_API_KEY: -4}"
        echo "🔑 GOOGLE_API_KEY carregada com sucesso: ${primeiros}••••••••${ultimos}"
        
        echo "Tentando liberar a porta 8000..."
        fuser -k 8000/tcp 2>/dev/null || true
        sleep 1

        # 2. Entra na pasta do projeto Spring Boot
        cd taranis-finance-ai || { echo "Erro: Pasta taranis-finance-ai não encontrada!"; exit 1; }

        echo "✅ Aplicação Taranis Black Spring Boot rodando com sucesso!"
        echo "🤖 Análise Descritiva via Gemini:     http://$machine:8000/api/taranis/analise-ia?foco=DRE"
        echo "📄 Evidência do Challenge (JSON):       http://$machine:8000/api/taranis/evidencia"
        echo "📥 Download JSON (Mala Direta Digital): http://$machine:8000/api/taranis/export/json"
        echo "📊 Download CSV (Mala Direta do Word):  http://$machine:8000/api/taranis/export/csv"



        # 3. Verifica se o mvnw existe; se não existir, usa o maven global do sistema ('mvn')
        if [ -f "./mvnw" ]; then
            ./mvnw spring-boot:run -Dspring-boot.run.arguments=--server.port=8000
        else
            echo "⚠️ Wrapper ./mvnw não encontrado. Usando o comando 'mvn' global do sistema..."
            mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=8000
        fi
        cd ..

    else
        echo "❌ [ALERTA CRÍTICO] A Chave da API do Gemini não foi configurada ou é o valor padrão!"
        echo " Por favor, atualize o arquivo .env com sua chave real antes de continuar."
    fi
fi

