---
name: role-sp-dados
description: mapa de localização de dados, repositório, APIs externas e estruturas de dados do Role SP no trilho
tags: [proj/role-sp, dados, infra, integracao]
updated: 2026-09-07
---

# Role SP no trilho — Onde os Dados Vivem

Nota de localização técnica e integrações do projeto [[role-sp]].

## Repositórios e Links

- **Repositório Local no Disco:** `C:\Users\Vitor\Desktop\projetos\Linhas metros e pontos de interesse proj\Roles-na-linha-verde`
- **Repositório GitHub:** `VitorTozeti/Roles-na-linha-verde` (`https://github.com/VitorTozeti/Roles-na-linha-verde`)
- **Pipeline CI/CD:** `.github/workflows/jekyll-docker.yml` executando a cada push na branch `main`.
- **Deploy / Execução Local:** estático, abrindo diretamente `index.html` em qualquer navegador com conexão à internet para carregamento dos mapas e bibliotecas CDN.

## Estrutura de Arquivos

```
index.html       # Estrutura HTML: cabeçalho, painel lateral colapsável, container do mapa (#map)
styles.css       # Estilos completos da aplicação, layout responsivo e customizações do Leaflet
script.js        # Lógica central: coordenadas das linhas/estações, catálogo de POIs, clustering e buscas
```

## APIs Externas e Endpoints

1. **Overpass API (OpenStreetMap):**
   - Utilizada dinamicamente para consultar pontos de ônibus e rotas no raio de 1,5 km quando o usuário aciona o botão "Quero ir aqui".
   - Endpoint: servidor público da Overpass API (`https://overpass-api.de/api/interpreter`).
2. **Camadas de Mapa (Tile Providers):**
   - Mapas raster e vetoriais servidos a partir dos servidores de tiles do OpenStreetMap (`https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png`).
3. **Bibliotecas e Recursos por CDN:**
   - Leaflet CSS e JS: `unpkg.com/leaflet`
   - Leaflet.markercluster: `unpkg.com/leaflet.markercluster`
   - Font Awesome: CDN para ícones de categorias e navegação

## Estrutura dos Dados em Memória

- **Malha Metroviária:** coordenadas geográficas de estações e linhas mapeadas em objetos estáticos dentro de `script.js`.
- **Catálogo de Pontos:**
  - `pontosDeInteresse`: array principal de locais culturais, gastronômicos e turísticos.
  - `pontosExtrasGerados`: array de expansão dinâmica de novos locais.
- **Persistência de Dados:** o projeto não exige backend nem banco de dados persistente; todas as consultas e filtros operam diretamente na memória do cliente (DOM e Leaflet layer groups).
