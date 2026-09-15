---
name: meu-spotify-dados
description: onde os dados vivem no Meu Spotify — APIs de música (Audius, Jamendo, Deezer, Spotify), o que cada uma libera, armazenamento offline e limites legais
tags: [projeto, proj/meu-spotify, dados, api, musica, offline]
updated: 2026-09-15
---

# Meu Spotify — Onde os dados vivem

Mapa de **localização** dos dados do [[meu-spotify]]: de onde vem o áudio, o que cada API
permite e como guardar offline. (Regra de negócio/decisões ficam no hub.)

## Repositório real no disco

- **Caminho local:** `C:\Users\v.tozeti\Desktop\Vitor\teste\Spotify-2\spotify-vitor`
- **Estado (2026-09-15):** **Fase 1 do plano aplicada.** Arquivos criados manualmente
  (Node.js não estava no PATH da máquina, então não deu pra rodar `npm create vite` nem
  `npm install` — os arquivos de config/deps foram escritos à mão e ainda precisam de
  `npm install` para gerar `node_modules`/lockfile e validar que builda).
  - `package.json`: React 18, react-router-dom, zustand, idb, `@audius/sdk`; Vite+TS.
  - `src/router.tsx`: rotas `/` (Buscar), `/biblioteca`, `/baixadas`, `/playlist/:id`.
  - `src/store/useStore.ts`: estado do player (fila, faixa atual, play/pause/next/prev).
  - `src/db/db.ts`: IndexedDB via `idb` — stores `downloads`, `playlists`, `favorites`.
  - `src/audius/client.ts`: `searchTracks` e `getStreamUrl` usando `@audius/sdk`
    (`sdk({ appName: 'meu-spotify' })`, sem API key — uso de leitura pública).
  - `src/components/Player.tsx`: `<audio>` controlado pelo store, troca `src` conforme
    `currentTrack` (stream do Audius ou Blob local via `URL.createObjectURL`).
  - `src/pages/Search.tsx`: busca no Audius + botão "Baixar" (`fetch` do stream → `Blob` →
    `saveDownload` no IndexedDB).
  - `src/pages/Downloads.tsx`: lista faixas baixadas do IndexedDB, toca via Blob URL.
  - `src/pages/Library.tsx`: `<input type="file">` para importar áudio próprio (Blob URL,
    sem persistência ainda — só na sessão).
  - `src/pages/Playlist.tsx`: placeholder, playlists persistidas ficam para Fase 4.
  - **Pendente para validar:** rodar `npm install && npm run dev` e testar busca/stream/
    download/offline no navegador real (não foi possível nesta sessão por falta de Node).
- **Deploy no GitHub Pages — bug encontrado e corrigido (2026-09-15):** o repo estava no
  GitHub (`https://github.com/VitorTozeti/spotify-vitor`) mas o site não funcionava porque
  o workflow em `.github/workflows/` era o **padrão de Jekyll** gerado automaticamente pelo
  GitHub Pages — ele só copia os arquivos crus (não builda o app React/Vite/TS), então o
  Pages publicava `index.html` apontando pra `/src/main.tsx` sem nenhum bundle JS válido.
  **Correção aplicada:** troquei o workflow para instalar deps (`npm install`) e rodar
  `npm run build` (gera `dist/`) antes de publicar, renomeei o arquivo para
  `.github/workflows/deploy.yml`, e defini `base: '/spotify-vitor/'` em `vite.config.ts`
  (necessário pro Pages, que serve em subpath `usuario.github.io/spotify-vitor/`). Commit
  `5079644` enviado direto pra `main` (autorizado pelo usuário).
  **Ainda falta verificar manualmente:** em Settings → Pages do repo no GitHub, o "Source"
  precisa estar em **"GitHub Actions"** (não "Deploy from a branch") pro novo workflow
  assumir a publicação — não deu pra confirmar isso automaticamente (sem `gh` CLI/sessão
  logada disponível nesta máquina).

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

## Plano de implementação (2026-09-15)

Fases definidas para o repositório `spotify-vitor` (ver caminho acima), stack PWA local-first:

1. **Scaffold:** Vite + React + TypeScript; Zustand p/ estado; `idb` p/ IndexedDB
   (faixas baixadas, playlists, favoritos); react-router com rotas Buscar/Biblioteca/
   Baixadas/Playlist.
2. **Fonte de áudio:** integrar `@audius/sdk` (stream+busca, fonte principal) e Jamendo API
   (OAuth simples, fonte secundária); player HTML5 `<audio>` com fila/play/pause/next/prev.
3. **Offline:** botão "baixar" salva Blob no IndexedDB; Service Worker (Workbox) cacheia o
   app; tela "Baixadas" toca 100% local; import de arquivos próprios via `<input type="file">`.
4. **Polimento:** metadados/capa opcionalmente do Deezer/Spotify Web API (nunca para áudio);
   manifest PWA instalável; playlists locais, histórico, favoritos.
5. **(Futuro, opcional):** migrar para React Native se precisar de background playback
   mais robusto no celular.

Ainda não iniciado — usuário pediu só o planejamento por enquanto.
