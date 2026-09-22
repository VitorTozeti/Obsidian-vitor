#!/usr/bin/env node
import "dotenv/config";
import readline from "node:readline/promises";
import { stdin, stdout } from "node:process";
import { runAgentTurn } from "./agent.js";

const apiKey = process.env.GROK_API_KEY;

if (!apiKey) {
  console.error(
    "GROK_API_KEY nao encontrada. Copie .env.example para .env e coloque sua chave da xAI."
  );
  process.exit(1);
}

const rl = readline.createInterface({ input: stdin, output: stdout });

console.log("grok-code-cli — assistente de codigo estilo Claude Code (powered by Grok)");
console.log(`Pasta atual: ${process.cwd()}`);
console.log('Digite sua tarefa, ou "sair" para encerrar.\n');

let history = [];

while (true) {
  const input = await rl.question("voce> ");
  if (!input.trim()) continue;
  if (["sair", "exit", "quit"].includes(input.trim().toLowerCase())) break;

  try {
    const { reply, history: newHistory } = await runAgentTurn(
      input,
      history,
      apiKey,
      (event) => {
        if (event.type === "tool_call") {
          console.log(`\n[ferramenta] ${event.name}(${JSON.stringify(event.args)})`);
        } else if (event.type === "tool_result") {
          const preview =
            typeof event.result === "string" && event.result.length > 400
              ? event.result.slice(0, 400) + "…"
              : event.result;
          console.log(`[resultado] ${preview}\n`);
        }
      }
    );
    history = newHistory;
    console.log(`\ngrok> ${reply}\n`);
  } catch (err) {
    console.error(`\nErro: ${err.message}\n`);
  }
}

rl.close();
console.log("Ate mais!");
