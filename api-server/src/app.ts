import express, { type Express } from "express";
import cors from "cors";
import pinoHttp from "pino-http";
import path from "path";
import { existsSync } from "fs";
import session from "express-session";
import connectPgSimple from "connect-pg-simple";
import router from "./routes";
import { logger } from "./lib/logger";

const app: Express = express();

app.set("trust proxy", 1);

app.use(
  pinoHttp({
    logger,
    serializers: {
      req(req) {
        return {
          id: req.id,
          method: req.method,
          url: req.url?.split("?")[0],
        };
      },
      res(res) {
        return {
          statusCode: res.statusCode,
        };
      },
    },
  }),
);
app.use(cors({ origin: true, credentials: true }));
app.use(express.json({ limit: "15mb" }));
app.use(express.urlencoded({ extended: true, limit: "15mb" }));

const PgSession = connectPgSimple(session);

app.use(session({
  store: new PgSession({
    conString: process.env["DATABASE_URL"],
    tableName: "session",
    createTableIfMissing: false,
  }),
  secret: process.env["SESSION_SECRET"] || "nour-edu-secret-2024",
  resave: false,
  saveUninitialized: false,
  cookie: {
    httpOnly: true,
    maxAge: 7 * 24 * 60 * 60 * 1000,
    sameSite: "lax",
    secure: process.env["NODE_ENV"] === "production",
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
