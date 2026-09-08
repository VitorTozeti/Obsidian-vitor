---
name: role-sp-interface
description: detalhamento da interface e dos dados do Role SP (14 linhas, ~156 POIs em 20 categorias, painéis, funções e fluxo "Quero ir aqui")
tags: [proj/role-sp, interface, dados, referencia-tecnica]
updated: 2026-09-08
---

# Role SP no trilho — Detalhamento da Interface e dos Dados

Como o [[role-sp]] é uma página única (`index.html` + `styles.css` + `script.js` de
**1.384 linhas**), este detalhamento trata cada **painel da interface** e cada
**função/estrutura de dados** como uma unidade. Deriva da leitura direta do
`script.js`. Para algoritmos aprofundados ver [[role-sp-arquitetura]]; para infra ver
[[role-sp-dados]].

## Seções da interface (`index.html`)
- **Cabeçalho / topo** — título do app e controles principais.
- **Painel lateral colapsável** — busca, chips de filtro por categoria e lista de
  resultados; recolhível para experiência em tela cheia no celular.
- **Container do mapa (`#map`)** — mapa Leaflet ocupando a área principal.
- **Overlay de carregamento (`#loading`)** — removido por `esconderLoading()` após
  desenhar linhas e POIs.
- **Botão "Quero ir aqui"** — dentro do popup/card do POI selecionado.
- **Controles de origem** — definir ponto de partida por toque no mapa ou GPS.
- **Meta tags PWA** — `theme-color`, ícones e modo standalone.

## Camada de mapa e clustering
- **Mapa:** `L.map("map", {zoomControl:false, preferCanvas:true}).setView([-23.568, -46.648], 12)`.
  *(Correção vs. nota antiga: o centro é `[-23.568, -46.648]` zoom 12, não a Praça da Sé.)*
- **Tiles:** OpenStreetMap `https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png`, `maxZoom: 19`.
- **Clustering:** `L.markerClusterGroup` com `maxClusterRadius: 55` e
  `disableClusteringAtZoom: 17` (a partir desse zoom, marcadores individuais).

## Linhas de transporte (`linhasTransporte`)
São **14 linhas** (208 registros de estação somando repetições em baldeações):

| id | nome | tipo | cor | ativa por padrão |
|---|---|---|---|---|
| `linha1-azul` | Linha 1-Azul | Metrô | #00539F | sim |
| `linha2-verde` | Linha 2-Verde | Metrô | #008055 | sim |
| `linha3-vermelha` | Linha 3-Vermelha | Metrô | #EE3E34 | sim |
| `linha4-amarela` | Linha 4-Amarela | Metrô | #FFCC00 | sim |
| `linha5-lilas` | Linha 5-Lilás | Metrô | #A05DA5 | sim |
| `linha15-prata` | Linha 15-Prata | Monotrilho | #8E8E8E | sim |
| `linha6-laranja` | Linha 6-Laranja | Metrô | #F58220 | **não** (nasce oculta) |
| `linha7-rubi` | Linha 7-Rubi | Trem (CPTM) | #B5121B | sim |
| `linha8-diamante` | Linha 8-Diamante | Trem (CPTM) | #A7A9AC | sim |
| `linha9-esmeralda` | Linha 9-Esmeralda | Trem (CPTM) | #00A651 | sim |
| `linha10-turquesa` | Linha 10-Turquesa | Trem (CPTM) | #0086A8 | sim |
| `linha11-coral` | Linha 11-Coral | Trem (CPTM) | #E74C3C | sim |
| `linha12-safira` | Linha 12-Safira | Trem (CPTM) | #0088CC | sim |
| `linha13-jade` | Linha 13-Jade | Trem (CPTM) | #00A86B | sim |

Cada linha tem `estacoes: [{nome, lat, lng}]`; o Leaflet traça a polilinha ponto a
ponto **na ordem listada** (por isso a ordem física importa). Tipos previstos no
esquema: `Metrô | CPTM | Monotrilho | Ônibus | Ciclovia`.

