import fs from "node:fs";
import path from "node:path";
import { execSync } from "node:child_process";

const ROOT = process.cwd();

function safeResolve(relPath) {
  const resolved = path.resolve(ROOT, relPath);
  if (!resolved.startsWith(ROOT)) {
    throw new Error(`Caminho fora da pasta do projeto negado: ${relPath}`);
  }
  return resolved;
}

export const toolDefinitions = [
  {
    type: "function",
    function: {
      name: "read_file",
      description: "Le o conteudo de um arquivo de texto dentro do projeto.",
      parameters: {
        type: "object",
        properties: {
          path: { type: "string", description: "Caminho relativo do arquivo" },
        },
        required: ["path"],
      },
    },
  },
  {
    type: "function",
    function: {
      name: "write_file",
      description: "Cria ou sobrescreve um arquivo de texto dentro do projeto.",
      parameters: {
        type: "object",
        properties: {
          path: { type: "string", description: "Caminho relativo do arquivo" },
          content: { type: "string", description: "Conteudo completo a gravar" },
        },
        required: ["path", "content"],
      },
    },
  },
  {
    type: "function",
    function: {
      name: "list_dir",
      description: "Lista arquivos e pastas dentro de um diretorio do projeto.",
      parameters: {
        type: "object",
        properties: {
          path: { type: "string", description: "Caminho relativo do diretorio (padrao '.')" },
        },
      },
    },
  },
  {
    type: "function",
    function: {
      name: "run_command",
      description: "Executa um comando de shell dentro da pasta do projeto e retorna a saida. Use com cuidado.",
      parameters: {
        type: "object",
        properties: {
          command: { type: "string", description: "Comando a executar" },
        },
        required: ["command"],
      },
    },
  },
];

export function runTool(name, args) {
  switch (name) {
    case "read_file": {
      const p = safeResolve(args.path);
      return fs.readFileSync(p, "utf-8");
    }
    case "write_file": {
      const p = safeResolve(args.path);
      fs.mkdirSync(path.dirname(p), { recursive: true });
      fs.writeFileSync(p, args.content, "utf-8");
      return `Arquivo gravado: ${args.path}`;
    }
    case "list_dir": {
      const p = safeResolve(args.path || ".");
      const entries = fs.readdirSync(p, { withFileTypes: true });
      return entries
        .map((e) => (e.isDirectory() ? `${e.name}/` : e.name))
        .join("\n");
    }
    case "run_command": {
      try {
        const out = execSync(args.command, {
          cwd: ROOT,
          encoding: "utf-8",
          timeout: 60_000,
          maxBuffer: 10 * 1024 * 1024,
        });
        return out || "(comando executado sem saida)";
      } catch (err) {
        return `Erro ao executar comando: ${err.message}\n${err.stdout || ""}\n${err.stderr || ""}`;
      }
    }
    default:
      throw new Error(`Ferramenta desconhecida: ${name}`);
  }
}
