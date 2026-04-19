import { Router, type IRouter } from "express";
import pool from "../lib/db";
import { requireAdmin } from "./auth";

const router: IRouter = Router();

router.get("/questions/counts", async (req, res) => {
  try {
    const { gradeKey } = req.query;
    if (!gradeKey) return res.status(400).json({ error: "gradeKey required" });
    const result = await pool.query(
      `SELECT unit_index, lesson_index, COUNT(*)::int AS count FROM questions WHERE grade_key = $1 GROUP BY unit_index, lesson_index`,
      [gradeKey]
    );
    const counts: Record<string, number> = {};
    result.rows.forEach((r) => { counts[`${r.unit_index}|${r.lesson_index}`] = r.count; });
    res.json(counts);
  } catch (e) { res.status(500).json({ error: String(e) }); }
});

router.get("/questions", async (req, res) => {
  try {
    const { gradeKey, unitIndex, lessonIndex } = req.query;
    let query = "SELECT * FROM questions";
    const params: (string | number)[] = [];
    const conditions: string[] = [];
    if (gradeKey) { conditions.push(`grade_key = $${params.length + 1}`); params.push(gradeKey as string); }
    if (unitIndex !== undefined) { conditions.push(`unit_index = $${params.length + 1}`); params.push(Number(unitIndex)); }
    if (lessonIndex !== undefined) { conditions.push(`lesson_index = $${params.length + 1}`); params.push(Number(lessonIndex)); }
    if (conditions.length > 0) query += " WHERE " + conditions.join(" AND ");
    query += " ORDER BY created_at ASC";
    const result = await pool.query(query, params);
    res.json(result.rows);
  } catch (err) { res.status(500).json({ error: String(err) }); }
});

router.post("/questions", requireAdmin, async (req, res) => {
  try {
    const { grade_key, unit_index, lesson_index, question_text, option_a, option_b, option_c, option_d, correct_answer, image_url } = req.body;
    if (!grade_key || unit_index === undefined || lesson_index === undefined || !question_text || !option_a || !option_b || !option_c || !option_d || correct_answer === undefined) {
      return res.status(400).json({ error: "Missing required fields" });
    }
    const result = await pool.query(
      `INSERT INTO questions (grade_key, unit_index, lesson_index, question_text, option_a, option_b, option_c, option_d, correct_answer, image_url)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10) ON CONFLICT (grade_key, unit_index, lesson_index, question_text) DO NOTHING RETURNING *`,
      [grade_key, unit_index, lesson_index, question_text, option_a, option_b, option_c, option_d, correct_answer, image_url || null]
    );
    if (result.rows.length === 0) return res.status(409).json({ error: "السؤال موجود مسبقاً" });
    res.status(201).json(result.rows[0]);
  } catch (err) { res.status(500).json({ error: String(err) }); }
});

router.put("/questions/:id", requireAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    const { question_text, option_a, option_b, option_c, option_d, correct_answer, image_url } = req.body;
    const result = await pool.query(
      `UPDATE questions SET question_text=$1, option_a=$2, option_b=$3, option_c=$4, option_d=$5, correct_answer=$6, image_url=$7 WHERE id=$8 RETURNING *`,
      [question_text, option_a, option_b, option_c, option_d, correct_answer, image_url || null, id]
    );
    if (result.rows.length === 0) return res.status(404).json({ error: "Not found" });
    res.json(result.rows[0]);
  } catch (err) { res.status(500).json({ error: String(err) }); }
});

router.delete("/questions/:id", requireAdmin, async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query("DELETE FROM questions WHERE id=$1 RETURNING id", [id]);
    if (result.rows.length === 0) return res.status(404).json({ error: "Not found" });
    res.json({ success: true });
  } catch (err) { res.status(500).json({ error: String(err) }); }
});

router.post("/questions/bulk", requireAdmin, async (req, res) => {
  try {
    const { grade_key, unit_index, lesson_index, questions } = req.body;
    if (!grade_key || unit_index === undefined || lesson_index === undefined || !Array.isArray(questions) || questions.length === 0) {
      return res.status(400).json({ error: "Missing required fields" });
    }
    let inserted = 0, skipped = 0;
    const errors: { row: number; error: string }[] = [];
    for (let i = 0; i < questions.length; i++) {
      const q = questions[i];
      if (!q.question_text || !q.option_a || !q.option_b || !q.option_c || !q.option_d || q.correct_answer === undefined) {
        errors.push({ row: i + 2, error: "بيانات ناقصة" }); continue;
      }
      try {
        const r = await pool.query(
          `INSERT INTO questions (grade_key, unit_index, lesson_index, question_text, option_a, option_b, option_c, option_d, correct_answer)
           VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9) ON CONFLICT (grade_key, unit_index, lesson_index, question_text) DO NOTHING`,
          [grade_key, Number(unit_index), Number(lesson_index), q.question_text, q.option_a, q.option_b, q.option_c, q.option_d, Number(q.correct_answer)]
        );
        if (r.rowCount && r.rowCount > 0) inserted++; else skipped++;
      } catch (err) { errors.push({ row: i + 2, error: String(err) }); }
    }
    res.json({ inserted, skipped, errors });
  } catch (err) { res.status(500).json({ error: String(err) }); }
});

export default router;
