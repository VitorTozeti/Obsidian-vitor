---
name: role-sp
description: mapa interativo das linhas de metrô, trem e monotrilho de SP com pontos turísticos, culturais e integração de ônibus via OpenStreetMap
tags: [projeto, proj/role-sp, mapas, mobilidade, leaflet, pwa]
updated: 2026-09-08
---

# Role SP no trilho

Aplicação web estática que oferece um mapa interativo consolidando todas as linhas de metrô, trem e monotrilho da Região Metropolitana de São Paulo, acompanhadas por um catálogo categorizado de pontos de interesse (cultura, compras, lazer, gastronomia e passeios).

O app funciona de forma leve no navegador, combinando dados geoespaciais em tempo de execução com a Overpass API do OpenStreetMap para sugerir conexões de ônibus quando o destino final está distante da malha sobre trilhos.

## Estado atual (2026-09-08)

- **Localização dos dados:** consulte [[role-sp-dados]] para repositório, estrutura de scripts, fontes de dados e endpoints de API.
- **Detalhamento da interface e dos dados:** ver [[role-sp-interface]] — painéis, 14 linhas (tabela), ~156 POIs em 20 categorias e o fluxo "Quero ir aqui".
- **Malha atual:** 14 linhas (5 Metrô, 1 Monotrilho, 8 Trem/CPTM); a Linha 6-Laranja nasce oculta (`ativarPorPadrao:false`). Mapa centralizado em `[-23.568, -46.648]` zoom 12.
- **Produção / Hospedagem:** repositório versionado no GitHub (`VitorTozeti/Roles-na-linha-verde`) com pipeline de deploy configurado via GitHub Actions (`jekyll-docker.yml`).
- **Otimização Mobile:** clusterização ativa de marcadores via `Leaflet.markercluster` e remoção de filtros de sombra pesados em repaint para garantir navegação fluida em celulares.
- **Roteamento Multimodal de Ônibus:** integração funcional com a Overpass API identificando pontos de ônibus reais próximos quando a distância até a estação mais próxima supera 1,5 km.

## Funcionalidades Principais

1. **Malha de Transporte Integrada:**
   - Traçado e estações de todas as linhas de metrô (Metrô SP e concessionárias ViaQuatro, ViaMobilidade), trens da CPTM e monotrilho.
2. **Catálogo de Pontos de Interesse:**
   - Locais classificados por categorias temáticas (Cultura, Gastronomia, Parques, Compras, etc.).
   - Agrupamento inteligente (*clustering*) que condensa marcadores em bolhas numéricas conforme o nível de zoom.
3. **Busca e Filtros Rápidos:**
   - Pesquisa por nome do local, categoria, nome da estação ou linha de metrô próxima.
   - Painel lateral responsivo e recolhível projetado para experiência em tela cheia no smartphone.
4. **Ponto de Partida e Modo "Quero ir aqui":**
   - Definição do ponto de partida por toque direto no mapa ou geolocalização do aparelho (GPS).
   - Cálculo automático da distância até a estação de metrô/trem mais próxima.
   - Caso a distância ultrapasse 1,5 km, consulta o OpenStreetMap para listar as paradas de ônibus reais na origem e no destino, sugerindo linhas compartilhadas.
5. **Preparação para PWA:**
   - Meta tags de tema (`theme-color`), ícones e modo standalone para instalação na tela inicial móvel.

## Arquitetura e Tecnologias

- **Frontend Core:** HTML5, CSS3 moderno e JavaScript puro (sem frameworks pesados).
- **Mapeamento e GIS:**
  - `Leaflet.js` (biblioteca de renderização de mapas vetoriais/raster).
  - `Leaflet.markercluster` (gerenciamento de performance para centenas de POIs).
  - Cartografia base via OpenStreetMap tiles.
- **APIs Externas:**
  - `Overpass API` (OpenStreetMap): consultas em tempo real para pontos de ônibus e nós de transporte urbano.
  - Font Awesome e Google Fonts via CDN.
- **CI/CD:** GitHub Actions para publicação contínua.

## Estrutura de Cadastro de Pontos

Novos pontos são adicionados diretamente nas estruturas de dados em `script.js` (`pontosDeInteresse` ou `pontosExtrasGerados`):

```js
{
  nome: "Nome do lugar",
  categoria: "Cultura",
  lat: -23.55,
  lng: -46.63,
  desc: "Descrição curta do passeio.",
  distancia: "Perto da Estação X",
  foto: "https://..."
}
```
O sistema deduplica automaticamente os registros por nome/categoria e calcula a distância euclidiana/geodésica para a estação mais próxima.

## Notas detalhadas

- [[role-sp-interface]] — detalhamento da interface e dos dados (painéis, tabela das 14 linhas, ~156 POIs em 20 categorias, funções e fluxo "Quero ir aqui")
- [[role-sp-dados]] — onde os dados vivem (repositório real, estrutura de arquivos, endpoints de mapa e APIs)
- [[role-sp-arquitetura]] — funcionamento do script.js, algoritmos de clustering, cálculo de rotas e guia de expansão de transporte
