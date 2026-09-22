import { toolDefinitions, runTool } from "./tools.js";

const API_URL = "https://api.x.ai/v1/chat/completions";
const MODEL = process.env.GROK_MODEL || "grok-code-fast-1";

const SYSTEM_PROMPT = `Voce e um assistente de engenharia de software rodando em um terminal,
similar ao Claude Code. Voce tem acesso a ferramentas para ler, escrever e listar
arquivos e para rodar comandos de shell dentro da pasta do projeto atual.
Sempre que precisar inspecionar ou modificar codigo, use as ferramentas em vez de
inventar conteudo. Explique brevemente o que vai fazer antes de agir e resuma o
resultado ao final. Responda em portugues do Brasil.`;

export async function callGrok(messages, apiKey) {
  const res = await fetch(API_URL, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${apiKey}`,
    },
    body: JSON.stringify({
      model: MODEL,
      messages,
      tools: toolDefinitions,
      tool_choice: "auto",
      temperature: 0.2,
    }),
  });

  if (!res.ok) {
    const text = await res.text();
    throw new Error(`Erro da API xAI (${res.status}): ${text}`);
  }

  return res.json();
}

export async function runAgentTurn(userInput, history, apiKey, onEvent) {
  const messages = [
    { role: "system", content: SYSTEM_PROMPT },
    ...history,
    { role: "user", content: userInput },
  ];

  let finalContent = "";
  const MAX_STEPS = 12;

  for (let step = 0; step < MAX_STEPS; step++) {
    const data = await callGrok(messages, apiKey);
    const choice = data.choices?.[0];
    if (!choice) throw new Error("Resposta vazia da API.");

    const message = choice.message;
    messages.push(message);

    const toolCalls = message.tool_calls;
    if (!toolCalls || toolCalls.length === 0) {
      finalContent = message.content || "";
      break;
    }

    for (const call of toolCalls) {
      const name = call.function.name;
      let args = {};
      try {
        args = JSON.parse(call.function.arguments || "{}");
      } catch {
        args = {};
      }

      onEvent?.({ type: "tool_call", name, args });

      let result;
      try {
        result = runTool(name, args);
      } catch (err) {
        result = `Erro: ${err.message}`;
      }

      onEvent?.({ type: "tool_result", name, result });

      messages.push({
        role: "tool",
        tool_call_id: call.id,
        content: typeof result === "string" ? result : JSON.stringify(result),
      });
    }
  }

  const newHistory = messages.slice(1); // remove system prompt
  return { reply: finalContent, history: newHistory };
}
