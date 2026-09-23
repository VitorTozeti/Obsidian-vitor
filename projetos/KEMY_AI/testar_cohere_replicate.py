#!/usr/bin/env python3
"""
testar_cohere_replicate.py — teste isolado da Cohere e da Replicate para coisas
SIMPLES (sem tool-calling). Nao mexe no kemy.py; e so pra validar acesso/latencia
antes de decidir se entram como fallback da K.E.M.Y.

Chaves via variavel de ambiente (nao hardcoded):
    COHERE_API_KEY=...
    REPLICATE_API_TOKEN=...

Uso:
    python testar_cohere_replicate.py "sua pergunta aqui"
"""

import os
import sys
import time

import requests

PERGUNTA_PADRAO = "Em uma frase, o que e Python?"


def testar_cohere(pergunta: str) -> None:
    chave = os.environ.get("COHERE_API_KEY")
    if not chave:
        print("[Cohere] pulado — defina COHERE_API_KEY no ambiente.")
        return

    inicio = time.time()
    try:
        resp = requests.post(
            "https://api.cohere.com/v2/chat",
            headers={
                "Content-Type": "application/json",
                "Authorization": f"Bearer {chave}",
            },
            json={
                "model": "command-r",
                "messages": [{"role": "user", "content": pergunta}],
            },
            timeout=60,
        )
        dt = time.time() - inicio
        if not resp.ok:
            print(f"[Cohere] erro {resp.status_code} ({dt:.1f}s): {resp.text[:300]}")
            return
        data = resp.json()
        texto = "".join(
            bloco.get("text", "") for bloco in data.get("message", {}).get("content", [])
        )
        print(f"[Cohere] ok ({dt:.1f}s): {texto.strip()}")
    except requests.RequestException as exc:
        print(f"[Cohere] falha de conexao: {exc}")


def testar_replicate(pergunta: str) -> None:
    token = os.environ.get("REPLICATE_API_TOKEN")
    if not token:
        print("[Replicate] pulado — defina REPLICATE_API_TOKEN no ambiente.")
        return

    modelo = os.environ.get("REPLICATE_MODEL", "meta/meta-llama-3-8b-instruct")
    inicio = time.time()
    try:
        # Replicate usa "predictions" (assincrono) — a API wait= faz o request
        # segurar a resposta ate terminar (ate ~60s), sem precisar dar poll manual.
        resp = requests.post(
            f"https://api.replicate.com/v1/models/{modelo}/predictions",
            headers={
                "Content-Type": "application/json",
                "Authorization": f"Bearer {token}",
                "Prefer": "wait",
            },
            json={"input": {"prompt": pergunta}},
            timeout=90,
        )
        dt = time.time() - inicio
        if resp.status_code not in (200, 201):
            print(f"[Replicate] erro {resp.status_code} ({dt:.1f}s): {resp.text[:300]}")
            return
        data = resp.json()
        saida = data.get("output")
        if isinstance(saida, list):
            saida = "".join(str(p) for p in saida)
        status = data.get("status")
        print(f"[Replicate] status={status} ({dt:.1f}s): {str(saida).strip()[:500]}")
    except requests.RequestException as exc:
        print(f"[Replicate] falha de conexao: {exc}")


def main() -> None:
    pergunta = " ".join(sys.argv[1:]).strip() or PERGUNTA_PADRAO
    print(f"Pergunta de teste: {pergunta}\n")
    testar_cohere(pergunta)
    testar_replicate(pergunta)


if __name__ == "__main__":
    main()
