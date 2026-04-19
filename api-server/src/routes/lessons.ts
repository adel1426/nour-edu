import { Router, type IRouter } from "express";
import pool from "../lib/db";
import { requireAdmin } from "./auth";

const router: IRouter = Router();

router.get("/lessons/content", async (req, res) => {
  try {
    const { gradeKey, unitIndex, lessonIndex } = req.query;
    const result = await pool.query(
      `SELECT content, updated_at FROM lesson_content WHERE grade_key=$1 AND unit_index=$2 AND lesson_index=$3`,
      [gradeKey, Number(unitIndex), Number(lessonIndex)]
    );
    if (result.rows.length === 0) return res.json({ content: null });
    res.json({ content: result.rows[0].content, updated_at: result.rows[0].updated_at });
  } catch (e) { res.status(500).json({ error: String(e) }); }
});

router.put("/lessons/content", requireAdmin, async (req, res) => {
  try {
    const { grade_key, unit_index, lesson_index, content } = req.body;
    if (!grade_key || unit_index === undefined || lesson_index === undefined || !content) {
      return res.status(400).json({ error: "Missing required fields" });
    }
    await pool.query(
      `INSERT INTO lesson_content (grade_key, unit_index, lesson_index, content) VALUES ($1,$2,$3,$4)
       ON CONFLICT (grade_key, unit_index, lesson_index) DO UPDATE SET content=$4, updated_at=NOW()`,
      [grade_key, Number(unit_index), Number(lesson_index), content]
    );
    res.json({ success: true });
  } catch (e) { res.status(500).json({ error: String(e) }); }
});

export default router;