## Catálogo de POIs (~156 pontos em 20 categorias)
Arrays `pontosDeInteresse` e `pontosExtrasGerados`. Contagem por categoria:

| Categoria | Qtd | Categoria | Qtd |
|---|---|---|---|
| Parque | 27 | Compras | 7 |
| Cultura | 27 | Lazer | 7 |
| Museu | 20 | Turismo | 7 |
| Shopping | 16 | Atração | 4 |
| Alimentação | 10 | Biblioteca | 4 |
| Bar/Noite | 7 | Mercado | 4 |
| Comercial | 3 | Esporte | 3 |
| Mirante | 3 | Restaurante | 2 |
| Teatro | 2 | Cinema | 1 |
| Universidade | 1 | Partida (marcador de origem) | 1 |

**Forma do objeto de POI:**
```js
{ nome, categoria, lat, lng, desc, distancia, foto }
```
Fotos vêm de `images.unsplash.com`. O sistema **deduplica** por nome/categoria e, se
`distancia` for omitida/genérica, calcula a estação mais próxima em metros.

## Funções-chave (`script.js`)
- **`distanciaMetros(lat1,lng1,lat2,lng2)`** — distância esférica (Haversine, R=6.371.000 m).
- **`estacaoMaisProxima(ponto)`** — itera as linhas ativas e retorna estação, linha e distância.
- **`criarIconeCategoria(categoria)`** — ícone Font Awesome + cor por categoria.
- **`popupPonto(ponto, indice)`** — monta o card/popup do POI (com botão "Quero ir aqui").
- **`criarClusterPOI()`** — cria o grupo de clusterização e injeta os marcadores.
- **`renderizarChips()`** — gera dinamicamente os chips de filtro por categoria.
- **`aplicarFiltros()`** — aplica busca (nome/categoria/estação/linha) e chips ativos.
- **`enquadrarVisiveis()` / `ajustarParaViewport()`** — ajustam o viewport aos pontos visíveis.
- **`definirOrigem(lat,lng)` / `atualizarStatusOrigem()` / `pararEscolhaOrigem()`** —
  ponto de partida por toque no mapa; geolocalização via `navigator.geolocation.getCurrentPosition`.
- **`escaparHtml(valor)`** — sanitização de texto nos popups.

## Fluxo "Quero ir aqui" (`tratarQueroIrAqui` → Overpass)
1. Verifica se há origem definida (GPS ou toque).
2. `LIMITE_A_PE_METROS = 1500`: se o destino está a **< 1.500 m** de uma estação,
   informa que dá para concluir a pé a partir do desembarque.
3. Se **≥ 1.500 m**, chama `buscarParadasProximas(lat, lng, raioMetros = 600)` para
   origem **e** destino, com a query Overpass:
   ```
   [out:json][timeout:15];node(around:600,LAT,LNG)[highway=bus_stop];out body;
   ```
   endpoint `https://overpass-api.de/api/interpreter?data=...`.
4. `extrairLinhas(paradas)` lê a tag `route_ref` (ou `lines`) dos nós retornados;
   `montarHtmlRota()` compara as linhas da origem com as do destino e destaca as
   **linhas de ônibus diretas coincidentes**. `listaParadasHtml()` monta o painel.

## Estilos e performance (`styles.css`)
- Layout responsivo mobile-first; chips de categoria com cores próprias por categoria.
- **Remoção de `drop-shadow`** dos ícones de marcador nas versões recentes — o filtro
  causava engasgos de GPU durante pan/zoom em telas touch.

## Bibliotecas via CDN
- Leaflet (CSS+JS) e Leaflet.markercluster (via `unpkg.com`), Font Awesome (ícones),
  Google Fonts. Tiles e Overpass do OpenStreetMap. Detalhes em [[role-sp-dados]].

## Armadilhas
- **Rate limit da Overpass** (`overpass-api.de`): chamadas rápidas seguidas podem
  retornar 429/504 — para escala, considerar cache/backend espelho.
- **Ordem das coordenadas** nas linhas define o traçado (retas sequenciais).
- **Linha 6-Laranja nasce oculta** (`ativarPorPadrao:false`) — obra em andamento.
