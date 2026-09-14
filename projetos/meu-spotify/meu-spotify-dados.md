---
name: meu-spotify-dados
description: onde os dados vivem no Meu Spotify — APIs de música (Audius, Jamendo, Deezer, Spotify), o que cada uma libera, armazenamento offline e limites legais
tags: [projeto, proj/meu-spotify, dados, api, musica, offline]
updated: 2026-09-14
---

# Meu Spotify — Onde os dados vivem

Mapa de **localização** dos dados do [[meu-spotify]]: de onde vem o áudio, o que cada API
permite e como guardar offline. (Regra de negócio/decisões ficam no hub.)

## Repositório real no disco

- **Ainda não criado.** Registrar aqui o caminho local e o repositório GitHub quando nascer.

## APIs de música (fontes candidatas)

### Audius (recomendada como base) — áudio completo grátis
- **Docs:** `https://docs.audius.org` · **SDK JS:** `@audius/sdk` · scaffold: `npx create-audius-app`.
- **O que dá:** query/busca/**stream** de faixas, usuários e playlists; catálogo aberto em
  **320 kbps**; **totalmente gratuito**. Plataforma descentralizada (Open Audio Protocol).
- **Regras:** seguir as guidelines e **sempre creditar o artista**. Uso/offline permitido.

### Jamendo — Creative Commons
- **API:** OAuth; tier gratuito com limites generosos. Música **royalty-free / CC**.
- **O que dá:** faixas completas, download legal para uso pessoal. Catálogo indie.

### Deezer — só metadados + preview
- **Grátis:** busca em 90M+ faixas, mas áudio só **preview de 30s**. Útil p/ **capa/metadados**,
  **não** para tocar faixa inteira.

### Spotify Web API — só dados, não áudio
- **Grátis** para metadados (capa, artista, gênero, features de áudio) e **preview de 30s**.
- **NÃO** entrega o áudio completo por download; playback full só via **Web Playback SDK**
  exigindo conta **Premium** do ouvinte e **sem** salvar arquivo (DRM). Serve só como
  **fonte de metadados**, nunca como fonte offline.

## ⚠️ Limites legais (o "porquê" do veredito)

- **Baixar de fontes não autorizadas** (YouTube via yt-dlp, sites de "mp3 grátis") para ter
  os hits das grandes gravadoras offline **fere os Termos de Uso** dessas plataformas e/ou
  direitos autorais. Não é o caminho do projeto.
- **Offline legal e grátis** só existe onde o **detentor dos direitos permite**: Audius,
  Jamendo (CC) e **arquivos que o próprio usuário já possui**. É por isso que o hub
  recomenda combinar essas três fontes em vez de tentar "clonar o catálogo do Spotify".

## Armazenamento offline (estratégia técnica)

- **PWA:** ao "baixar", buscar o arquivo de áudio da API e persistir em **IndexedDB** (Blob)
  ou **Cache API** via Service Worker; ao tocar offline, servir a partir do armazenamento
  local. Estado (playlists, favoritos, histórico) em IndexedDB/localStorage.
- **Nativo (React Native/Flutter):** salvar o arquivo no **filesystem** do app e indexar os
  metadados num banco local (SQLite). Permite background playback e arquivos grandes.
- **Import local:** dar ao usuário a opção de adicionar arquivos de áudio próprios à
  biblioteca — 100% offline e sem questão legal.
