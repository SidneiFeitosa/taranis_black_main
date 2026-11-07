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
