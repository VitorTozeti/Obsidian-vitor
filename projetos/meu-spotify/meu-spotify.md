---
name: meu-spotify
description: app pessoal de música tipo Spotify, de graça, usando APIs gratuitas, com escuta offline (salvando as faixas localmente) — só para uso próprio
tags: [projeto, proj/meu-spotify, app, musica, offline, ideia]
updated: 2026-09-14
---

# Meu Spotify (player pessoal offline)

Ideia: um **app de música pessoal**, "um Spotify só para mim, de graça", que use **APIs
gratuitas** e permita **ouvir mesmo offline** — salvando as faixas de alguma forma no
dispositivo. Uso estritamente pessoal.

## Estado atual (2026-09-14)

- **Fase:** ideia registrada + **análise de viabilidade feita** (ver abaixo). Sem repo, sem
  código ainda.
- **Veredito de viabilidade:** **é possível — com uma ressalva importante sobre o catálogo.**
  Um app grátis, com escuta offline, é totalmente factível **desde que a música venha de
  fontes legais e gratuitas**. O que **não** é viável (legal e tecnicamente) é baixar e
  guardar offline o **catálogo de grandes gravadoras** (os "hits" do Spotify) de graça — o
  Spotify não libera o áudio completo via API (só metadados + preview de 30s) e baixar de
  fontes tipo YouTube fere os Termos de Uso. Detalhes e o "porquê" em [[meu-spotify-dados]].
- **Caminho recomendado:** construir sobre **Audius** (catálogo aberto, faixas completas em
  320 kbps, streaming grátis e permissionado) e/ou **Jamendo** (Creative Commons), que
  **permitem** download/uso offline legalmente. Complementar com um **modo "minha
  biblioteca"** que toca arquivos de música que **você já possui** (import local).

## O ponto central: dá para ouvir offline de graça?

**Sim, com a fonte certa.** A escuta offline é um problema resolvido tecnicamente (baixar o
arquivo e guardar no dispositivo). A pergunta real é **de onde vem a música**:

| Fonte | Grátis? | Faixa completa? | Download/offline permitido? | Catálogo |
|---|---|---|---|---|
| **Audius** | ✅ | ✅ (320 kbps) | ✅ (permissionado, pede creditar artista) | Indie/aberto (grande) |
| **Jamendo** | ✅ | ✅ | ✅ (Creative Commons) | Indie/CC |
| **Deezer** (grátis) | ✅ | ❌ só busca + preview 30s | ❌ | 90M+ (mas só preview) |
| **Spotify API** | ✅ p/ dados | ❌ só metadados + preview | ❌ (playback full exige Premium+SDK) | Mainstream |
| **YouTube / yt-dlp** | ✅ | ✅ | ❌ **fere os Termos de Uso** | Tudo |
| **Meus arquivos** (import) | ✅ | ✅ | ✅ (são seus) | O que você tiver |

**Conclusão honesta:** para ter os "hits das grandes gravadoras" offline e de graça não
existe caminho legal — isso é justamente o que a assinatura do Spotify vende. Mas um
**player pessoal ótimo, grátis e offline** é 100% viável combinando **Audius + Jamendo +
sua própria biblioteca local**.

## Funcionalidades principais (proposta)

1. **Busca e player:** buscar faixas/artistas/playlists nas APIs, tocar com controles
   normais (play/pause, fila, próxima).
2. **Escuta offline:** botão "baixar" que salva a faixa no dispositivo (ver estratégia em
   [[meu-spotify-dados]]); tela "Baixadas" que toca sem internet.
3. **Minha biblioteca local:** importar arquivos de áudio que você já tem e tocá-los junto.
4. **Playlists e favoritos:** criar playlists locais, marcar favoritos, histórico.
5. **(Opcional) Metadados ricos:** usar Spotify/Deezer/MusicBrainz **só para dados**
   (capa, artista, gênero), sem depender deles para o áudio.

## Arquitetura e tecnologias (proposta a validar)

- **É "app":** duas rotas boas para offline —
  - **PWA** (React/Vite + Service Worker + **Cache API/IndexedDB**): instala como app,
    guarda faixas offline, um código só p/ web+mobile. Mais simples de começar.
  - **App nativo** (**React Native** ou **Flutter**): acesso melhor a armazenamento/
    reprodução em background e download de arquivos grandes. Melhor experiência mobile.
  - Recomendação: **começar PWA** (prova de conceito rápida) e migrar p/ React Native se
    precisar de background playback robusto.
- **Áudio + offline:** stream via API → ao "baixar", persistir o arquivo (IndexedDB/FS) e
  tocar a partir do local quando offline. Detalhe técnico em [[meu-spotify-dados]].
- **Backend:** idealmente **nenhum** (local-first, como [[greenfinance]]) — tudo no
  dispositivo. Só entra um backend se precisar esconder chave de API ou sincronizar entre
  aparelhos.

## Notas detalhadas

- [[meu-spotify-dados]] — onde os dados vivem: APIs de música (Audius/Jamendo/Deezer/Spotify),
  o que cada uma libera, estratégia de armazenamento offline e limites legais.
