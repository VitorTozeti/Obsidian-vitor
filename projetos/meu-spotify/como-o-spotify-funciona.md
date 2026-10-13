---
name: como-o-spotify-funciona
description: como o Spotify funciona por dentro (catálogo, codecs, streaming em chunks, CDN, DRM, offline) e o que o Meu Spotify copia ou não
tags: [projeto, proj/meu-spotify, referencia, arquitetura]
updated: 2026-10-13
---

# Como o Spotify funciona (e o que o Meu Spotify copia)

Pesquisa na web (2026-10-13), sem o app instalado. Parte vem de material oficial antigo
(KTH 2010, [PDF](https://www.csc.kth.se/~gkreitz/spotify-p2p10/spotify-p2p10.pdf)), parte de
guias de system design que **não são oficiais** (marcado ⚠️). Complementa [[meu-spotify]] e
[[meu-spotify-dados]].

## Fluxo de uma reprodução
1. **Catálogo/metadados:** o cliente consulta serviços (busca, playlists, recomendação) via
   API Gateway + microsserviços ⚠️. Ficam separados do áudio.
2. **Áudio:** cada faixa existe em vários níveis de qualidade, em **Ogg Vorbis** (histórico:
   q5 ≈160 kbps grátis, q9 ≈320 kbps Premium; hoje há também AAC baixo e FLAC lossless ⚠️).
3. **Entrega em chunks:** o arquivo é fatiado (~10 s ⚠️) e o cliente mantém buffer de ~30–60 s ⚠️;
   baixa a próxima faixa antes da atual acabar (gapless/crossfade). Em 2010 vinha de servidores
   + P2P entre usuários; o P2P foi abandonado, hoje é CDN com cache nas bordas ⚠️.
4. **DRM:** os arquivos são criptografados e o cliente pega a chave num servidor de licença ⚠️.
   Por isso o áudio não é um MP3 solto que dê para salvar.
5. **Offline (Premium):** o app baixa esses mesmos chunks criptografados no dispositivo; só
   toca dentro do app e exige reconexão periódica para validar a assinatura.
6. **Recomendação:** histórico + comportamento de ouvintes geram Discover Weekly, rádio etc.

## O que o Meu Spotify replica
| Spotify | Meu Spotify |
|---|---|
| Catálogo licenciado (gravadoras) | Audius, Jamendo, arquivos do próprio usuário |
| Streaming em chunks + CDN | `<audio>` HTML5 com URL do Audius |
| Download criptografado | Blob em IndexedDB |
| Fila, playlists, favoritos | Zustand + IndexedDB |
| Recomendação | não existe ainda |

## Limite que não muda
O que a assinatura paga é a **licença do catálogo mainstream**, não a tecnologia. O player,
o offline e as playlists são viáveis de graça; os hits das gravadoras, não (ver
[[meu-spotify-dados]], "Limites legais"). Substituir o plano pago por completo só é possível
para quem aceita ouvir o catálogo Audius/Jamendo + a própria biblioteca.

## Próximos passos úteis
Rodar `npm install && npm run dev` e validar busca/stream/download; Service Worker + manifest
PWA; playlists persistidas; Jamendo como segunda fonte; importar a biblioteca local de forma
persistente.
