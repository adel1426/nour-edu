import express from "express";
import cors from "cors";
import session from "express-session";
import pg from "pg";
import { existsSync } from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const { Pool } = pg;

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false },
});

// ══ إنشاء الجداول ══
async function initDB() {
  const client = await pool.connect();
  try {
    await client.query(`
      CREATE TABLE IF NOT EXISTS questions (
        id SERIAL PRIMARY KEY,
        grade_key VARCHAR(10) NOT NULL,
        unit_index INTEGER NOT NULL,
        lesson_index INTEGER NOT NULL,
        question_text TEXT NOT NULL,
        option_a TEXT NOT NULL,
        option_b TEXT NOT NULL,
        option_c TEXT NOT NULL,
        option_d TEXT NOT NULL,
        correct_answer INTEGER NOT NULL CHECK (correct_answer >= 0 AND correct_answer <= 3),
        image_url TEXT,
        created_at TIMESTAMP DEFAULT now(),
        UNIQUE (grade_key, unit_index, lesson_index, question_text)
      );
      CREATE TABLE IF NOT EXISTS lesson_content (
        id SERIAL PRIMARY KEY,
        grade_key VARCHAR(10) NOT NULL,
        unit_index INTEGER NOT NULL,
        lesson_index INTEGER NOT NULL,
        content TEXT NOT NULL,
        updated_at TIMESTAMP DEFAULT now(),
        UNIQUE (grade_key, unit_index, lesson_index)
      );
      CREATE TABLE IF NOT EXISTS student_scores (
        id SERIAL PRIMARY KEY,
        student_name TEXT NOT NULL,
        grade_key TEXT NOT NULL,
        unit_index INTEGER NOT NULL,
        lesson_index INTEGER NOT NULL,
        score INTEGER NOT NULL,
        total INTEGER NOT NULL,
        created_at TIMESTAMP DEFAULT now(),
        UNIQUE (student_name, grade_key, unit_index, lesson_index)
      );
      CREATE TABLE IF NOT EXISTS session (
        sid VARCHAR NOT NULL PRIMARY KEY,
        sess JSON NOT NULL,
        expire TIMESTAMP(6) NOT NULL
      );
      CREATE INDEX IF NOT EXISTS idx_session_expire ON session (expire);
    `);
    console.log("✅ DB ready");
  } finally {
    client.release();
  }
}

// ══ Session Store ══
class PgStore extends session.Store {
  async get(sid, cb) {
    try {
      const r = await pool.query("SELECT sess FROM session WHERE sid=$1 AND expire>NOW()",[sid]);
      cb(null, r.rows[0]?.sess || null);
    } catch(e){cb(e);}
  }
  async set(sid, sess, cb) {
    try {
      const exp = new Date(Date.now()+(sess.cookie?.maxAge||604800000));
      await pool.query(`INSERT INTO session(sid,sess,expire) VALUES($1,$2,$3) ON CONFLICT(sid) DO UPDATE SET sess=$2,expire=$3`,[sid,JSON.stringify(sess),exp]);
      cb(null);
    } catch(e){cb(e);}
  }
  async destroy(sid, cb) {
    try { await pool.query("DELETE FROM session WHERE sid=$1",[sid]); cb(null); } catch(e){cb(e);}
  }
}

const ADMIN_USER = process.env.ADMIN_USERNAME || "admin";
const ADMIN_PASS = process.env.ADMIN_PASSWORD || "nour2024";

function requireAdmin(req,res,next) {
  if (req.session?.isAdmin) return next();
  res.status(401).json({error:"غير مصرح"});
}

