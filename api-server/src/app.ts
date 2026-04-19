import express, { type Express } from "express";
import cors from "cors";
import pinoHttp from "pino-http";
import path from "path";
import { existsSync } from "fs";
import session from "express-session";
import connectPgSimple from "connect-pg-simple";
import pool from "./lib/db";
import router from "./routes";
import { logger } from "./lib/logger";

const app: Express = express();

async function initDB() {
  try {
    await pool.query(`
      CREATE TABLE IF NOT EXISTS questions (
        id SERIAL PRIMARY KEY, grade_key VARCHAR(10) NOT NULL, unit_index INTEGER NOT NULL,
        lesson_index INTEGER NOT NULL, question_text TEXT NOT NULL, option_a TEXT NOT NULL,
        option_b TEXT NOT NULL, option_c TEXT NOT NULL, option_d TEXT NOT NULL,
        correct_answer INTEGER NOT NULL, image_url TEXT, created_at TIMESTAMP DEFAULT now(),
        UNIQUE (grade_key, unit_index, lesson_index, question_text)
      );
      CREATE TABLE IF NOT EXISTS lesson_content (
        id SERIAL PRIMARY KEY, grade_key VARCHAR(20) NOT NULL, unit_index INTEGER NOT NULL,
        lesson_index INTEGER NOT NULL, content TEXT NOT NULL, updated_at TIMESTAMP DEFAULT now(),
        UNIQUE (grade_key, unit_index, lesson_index)
      );
      CREATE TABLE IF NOT EXISTS student_scores (
        id SERIAL PRIMARY KEY, student_name TEXT NOT NULL, grade_key TEXT NOT NULL,
        unit_index INTEGER NOT NULL, lesson_index INTEGER NOT NULL, score INTEGER NOT NULL,
        total INTEGER NOT NULL, created_at TIMESTAMP DEFAULT now(),
        UNIQUE (student_name, grade_key, unit_index, lesson_index)
      );
      CREATE TABLE IF NOT EXISTS session (
        sid VARCHAR NOT NULL PRIMARY KEY, sess JSON NOT NULL, expire TIMESTAMP(6) NOT NULL
      );
      CREATE INDEX IF NOT EXISTS idx_session_expire ON session (expire);
    `);
    console.log("✅ Database initialized");
  } catch (e) {
    console.error("❌ DB init error:", e);
  }
}

initDB();

app.set("trust proxy", 1);

app.use(pinoHttp({
  logger,
  serializers: {
    req(req) { return { id: req.id, method: req.method, url: req.url?.split("?")[0] }; },
    res(res) { return { statusCode: res.statusCode }; },
  },
}));

app.use(cors({ origin: true, credentials: true, methods: ["GET","POST","PUT","DELETE","OPTIONS"] }));
app.use(express.json({ limit: "15mb" }));
app.use(express.urlencoded({ extended: true, limit: "15mb" }));

const PgSession = connectPgSimple(session);

app.use(session({
  store: new PgSession({
    pool: pool,
    tableName: "session",
    createTableIfMissing: true,
    pruneSessionInterval: 900,
  }),
  name: "nour.sid",
  secret: process.env["SESSION_SECRET"] || "nour-edu-secret-2024",
  resave: false,
  saveUninitialized: false,
  rolling: true,
  cookie: {
    httpOnly: true,
    maxAge: 7 * 24 * 60 * 60 * 1000,
    sameSite: "lax",
    secure: false,
  },
}));

app.use("/api", router);

const staticDir = path.join(process.cwd(), "../nour-edu/dist/public");
if (existsSync(staticDir)) {
  app.use(express.static(staticDir, {
    setHeaders: (res, filePath) => {
      if (filePath.endsWith(".html")) {
        res.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, proxy-revalidate");
        res.setHeader("Pragma", "no-cache");
        res.setHeader("Expires", "0");
      }
    }
  }));
  app.get("/{*splat}", (_req, res) => {
    res.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
    res.sendFile(path.join(staticDir, "index.html"));
  });
}

export default app;
