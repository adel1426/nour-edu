import { Router, type IRouter } from "express";
import healthRouter from "./health";
import questionsRouter from "./questions";
import authRouter from "./auth";
import scoresRouter from "./scores";
import lessonsRouter from "./lessons";

const router: IRouter = Router();

router.use(authRouter);
router.use(healthRouter);
router.use(questionsRouter);
router.use(scoresRouter);
router.use(lessonsRouter);

export default router;
