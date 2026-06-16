#!/usr/bin/env node

const SERVER_NAME = "sap-adt-mcp-server";
const SERVER_VERSION = "0.1.0";

const ADT_XML = "application/vnd.sap.adt+xml";
const TEXT = "text/plain";

const tools = [
  {
    name: "adt_ping",
    description: "Checks that the SAP ADT endpoint is reachable with the configured credentials.",
    inputSchema: {
      type: "object",
      properties: {}
    }
  },
  {
    name: "adt_discovery",
    description: "Reads the ADT discovery document from /sap/bc/adt/discovery.",
    inputSchema: {
      type: "object",
      properties: {}
    }
  },
  {
    name: "adt_get",
    description: "Performs a GET request against an ADT path. Use paths such as /sap/bc/adt/discovery.",
    inputSchema: {
      type: "object",
      required: ["path"],
      properties: {
        path: {
          type: "string",
          description: "Absolute ADT path beginning with /sap/bc/adt/."
        },
        accept: {
          type: "string",
          description: "Optional Accept header.",
          default: ADT_XML
        }
      }
    }
  },
  {
    name: "adt_read_class_source",
    description: "Reads the active source code of a global ABAP class through ADT.",
    inputSchema: {
      type: "object",
      required: ["className"],
      properties: {
        className: {
          type: "string",
          description: "Global class name, for example ZCL_SDC_CONSOLE."
        }
      }
    }
  },
  {
    name: "adt_read_program_source",
    description: "Reads the active source code of an ABAP program through ADT.",
    inputSchema: {
      type: "object",
      required: ["programName"],
      properties: {
        programName: {
          type: "string",
          description: "Program name, for example ZSD_COCKPIT_ECC."
        }
      }
    }
  },
  {
    name: "adt_search_objects",
    description: "Runs ADT repository quick search for ABAP objects.",
    inputSchema: {
      type: "object",
      required: ["query"],
      properties: {
        query: {
          type: "string",
          description: "Search query, for example ZCL_SDC*."
        },
        maxResults: {
          type: "number",
          description: "Maximum results requested from ADT.",
          default: 50
        }
      }
    }
  }
];

function config() {
  const baseUrl = process.env.SAP_ADT_URL;
  const auth = process.env.SAP_ADT_AUTH || "basic";
  const user = process.env.SAP_ADT_USER;
  const password = process.env.SAP_ADT_PASSWORD;
  const oauthUrl = process.env.SAP_ADT_OAUTH_URL;
  const clientId = process.env.SAP_ADT_CLIENT_ID;
  const clientSecret = process.env.SAP_ADT_CLIENT_SECRET;
  const client = process.env.SAP_ADT_CLIENT;
  const language = process.env.SAP_ADT_LANGUAGE || "EN";

  const missing = [];
  if (!baseUrl) missing.push("SAP_ADT_URL");
  if (auth === "oauth") {
    if (!oauthUrl) missing.push("SAP_ADT_OAUTH_URL");
    if (!clientId) missing.push("SAP_ADT_CLIENT_ID");
    if (!clientSecret) missing.push("SAP_ADT_CLIENT_SECRET");
  } else {
    if (!user) missing.push("SAP_ADT_USER");
    if (!password) missing.push("SAP_ADT_PASSWORD");
  }

  return {
    baseUrl,
    auth,
    user,
    password,
    oauthUrl,
    clientId,
    clientSecret,
    client,
    language,
    missing,
    rejectUnauthorized: process.env.SAP_REJECT_UNAUTHORIZED !== "false"
  };
}

function basicAuth(user, password) {
  return `Basic ${Buffer.from(`${user}:${password}`).toString("base64")}`;
}

let cachedToken = null;

async function oauthToken(cfg) {
  const now = Math.floor(Date.now() / 1000);
  if (cachedToken && cachedToken.expiresAt > now + 30) {
    return cachedToken.accessToken;
  }

  const tokenUrl = new URL("/oauth/token", `${normalizeBaseUrl(cfg.oauthUrl)}/`);
  const response = await fetch(tokenUrl, {
    method: "POST",
    headers: {
      Authorization: basicAuth(cfg.clientId, cfg.clientSecret),
      "Content-Type": "application/x-www-form-urlencoded",
      Accept: "application/json",
      "User-Agent": `${SERVER_NAME}/${SERVER_VERSION}`
    },
    body: new URLSearchParams({
      grant_type: "client_credentials"
    })
  });

  const body = await response.text();
  if (!response.ok) {
    throw new Error(`OAuth token request failed: HTTP ${response.status} ${response.statusText}\n${body.slice(0, 2000)}`);
  }

  const json = JSON.parse(body);
  cachedToken = {
    accessToken: json.access_token,
    expiresAt: now + Number(json.expires_in || 300)
  };
  return cachedToken.accessToken;
}

async function authorizationHeader(cfg) {
  if (cfg.auth === "oauth") {
    return `Bearer ${await oauthToken(cfg)}`;
  }
  return basicAuth(cfg.user, cfg.password);
}

function normalizeBaseUrl(value) {
  return value.replace(/\/+$/, "");
}

function ensureAdtPath(path) {
  if (!path || typeof path !== "string") {
    throw new Error("ADT path is required.");
  }
  if (!path.startsWith("/sap/bc/adt/")) {
    throw new Error("ADT path must start with /sap/bc/adt/.");
  }
  return path;
}

function encodeObjectName(name) {
  if (!name || typeof name !== "string") {
    throw new Error("ABAP object name is required.");
  }
  return encodeURIComponent(name.trim().toLowerCase());
}

