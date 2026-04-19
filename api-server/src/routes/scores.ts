import { Router, type IRouter } from "express";
import { Pool } from "pg";

const pool = new Pool({ connectionString: process.env["DATABASE_URL"] });
const router: IRouter = Router();

router.post("/scores", async (req, res) => {
  try {
    const { studentName, gradeKey, unitIndex, lessonIndex, score, total } = req.body;
    if (!studentName || !gradeKey || unitIndex === undefined || lessonIndex === undefined || score === undefined || total === undefined) {
      res.status(400).json({ error: "بيانات ناقصة" });
      return;
    }
    const name = String(studentName).trim().slice(0, 100);
    if (!name) { res.status(400).json({ error: "اسم غير صالح" }); return; }

    await pool.query(
      `INSERT INTO student_scores (student_name, grade_key, unit_index, lesson_index, score, total)
       VALUES ($1,$2,$3,$4,$5,$6)
       ON CONFLICT (student_name, grade_key, unit_index, lesson_index)
       DO UPDATE SET score = GREATEST(student_scores.score, EXCLUDED.score),
                     total = EXCLUDED.total,
                     created_at = NOW()`,
      [name, gradeKey, Number(unitIndex), Number(lessonIndex), Number(score), Number(total)]
    );
    res.json({ success: true });
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

router.get("/scores/leaderboard", async (req, res) => {
  try {
    const { gradeKey } = req.query;
    if (!gradeKey) { res.status(400).json({ error: "gradeKey مطلوب" }); return; }

    const result = await pool.query(
      `SELECT
         student_name,
         SUM(score) AS total_score,
         SUM(total) AS total_possible,
         COUNT(*) AS lessons_count,
         ROUND(SUM(score)::numeric / NULLIF(SUM(total),0) * 100, 1) AS pct
       FROM student_scores
       WHERE grade_key = $1
       GROUP BY student_name
       ORDER BY total_score DESC, pct DESC
       LIMIT 5`,
      [gradeKey]
    );
    res.json(result.rows);
  } catch (e: any) {
    res.status(500).json({ error: e.message });
  }
});

export default router;
