---
name: role-sp-arquitetura
description: funcionamento do script.js, algoritmos de clustering, cálculo de rotas e guia de expansão de transporte do Role SP no trilho
tags: [proj/role-sp, arquitetura, gis, leaflet, dev-guide]
updated: 2026-09-07
---

# Role SP no trilho — Arquitetura e Guia de Atualizações Futuras

Documento técnico detalhado sobre o funcionamento da aplicação [[role-sp]], seus algoritmos geoespaciais e o guia prático para adicionar novas linhas, estações e locais.

---

## 1. Intuito e Proposta de Valor

A Região Metropolitana de São Paulo possui uma das redes metroferroviárias mais extensas da América Latina, além de milhares de opções de lazer, cultura e gastronomia. No entanto, turistas e moradores frequentemente encontram duas dificuldades:
1. **Desconexão entre transporte e destino:** saber qual estação atende determinado museu, parque ou centro gastronômico.
2. **Aplicativos pesados ou cheios de anúncios:** soluções comerciais costumam exigir cadastros, rastreamento de dados ou consumo excessivo de plano móvel.

O **Role SP no trilho** foi desenvolvido para ser uma **ferramenta pública, leve e instantânea**: uma página web estática que consolida toda a malha sobre trilhos e exibe atrações com cálculo automático de proximidade e integração inteligente de ônibus.

---

## 2. Funcionamento Interno e Algoritmos

Toda a inteligência da aplicação reside em `script.js` (~1.400 linhas), organizado de forma modular e sequencial.

### Ciclo de Inicialização
1. O HTML carrega a folha `styles.css` e os scripts do Leaflet e Font Awesome via CDN.
2. A tela exibe um overlay de carregamento (`#loading`).
3. O mapa Leaflet é instanciado centralizado na Praça da Sé (`[-23.5505, -46.6333]`).
4. São desenhadas as polilinhas e marcadores de todas as linhas habilitadas em `linhasTransporte`.
5. O catálogo de POIs é processado, sanitizado e inserido no grupo de clusterização.
6. A função `esconderLoading()` remove o overlay e `enquadrarVisiveis()` ajusta o viewport.

### Algoritmo de Distância e Estação Mais Próxima
Para cada ponto do catálogo, o script calcula a distância até todas as estações cadastradas utilizando a fórmula esférica de distância em metros:
```javascript
function distanciaMetros(lat1, lng1, lat2, lng2) {
  const R = 6371000; // Raio da Terra em metros
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLng = (lng2 - lng1) * Math.PI / 180;
  const a = Math.sin(dLat/2) * Math.sin(dLat/2) +
            Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
            Math.sin(dLng/2) * Math.sin(dLng/2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
  return R * c;
}
```
A função `estacaoMaisProxima(ponto)` itera pelas linhas ativas e retorna o nome da estação, linha correspondente e distância formatada.

### Otimização de Performance Mobile (Clustering & CSS)
- **Leaflet.markercluster:** em vez de injetar centenas de elementos no DOM simultaneamente, os pontos são agrupados em bolhas que se expandem com o zoom.
- **Desativação de Repaint Pesado:** o uso de filtros CSS de sombra (`filter: drop-shadow(...)`) nos ícones de marcadores foi removido nas versões recentes porque causava engasgos severos na GPU durante as ações de pan e zoom em telas sensíveis ao toque de aparelhos móveis.

### Algoritmo "Quero ir aqui" (Integração com Overpass / OpenStreetMap)
Quando o usuário seleciona um ponto turístico e clica em **"Quero ir aqui"**:
1. O app verifica se o ponto de partida do usuário está configurado (via GPS ou toque no mapa).
2. Se o destino estiver a **menos de 1.500 metros** de uma estação de metrô/trem, informa que o trajeto pode ser concluído a pé a partir do desembarque.
3. Se o destino estiver a **mais de 1.500 metros**:
   - Faz uma requisição assíncrona para a **Overpass API** buscando paradas de ônibus em um raio de 600m da origem e do destino:
     `node["highway"="bus_stop"](around:600, lat, lng); out body;`
   - O método `extrairLinhas()` lê as tags `route_ref` ou `lines` dos nós retornados.
   - Compara as linhas que passam perto da origem com as do destino e destaca as linhas diretas coincidentes.

---

## 3. Guia Prático para Atualizações Futuras

### A. Como Adicionar uma Nova Linha de Transporte
No início do arquivo `script.js`, localize o array `linhasTransporte`. Basta adicionar um novo objeto seguindo o padrão pré-configurado:
```javascript
{
  id: "linha6-laranja",
  nome: "Linha 6-Laranja",
  tipo: "Metrô",
  cor: "#FF6600",
  icone: "fa-train-subway",
  ativarPorPadrao: true,
  estacoes: [
    { nome: "Estação Brasilândia", lat: -23.4688, lng: -46.6890 },
    { nome: "Estação Freguesia do Ó", lat: -23.4988, lng: -46.6970 }
    // ... demais estações
  ]
}
```
O mapa desenhará o traçado automaticamente entre as coordenadas na ordem em que foram listadas.

### B. Como Adicionar Novos Pontos de Interesse (POIs)
Em `script.js`, adicione novos objetos aos arrays `pontosDeInteresse` ou `pontosExtrasGerados`:
```javascript
{
  nome: "Pinacoteca Contemporânea",
  categoria: "Cultura",
  lat: -23.5342,
  lng: -46.6329,
  desc: "Espaço dedicado à arte contemporânea anexo ao Parque da Luz.",
  distancia: "Perto da Estação Luz",
  foto: "https://url-da-imagem.jpg"
}
```
*Atenção:* se a propriedade `distancia` for omitida ou genérica, a função `estacaoMaisProxima()` calculará o valor em metros automaticamente.

### C. Como Criar uma Nova Categoria de Passeio
1. Adicione a categoria nos pontos em `script.js` (ex.: `categoria: "Vida Noturna"`).
2. Na função `criarIconeCategoria(categoria)`, adicione o ícone correspondente do Font Awesome e a classe de cor correspondente.
3. Em `styles.css`, configure a cor de fundo e borda do chip da categoria.
4. O gerador de filtros `renderizarChips()` criará o botão de filtro dinamicamente.

### D. Armadilhas e Cuidados Críticos
- **Rate Limit da Overpass API:** o servidor público da Overpass (`overpass-api.de`) pode recusar chamadas rápidas consecutivas (erro 429 ou 504). Para grandes volumes de usuários no futuro, recomenda-se configurar um cache intermediário ou backend próprio de espelhamento.
- **Ordem das Coordenadas nas Linhas:** certifique-se de listar as estações na sequência física correta da linha, pois o Leaflet traça linhas retas ponto a ponto sequencialmente.