async function adtFetch(path, options = {}) {
  const cfg = config();
  if (cfg.missing.length) {
    throw new Error(`Missing required environment variables: ${cfg.missing.join(", ")}`);
  }

  if (!cfg.rejectUnauthorized) {
    process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";
  }

  const url = new URL(ensureAdtPath(path), `${normalizeBaseUrl(cfg.baseUrl)}/`);
  if (cfg.client) {
    url.searchParams.set("sap-client", cfg.client);
  }
  if (cfg.language) {
    url.searchParams.set("sap-language", cfg.language);
  }
  if (options.searchParams) {
    for (const [key, value] of Object.entries(options.searchParams)) {
      if (value !== undefined && value !== null) {
        url.searchParams.set(key, String(value));
      }
    }
  }

  const response = await fetch(url, {
    method: options.method || "GET",
    headers: {
      Authorization: await authorizationHeader(cfg),
      Accept: options.accept || ADT_XML,
      "User-Agent": `${SERVER_NAME}/${SERVER_VERSION}`,
      ...options.headers
    },
    body: options.body
  });

  const body = await response.text();
  if (!response.ok) {
    throw new Error(`ADT request failed: HTTP ${response.status} ${response.statusText}\n${body.slice(0, 2000)}`);
  }

  return {
    status: response.status,
    contentType: response.headers.get("content-type") || "",
    body
  };
}

async function callTool(name, args = {}) {
  switch (name) {
    case "adt_ping": {
      const result = await adtFetch("/sap/bc/adt/discovery", { accept: ADT_XML });
      return `Connected to ADT. HTTP ${result.status}. Content-Type: ${result.contentType}`;
    }
    case "adt_discovery": {
      const result = await adtFetch("/sap/bc/adt/discovery", { accept: ADT_XML });
      return result.body;
    }
    case "adt_get": {
      const result = await adtFetch(args.path, { accept: args.accept || ADT_XML });
      return result.body;
    }
    case "adt_read_class_source": {
      const className = encodeObjectName(args.className);
      const path = `/sap/bc/adt/oo/classes/${className}/source/main`;
      const result = await adtFetch(path, {
        accept: TEXT,
        searchParams: { version: "active" }
      });
      return result.body;
    }
    case "adt_read_program_source": {
      const programName = encodeObjectName(args.programName);
      const path = `/sap/bc/adt/programs/programs/${programName}/source/main`;
      const result = await adtFetch(path, {
        accept: TEXT,
        searchParams: { version: "active" }
      });
      return result.body;
    }
    case "adt_search_objects": {
      const result = await adtFetch("/sap/bc/adt/repository/informationsystem/search", {
        accept: ADT_XML,
        searchParams: {
          operation: "quickSearch",
          query: args.query,
          maxResults: args.maxResults || 50
        }
      });
      return result.body;
    }
    default:
      throw new Error(`Unknown tool: ${name}`);
  }
}

function content(text) {
  return {
    content: [
      {
        type: "text",
        text: String(text)
      }
    ]
  };
}

function success(id, result) {
  return JSON.stringify({
    jsonrpc: "2.0",
    id,
    result
  });
}

function failure(id, error) {
  return JSON.stringify({
    jsonrpc: "2.0",
    id,
    error: {
      code: -32000,
      message: error instanceof Error ? error.message : String(error)
    }
  });
}

async function handle(message) {
  const { id, method, params } = message;

  switch (method) {
    case "initialize":
      return success(id, {
        protocolVersion: params?.protocolVersion || "2024-11-05",
        capabilities: {
          tools: {}
        },
        serverInfo: {
          name: SERVER_NAME,
          version: SERVER_VERSION
        }
      });
    case "notifications/initialized":
      return null;
    case "tools/list":
      return success(id, { tools });
    case "tools/call": {
      const text = await callTool(params.name, params.arguments || {});
      return success(id, content(text));
    }
    default:
      return failure(id, new Error(`Unsupported MCP method: ${method}`));
  }
}

async function runCheck() {
  const cfg = config();
  const printable = {
    SAP_ADT_URL: cfg.baseUrl || null,
    SAP_ADT_AUTH: cfg.auth,
    SAP_ADT_CLIENT: cfg.client || null,
    SAP_ADT_USER: cfg.user || null,
    SAP_ADT_OAUTH_URL: cfg.oauthUrl || null,
    SAP_ADT_CLIENT_ID: cfg.clientId || null,
    SAP_ADT_LANGUAGE: cfg.language,
    SAP_REJECT_UNAUTHORIZED: String(cfg.rejectUnauthorized)
  };

  if (cfg.missing.length) {
    console.error(`Missing required environment variables: ${cfg.missing.join(", ")}`);
    console.error(JSON.stringify(printable, null, 2));
    process.exit(1);
  }

  const result = await callTool("adt_ping");
  console.log(result);
}

async function main() {
  if (process.argv.includes("--check")) {
    await runCheck();
    return;
  }

  let buffer = "";
  process.stdin.setEncoding("utf8");
  process.stdin.on("data", async (chunk) => {
    buffer += chunk;
    const lines = buffer.split(/\r?\n/);
    buffer = lines.pop() || "";

    for (const line of lines) {
      if (!line.trim()) continue;
      try {
        const response = await handle(JSON.parse(line));
        if (response) {
          process.stdout.write(`${response}\n`);
        }
      } catch (error) {
        let id = null;
        try {
          id = JSON.parse(line).id ?? null;
        } catch {
          id = null;
        }
        process.stdout.write(`${failure(id, error)}\n`);
      }
    }
  });
}

main().catch((error) => {
  console.error(error instanceof Error ? error.stack : error);
  process.exit(1);
});