async function start() {
  await initDB();
  const app = express();
  app.set("trust proxy",1);
  app.use(cors({origin:true,credentials:true}));
  app.use(express.json({limit:"15mb"}));
  app.use(express.urlencoded({extended:true,limit:"15mb"}));
  app.use(session({
    store: new PgStore(),
    name:"nour.sid",
    secret: process.env.SESSION_SECRET||"nour-edu-2024",
    resave:false, saveUninitialized:false, rolling:true,
    cookie:{httpOnly:true,maxAge:604800000,sameSite:"lax",secure:false}
  }));

  // ── Health ──
  app.get("/api/health",(_,res)=>res.json({status:"ok"}));

  // ── Auth ──
  app.post("/api/auth/login",(req,res)=>{
    if(req.body.username===ADMIN_USER && req.body.password===ADMIN_PASS){
      req.session.isAdmin=true;
      req.session.save(err=>err?res.status(500).json({error:"session error"}):res.json({success:true}));
    } else res.status(401).json({error:"بيانات خاطئة"});
  });
  app.post("/api/auth/logout",(req,res)=>{
    req.session.destroy(()=>{res.clearCookie("nour.sid");res.json({success:true});});
  });
  app.get("/api/auth/me",(req,res)=>res.json({isAdmin:!!req.session?.isAdmin}));

  // ── Questions ──
  app.get("/api/questions/counts",async(req,res)=>{
    try {
      const {gradeKey}=req.query;
      if(!gradeKey)return res.status(400).json({error:"gradeKey required"});
      const r=await pool.query(
        `SELECT unit_index,lesson_index,COUNT(*)::int AS count FROM questions WHERE grade_key=$1 GROUP BY unit_index,lesson_index`,
        [gradeKey]
      );
      const counts={};
      r.rows.forEach(row=>counts[`${row.unit_index}|${row.lesson_index}`]=row.count);
      res.json(counts);
    }catch(e){res.status(500).json({error:String(e)});}
  });

  app.get("/api/questions",async(req,res)=>{
    try {
      const {gradeKey,unitIndex,lessonIndex}=req.query;
      const conds=[], params=[];
      if(gradeKey){conds.push(`grade_key=$${params.length+1}`);params.push(gradeKey);}
      if(unitIndex!==undefined){conds.push(`unit_index=$${params.length+1}`);params.push(Number(unitIndex));}
      if(lessonIndex!==undefined){conds.push(`lesson_index=$${params.length+1}`);params.push(Number(lessonIndex));}
      const q=`SELECT * FROM questions${conds.length?" WHERE "+conds.join(" AND "):""} ORDER BY id ASC`;
      res.json((await pool.query(q,params)).rows);
    }catch(e){res.status(500).json({error:String(e)});}
  });

  // اختبار شامل - سؤال عشوائي من كل درس
  app.get("/api/questions/comprehensive",async(req,res)=>{
    try {
      const {gradeKey}=req.query;
      if(!gradeKey)return res.status(400).json({error:"gradeKey required"});
      const r=await pool.query(
        `SELECT DISTINCT ON (unit_index,lesson_index) id,grade_key,unit_index,lesson_index,
          question_text,option_a,option_b,option_c,option_d,correct_answer,image_url
         FROM questions WHERE grade_key=$1 ORDER BY unit_index,lesson_index,RANDOM()`,
        [gradeKey]
      );
      res.json(r.rows);
    }catch(e){res.status(500).json({error:String(e)});}
  });

  app.post("/api/questions",requireAdmin,async(req,res)=>{
    try {
      const{grade_key,unit_index,lesson_index,question_text,option_a,option_b,option_c,option_d,correct_answer,image_url}=req.body;
      if(!grade_key||unit_index==null||lesson_index==null||!question_text||!option_a||!option_b||!option_c||!option_d||correct_answer==null)
        return res.status(400).json({error:"بيانات ناقصة"});
      const r=await pool.query(
        `INSERT INTO questions(grade_key,unit_index,lesson_index,question_text,option_a,option_b,option_c,option_d,correct_answer,image_url)
         VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10) ON CONFLICT DO NOTHING RETURNING *`,
        [grade_key,Number(unit_index),Number(lesson_index),question_text,option_a,option_b,option_c,option_d,Number(correct_answer),image_url||null]
      );
      if(!r.rows.length)return res.status(409).json({error:"السؤال موجود مسبقاً"});
      res.status(201).json(r.rows[0]);
    }catch(e){res.status(500).json({error:String(e)});}
  });

  app.put("/api/questions/:id",requireAdmin,async(req,res)=>{
    try {
      const{question_text,option_a,option_b,option_c,option_d,correct_answer,image_url}=req.body;
      const r=await pool.query(
        `UPDATE questions SET question_text=$1,option_a=$2,option_b=$3,option_c=$4,option_d=$5,correct_answer=$6,image_url=$7 WHERE id=$8 RETURNING *`,
        [question_text,option_a,option_b,option_c,option_d,Number(correct_answer),image_url||null,req.params.id]
      );
      if(!r.rows.length)return res.status(404).json({error:"غير موجود"});
      res.json(r.rows[0]);
    }catch(e){res.status(500).json({error:String(e)});}
  });

  app.delete("/api/questions/:id",requireAdmin,async(req,res)=>{
    try {
      const r=await pool.query("DELETE FROM questions WHERE id=$1 RETURNING id",[req.params.id]);
      if(!r.rows.length)return res.status(404).json({error:"غير موجود"});
      res.json({success:true});
    }catch(e){res.status(500).json({error:String(e)});}
  });

  app.post("/api/questions/bulk",requireAdmin,async(req,res)=>{
    try {
      const{grade_key,unit_index,lesson_index,questions}=req.body;
      if(!grade_key||unit_index==null||lesson_index==null||!Array.isArray(questions)||!questions.length)
        return res.status(400).json({error:"بيانات ناقصة"});
      let inserted=0,skipped=0;
      const errors=[];
      for(let i=0;i<questions.length;i++){
        const q=questions[i];
        if(!q.question_text||!q.option_a||!q.option_b||!q.option_c||!q.option_d||q.correct_answer==null){
          errors.push({row:i+2,error:"بيانات ناقصة"});continue;
        }
        try {
          const r=await pool.query(
            `INSERT INTO questions(grade_key,unit_index,lesson_index,question_text,option_a,option_b,option_c,option_d,correct_answer)
             VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9) ON CONFLICT DO NOTHING`,
            [grade_key,Number(unit_index),Number(lesson_index),q.question_text,q.option_a,q.option_b,q.option_c,q.option_d,Number(q.correct_answer)]
          );
          r.rowCount>0?inserted++:skipped++;
        }catch(err){errors.push({row:i+2,error:String(err)});}
      }
      res.json({inserted,skipped,errors});
    }catch(e){res.status(500).json({error:String(e)});}
  });

  // ── Scores ──
  app.post("/api/scores",async(req,res)=>{
    try {
      const{studentName,gradeKey,unitIndex,lessonIndex,score,total}=req.body;
      if(!studentName||!gradeKey||unitIndex==null||lessonIndex==null||score==null||total==null)
        return res.status(400).json({error:"بيانات ناقصة"});
      const name=String(studentName).trim().slice(0,100);
      if(!name)return res.status(400).json({error:"اسم غير صالح"});
      const safeScore=Math.min(Math.max(0,Number(score)),Number(total));
      await pool.query(
        `INSERT INTO student_scores(student_name,grade_key,unit_index,lesson_index,score,total)
         VALUES($1,$2,$3,$4,$5,$6) ON CONFLICT(student_name,grade_key,unit_index,lesson_index)
         DO UPDATE SET score=GREATEST(student_scores.score,LEAST(EXCLUDED.score,EXCLUDED.total)),total=EXCLUDED.total,created_at=NOW()`,
        [name,gradeKey,Number(unitIndex),Number(lessonIndex),safeScore,Number(total)]
      );
      res.json({success:true});
    }catch(e){res.status(500).json({error:String(e)});}
  });

  app.get("/api/scores/leaderboard",async(req,res)=>{
    try {
      const{gradeKey}=req.query;
      if(!gradeKey)return res.status(400).json({error:"gradeKey مطلوب"});
      const r=await pool.query(
        `SELECT student_name,
           SUM(LEAST(score,total)) AS total_score,
           SUM(total) AS total_possible,
           COUNT(*) AS lessons_count,
           LEAST(ROUND(SUM(LEAST(score,total))::numeric/NULLIF(SUM(total),0)*100,1),100) AS pct
         FROM student_scores WHERE grade_key=$1
         GROUP BY student_name ORDER BY total_score DESC,pct DESC LIMIT 10`,
        [gradeKey]
      );
      res.json(r.rows);
    }catch(e){res.status(500).json({error:String(e)});}
  });

  app.delete("/api/scores/student",requireAdmin,async(req,res)=>{
    try {
      const{gradeKey,studentName}=req.query;
      if(!gradeKey||!studentName)return res.status(400).json({error:"بيانات ناقصة"});
      await pool.query("DELETE FROM student_scores WHERE grade_key=$1 AND student_name=$2",[gradeKey,studentName]);
      res.json({success:true});
    }catch(e){res.status(500).json({error:String(e)});}
  });

  app.delete("/api/scores",requireAdmin,async(req,res)=>{
    try {
      const{gradeKey}=req.query;
      if(!gradeKey)return res.status(400).json({error:"gradeKey مطلوب"});
      await pool.query("DELETE FROM student_scores WHERE grade_key=$1",[gradeKey]);
      res.json({success:true});
    }catch(e){res.status(500).json({error:String(e)});}
  });

  // ── Lessons Content ──
  app.get("/api/lessons/content",async(req,res)=>{
    try {
      const{gradeKey,unitIndex,lessonIndex}=req.query;
      const r=await pool.query(
        "SELECT content,updated_at FROM lesson_content WHERE grade_key=$1 AND unit_index=$2 AND lesson_index=$3",
        [gradeKey,Number(unitIndex),Number(lessonIndex)]
      );
      res.json(r.rows.length?{content:r.rows[0].content,updated_at:r.rows[0].updated_at}:{content:null});
    }catch(e){res.status(500).json({error:String(e)});}
  });

  app.put("/api/lessons/content",requireAdmin,async(req,res)=>{
    try {
      const{grade_key,unit_index,lesson_index,content}=req.body;
      if(!grade_key||unit_index==null||lesson_index==null||!content)
        return res.status(400).json({error:"بيانات ناقصة"});
      await pool.query(
        `INSERT INTO lesson_content(grade_key,unit_index,lesson_index,content) VALUES($1,$2,$3,$4)
         ON CONFLICT(grade_key,unit_index,lesson_index) DO UPDATE SET content=$4,updated_at=NOW()`,
        [grade_key,Number(unit_index),Number(lesson_index),content]
      );
      res.json({success:true});
    }catch(e){res.status(500).json({error:String(e)});}
  });

  // ── Static ──
  const staticDir=path.join(__dirname,"../nour-edu/dist/public");
  if(existsSync(staticDir)){
    app.use(express.static(staticDir,{
      setHeaders:(res,fp)=>{
        if(fp.endsWith(".html")){
          res.setHeader("Cache-Control","no-store,no-cache,must-revalidate");
          res.setHeader("Pragma","no-cache");
          res.setHeader("Expires","0");
        }
      }
    }));
    app.get("*",(_,res)=>{
      res.setHeader("Cache-Control","no-store,no-cache,must-revalidate");
      res.sendFile(path.join(staticDir,"index.html"));
    });
  }

  const port=Number(process.env.PORT)||3000;
  app.listen(port,()=>console.log(`🚀 Server on port ${port}`));
}

start().catch(e=>{console.error("Fatal:",e);process.exit(1);});
