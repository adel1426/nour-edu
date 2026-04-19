import { Router, type IRouter, type Request, type Response, type NextFunction } from "express";

const router: IRouter = Router();

const ADMIN_USER = process.env["ADMIN_USERNAME"] || "admin";
const ADMIN_PASS = process.env["ADMIN_PASSWORD"] || "nour2024";

declare module "express-session" {
  interface SessionData {
    isAdmin: boolean;
  }
}

router.post("/auth/login", (req: Request, res: Response) => {
  const { username, password } = req.body;
  if (username === ADMIN_USER && password === ADMIN_PASS) {
    req.session.isAdmin = true;
    res.json({ success: true });
  } else {
    res.status(401).json({ error: "اسم المستخدم أو كلمة المرور غير صحيحة" });
  }
});

router.post("/auth/logout", (req: Request, res: Response) => {
  req.session.destroy(() => {
    res.json({ success: true });
  });
});

router.get("/auth/me", (req: Request, res: Response) => {
  res.json({ isAdmin: !!req.session.isAdmin });
});

export function requireAdmin(req: Request, res: Response, next: NextFunction) {
  if (req.session.isAdmin) {
    return next();
  }
  res.status(401).json({ error: "غير مصرح. يرجى تسجيل الدخول أولاً." });
}

export default router;
