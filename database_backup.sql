--
-- PostgreSQL database dump
--

\restrict ghVJbVeVjzZ3dmwwwFJkixJqLUIlktvhz0yt2aEh73QHKqR6fxl0Y1Rqy9alwbE

-- Dumped from database version 16.10
-- Dumped by pg_dump version 16.10

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: lesson_content; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lesson_content (
    id integer NOT NULL,
    grade_key character varying(20) NOT NULL,
    unit_index integer NOT NULL,
    lesson_index integer NOT NULL,
    content text NOT NULL,
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: lesson_content_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.lesson_content_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lesson_content_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.lesson_content_id_seq OWNED BY public.lesson_content.id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.questions (
    id integer NOT NULL,
    grade_key character varying(10) NOT NULL,
    unit_index integer NOT NULL,
    lesson_index integer NOT NULL,
    question_text text NOT NULL,
    option_a text NOT NULL,
    option_b text NOT NULL,
    option_c text NOT NULL,
    option_d text NOT NULL,
    correct_answer integer NOT NULL,
    image_url text,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.questions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.questions_id_seq OWNED BY public.questions.id;


--
-- Name: session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.session (
    sid character varying NOT NULL,
    sess json NOT NULL,
    expire timestamp(6) without time zone NOT NULL
);


--
-- Name: student_scores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.student_scores (
    id integer NOT NULL,
    student_name text NOT NULL,
    grade_key text NOT NULL,
    unit_index integer NOT NULL,
    lesson_index integer NOT NULL,
    score integer NOT NULL,
    total integer NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: student_scores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.student_scores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: student_scores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.student_scores_id_seq OWNED BY public.student_scores.id;


--
-- Name: lesson_content id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lesson_content ALTER COLUMN id SET DEFAULT nextval('public.lesson_content_id_seq'::regclass);


--
-- Name: questions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions ALTER COLUMN id SET DEFAULT nextval('public.questions_id_seq'::regclass);


--
-- Name: student_scores id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_scores ALTER COLUMN id SET DEFAULT nextval('public.student_scores_id_seq'::regclass);


--
-- Data for Name: lesson_content; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.lesson_content (id, grade_key, unit_index, lesson_index, content, updated_at) FROM stdin;
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.questions (id, grade_key, unit_index, lesson_index, question_text, option_a, option_b, option_c, option_d, correct_answer, image_url, created_at) FROM stdin;
494	first	0	0	ما قيمة 2⁵؟	10	25	32	7	2	\N	2026-04-15 18:55:04.5698
495	first	0	0	ما قيمة 3³؟	9	27	12	6	1	\N	2026-04-15 18:55:04.808887
496	first	0	0	ما قيمة 5⁰؟	0	1	5	لا يمكن	1	\N	2026-04-15 18:55:04.812156
497	first	0	0	4² + 2³ = ؟	12	16	24	32	2	\N	2026-04-15 18:55:04.814837
498	first	0	0	ما قيمة 10²؟	20	100	110	1000	1	\N	2026-04-15 18:55:04.820404
499	first	0	1	(2 + 3) × 4 = ؟	14	20	11	9	1	\N	2026-04-15 18:55:04.824494
500	first	0	1	10 - 3 + 2 = ؟	5	9	15	7	1	\N	2026-04-15 18:55:04.826786
501	first	0	1	20 ÷ 4 × 2 = ؟	2.5	10	2	40	1	\N	2026-04-15 18:55:04.830125
502	first	0	1	15 - 6 ÷ 2 = ؟	4.5	9	12	18	2	\N	2026-04-15 18:55:04.833102
503	first	0	1	24 ÷ 6 + 2 = ؟	2	4	6	8	2	\N	2026-04-15 18:55:04.835895
504	first	0	1	3 × 4 - 2 = ؟	5	10	12	14	1	\N	2026-04-15 18:55:04.83888
505	first	0	1	2 + 2² × 2 = ؟	6	8	10	12	2	\N	2026-04-15 18:55:04.841472
506	first	0	1	100 - 50 ÷ 5 = ؟	90	95	100	10	1	\N	2026-04-15 18:55:04.844556
507	first	0	1	(10 + 5) × 2 - 10 = ؟	20	25	30	35	2	\N	2026-04-15 18:55:04.848105
508	first	0	1	6 × 2 + 3 × 2 = ؟	12	15	18	21	2	\N	2026-04-15 18:55:04.851038
509	first	0	2	ما القيمة المطلقة لـ -7؟	-7	7	0	14	1	\N	2026-04-15 18:55:04.928761
510	first	0	2	|-10| + |3| = ؟	7	-7	13	-13	2	\N	2026-04-15 18:55:04.932169
511	first	0	2	|x| = 8 فما قيمة x؟	8 فقط	-8 فقط	8 أو -8	0	2	\N	2026-04-15 18:55:04.934339
512	first	0	2	|-3| - |2| = ؟	5	1	-1	0	1	\N	2026-04-15 18:55:04.936862
513	first	0	3	(-5) + (-3) = ؟	8	-8	2	-2	1	\N	2026-04-15 18:55:04.938857
514	first	0	3	(-3) × 4 = ؟	12	-12	1	-1	1	\N	2026-04-15 18:55:04.941346
515	first	0	3	(-12) ÷ (-3) = ؟	-4	4	-36	-0.25	1	\N	2026-04-15 18:55:04.943759
516	first	0	4	ما الكسر الاعتيادي للعدد 0.75؟	1/4	3/4	1/2	2/5	1	\N	2026-04-15 18:55:04.94582
517	first	0	4	1/3 تقريباً يساوي:	0.25	0.33	0.5	0.75	1	\N	2026-04-15 18:55:04.947798
518	first	0	5	إذا كانت 3/5 = x/10، فما x؟	5	6	8	9	1	\N	2026-04-15 18:55:04.950529
519	first	0	5	النسبة 1:2 تعني:	1 من 2	1 لـ 2	جزء من كل	كل ما سبق	3	\N	2026-04-15 18:55:04.952588
520	first	0	6	50% من 200 = ؟	50	100	150	200	1	\N	2026-04-15 18:55:04.95509
521	first	1	0	كم عدد الحدود في 3س + 5؟	1	2	3	4	1	\N	2026-04-15 18:55:04.956956
522	first	1	0	قيمة 2س + 3 عند س = 5:	10	13	15	8	1	\N	2026-04-15 18:55:04.95933
523	first	1	0	الحد الثابت في 4ص + 9:	4	9	ص	لا يوجد	1	\N	2026-04-15 18:55:04.96128
524	first	1	0	اكتب تعبير: مضاعف العدد زائد 5:	2 + س + 5	2س + 5	s + 5	x/2 + 5	1	\N	2026-04-15 18:55:04.963249
525	first	1	1	الخاصية التجميعية تتعلق بـ:	ترتيب	تجميع	توزيع	محايد	1	\N	2026-04-15 18:55:04.965046
526	first	1	1	3(2+5) = ؟	6+5	6+15	3+15	21	1	\N	2026-04-15 18:55:04.967782
527	first	1	1	أي من الخصائص: 4 + 0 = 4	إبدالية	محايد جمعي	توزيع	تجميع	1	\N	2026-04-15 18:55:04.970762
528	first	1	1	2 × (3 + 4) = 2×3 + 2×4 هي:	إبدالية	تجميعية	توزيعية	محايد	2	\N	2026-04-15 18:55:04.972782
529	first	1	2	حل: 2س - 5 = 11	3	8	16	لا حل	1	\N	2026-04-15 18:55:04.975104
530	first	1	2	حل: س/2 = 6	3	12	8	4	1	\N	2026-04-15 18:55:04.978329
531	first	1	3	إذا f(x) = 2x + 1، فما f(3)؟	5	6	7	8	2	\N	2026-04-15 18:55:04.980914
532	first	1	3	أي علاقة دالة؟	{(1,2)(1,3)}	{(1,2)(2,3)}	{(1,1)(1,2)}	لا شيء	1	\N	2026-04-15 18:55:04.982822
533	first	1	3	إذا g(x) = x²، فما g(4)؟	8	16	12	2	1	\N	2026-04-15 18:55:04.985166
534	first	1	3	المجال هو:	المخرجات	المدخلات	النسبة	لا شيء	1	\N	2026-04-15 18:55:04.988022
535	first	1	3	إذا h(x) = 3x - 2، فما h(0)؟	3	-2	2	1	1	\N	2026-04-15 18:55:04.990155
536	first	1	4	الفرق في المتتابعة 3, 6, 9, 12:	2	3	4	6	1	\N	2026-04-15 18:55:04.992633
537	first	1	4	هل 2, 4, 8, 16 متتابعة حسابية؟	نعم	لا	ربما	غير واضح	1	\N	2026-04-15 18:55:04.996102
538	first	2	0	زاويتان متكاملتان، الأولى 60°، الثانية:	30°	120°	90°	60°	1	\N	2026-04-15 18:55:04.998381
539	first	2	0	مجموع الزوايا المتكاملة:	90°	180°	360°	270°	1	\N	2026-04-15 18:55:05.00039
540	first	2	1	مثلث جميع أضلاعه متساوية هو:	حاد	متساوي الأضلاع	قائم	منفرج	1	\N	2026-04-15 18:55:05.003072
541	first	2	1	مجموع زوايا أي مثلث:	90°	180°	270°	360°	1	\N	2026-04-15 18:55:05.006355
542	first	2	1	مثلث قائم الزاوية إحدى زواياه:	45°	90°	60°	30°	1	\N	2026-04-15 18:55:05.009745
543	first	2	1	مثلث متساوي الساقين له:	3 أضلاع متساوية	ساقان متساويان	أضلاع مختلفة	لا شيء	1	\N	2026-04-15 18:55:05.01189
544	first	2	2	مجموع زوايا الشكل الرباعي:	180°	270°	360°	90°	2	\N	2026-04-15 18:55:05.014441
545	first	2	2	المعين جميع أضلاعه:	مختلفة	متساوية	متقابلة	متعامدة	1	\N	2026-04-15 18:55:05.019068
546	first	2	2	متوازي الأضلاع فيه:	زوايا قائمة	أضلاع متقابلة متساوية	أضلاع متساوية	قطران متساويان	1	\N	2026-04-15 18:55:05.02143
547	first	2	3	محيط مربع ضلعه 5 سم:	10	15	20	25	2	\N	2026-04-15 18:55:05.023655
548	first	2	3	مساحة مربع ضلعه 4 سم:	8	16	32	64	1	\N	2026-04-15 18:55:05.025957
549	first	2	3	مساحة مستطيل طوله 6 وعرضه 4:	10	20	24	16	2	\N	2026-04-15 18:55:05.028491
550	first	2	3	محيط مستطيل طوله 8 وعرضه 3:	11	22	24	32	1	\N	2026-04-15 18:55:05.031641
551	first	2	4	5 كم = ؟ م	50	500	5000	50000	2	\N	2026-04-15 18:55:05.033775
552	first	2	4	3 م = ؟ سم	30	300	3	0.3	1	\N	2026-04-15 18:55:05.035845
553	first	2	4	250 سم = ؟ م	0.25	2.5	25	250	1	\N	2026-04-15 18:55:05.03873
554	first	2	4	1000 ملم = ؟ م	0.1	0.01	1	10	2	\N	2026-04-15 18:55:05.040878
555	first	2	4	2.5 كم = ؟ سم	250	2500	25000	250000	2	\N	2026-04-15 18:55:05.043292
556	first	2	5	المكعب له ؟ وجه	4	5	6	8	2	\N	2026-04-15 18:55:05.046809
557	first	2	5	متوازي المستطيلات له ؟ رأس	6	8	12	4	1	\N	2026-04-15 18:55:05.049379
558	first	2	5	عدد أحرف المكعب:	6	8	12	14	2	\N	2026-04-15 18:55:05.051844
559	first	2	5	حجم المكعب = ؟	الضلع²	الضلع³	4 × الضلع	6 × الضلع²	1	\N	2026-04-15 18:55:05.054643
560	first	3	0	الوسط الحسابي لـ 2, 4, 6, 8, 10:	4	6	8	10	1	\N	2026-04-15 18:55:05.058223
561	first	3	0	وسيط 1, 3, 5, 7, 9:	3	5	7	9	1	\N	2026-04-15 18:55:05.060894
562	first	3	0	المنوال لـ 1, 2, 2, 3, 3, 3:	1	2	3	2.5	2	\N	2026-04-15 18:55:05.063826
563	first	3	0	الوسط الحسابي 5, 5, 5, 5:	4	5	6	20	1	\N	2026-04-15 18:55:05.065973
564	first	3	0	وسيط 2, 4, 6, 8:	4	5	6	7	1	\N	2026-04-15 18:55:05.068758
565	first	3	1	أفضل طريقة لتمثيل النسب:	أعمدة	خطوط	قطاعات	جداول	2	\N	2026-04-15 18:55:05.071203
566	first	3	1	الخطوط البيانية تستخدم لـ:	النسب	التغير بمرور الوقت	التكرار	المتوسط	1	\N	2026-04-15 18:55:05.074005
567	first	3	1	المدرجات التكرارية تظهر:	النسب	التغير	التكرار	الاتجاه	2	\N	2026-04-15 18:55:05.076215
568	first	3	1	رسم بياني يظهر تطور الأسعار عبر الأسابيع:	أعمدة	خطوط	قطاعات	مدرج	1	\N	2026-04-15 18:55:05.079409
569	first	3	2	احتمال عدد فردي عند رمي نرد:	1/6	2/6	3/6	4/6	2	\N	2026-04-15 18:55:05.081817
570	first	3	2	احتمال صورة في رمية عملة:	0	1/4	1/2	1	2	\N	2026-04-15 18:55:05.084418
571	first	3	2	احتمال الرقم 5 في نرد:	0	1/6	1/3	1/2	1	\N	2026-04-15 18:55:05.08684
572	first	3	2	احتمال حدث مستحيل:	1/2	1/4	0	1	2	\N	2026-04-15 18:55:05.089648
573	first	3	2	احتمال الحدث المؤكد:	0	1/2	1/4	1	3	\N	2026-04-15 18:55:05.091656
574	first	3	3	فضاء العينة لرمي عملتين:	2	4	6	8	1	\N	2026-04-15 18:55:05.093847
575	first	3	3	عدد النواتج الممكنة لرمي 3 عملات:	6	8	12	16	1	\N	2026-04-15 18:55:05.09652
576	first	3	3	الرسم الشجري يستخدم لـ:	الرسم	إيجاد النواتج	الحساب	التحليل	1	\N	2026-04-15 18:55:05.099077
577	first	3	3	عدد النواتج لرمي نرد واختيار لون من 3 ألوان:	6	9	18	36	2	\N	2026-04-15 18:55:05.102043
578	second	0	0	أي الأعداد التالية أكبر؟	-8	-3	-10	-15	1	\N	2026-04-15 18:55:05.104429
579	second	0	0	أي الأعداد نسبي؟	π	√2	5/3	لا شيء	2	\N	2026-04-15 18:55:05.107005
580	second	0	0	العدد 3/4 = ؟	0.5	0.75	0.25	0.3	1	\N	2026-04-15 18:55:05.111227
581	second	0	1	(2²)³ = ؟	2⁵	2⁶	8³	64	1	\N	2026-04-15 18:55:05.113223
582	second	0	1	5⁰ = ؟	0	1	5	غير معرّف	1	\N	2026-04-15 18:55:05.115116
583	second	0	1	(-2)⁴ = ؟	-16	16	8	-8	1	\N	2026-04-15 18:55:05.117346
584	second	0	1	10⁵ = ؟	50000	100000	500000	1000000	1	\N	2026-04-15 18:55:05.12003
585	second	0	1	(3²)² = ؟	3⁴	3⁶	81	كلا من أ وب	2	\N	2026-04-15 18:55:05.122492
586	second	0	1	4² = ؟	8	16	12	2	1	\N	2026-04-15 18:55:05.12507
587	second	0	1	6⁰ = ؟	0	1	6	غير محدد	1	\N	2026-04-15 18:55:05.127458
588	second	0	1	(5²)⁰ = ؟	0	1	25	50	1	\N	2026-04-15 18:55:05.130128
589	second	0	2	√144 = ؟	11	12	13	14	1	\N	2026-04-15 18:55:05.132547
590	second	0	2	√81 = ؟	8	9	10	11	1	\N	2026-04-15 18:55:05.134585
591	second	0	2	√169 = ؟	11	12	13	14	2	\N	2026-04-15 18:55:05.136639
592	second	0	2	ما √100؟	5	10	50	100	1	\N	2026-04-15 18:55:05.139522
593	second	0	2	√36 + √64 = ؟	10	12	14	100	2	\N	2026-04-15 18:55:05.141604
594	second	0	3	π عدد:	نسبي	غير نسبي	صحيح	طبيعي	1	\N	2026-04-15 18:55:05.144048
595	second	0	3	مجموعة الأعداد الحقيقية تشمل:	النسبية فقط	غير النسبية فقط	كليهما	لا شيء	2	\N	2026-04-15 18:55:05.147055
596	second	0	3	√2 عدد:	صحيح	نسبي	غير نسبي	طبيعي	2	\N	2026-04-15 18:55:05.149967
597	second	0	3	أي من الأعداد التالية عدد حقيقي؟	∞	غير معرّف	√9	جميع السابق	2	\N	2026-04-15 18:55:05.151925
598	second	0	3	√4 عدد:	غير نسبي	نسبي	غير حقيقي	وهمي	1	\N	2026-04-15 18:55:05.15465
599	second	0	3	أي من التالي غير نسبي؟	1/3	0.5	√3	2	2	\N	2026-04-15 18:55:05.157096
600	second	0	3	ما النظير الضربي للعدد -2/5؟	2/5	-5/2	-2/5	5/2	1	\N	2026-04-15 18:55:05.160343
601	second	0	3	الأعداد الحقيقية تشمل:	الموجبة فقط	السالبة فقط	الموجبة والسالبة والصفر	الموجبة والسالبة فقط	2	\N	2026-04-15 18:55:05.162663
602	second	0	3	أي من الأعداد التالية حقيقي؟	π	√2	5/3	جميع ما سبق	3	\N	2026-04-15 18:55:05.164476
603	second	0	4	ما 40% من 50؟	10	15	20	25	2	\N	2026-04-15 18:55:05.166468
604	second	0	4	إذا 25 من 100، النسبة المئوية:	20%	25%	50%	75%	1	\N	2026-04-15 18:55:05.168879
605	second	0	4	ما العدد الذي 20% منه = 10؟	30	40	50	60	2	\N	2026-04-15 18:55:05.170996
606	second	0	4	150% من 80 = ؟	100	110	120	130	2	\N	2026-04-15 18:55:05.173318
607	second	0	4	حذاء سعره الأصلي 80 ريالاً، ارتفع سعره بنسبة 25%، فكم أصبح سعره الجديد؟	85	95	100	105	2	\N	2026-04-15 18:55:05.175531
608	second	0	4	ما 10% من 200؟	10	20	30	50	1	\N	2026-04-15 18:55:05.178178
609	second	0	4	إذا السعر 500 ريال وخصم 15%، السعر النهائي:	85	315	425	515	2	\N	2026-04-15 18:55:05.180611
610	second	1	0	متباينة تمثل: عدد أقل من 10	x > 10	x < 10	x = 10	x ≥ 10	1	\N	2026-04-15 18:55:05.183593
611	second	1	0	عند ضرب/قسمة متباينة بسالب:	لا يتغير	ينقلب الرمز	تصبح معادلة	تلغى	1	\N	2026-04-15 18:55:05.187486
612	second	1	0	حل: 4س + 5 = 21	س = 3	س = 4	س = 5	س = 6	1	\N	2026-04-15 18:55:05.190442
613	second	1	0	حل: -2س < 8	س < -4	س > -4	س < 4	س > 4	1	\N	2026-04-15 18:55:05.192626
614	second	1	0	عدد مضاف إلى 5 يساوي 12:	x + 5 < 12	x + 5 > 12	x + 5 = 12	x + 5 ≥ 12	2	\N	2026-04-15 18:55:05.194754
615	second	1	1	حل: -4x ≥ 12	x ≥ -3	x ≤ -3	x ≥ 3	x ≤ 3	1	\N	2026-04-15 18:55:05.197348
616	second	1	2	ميل الدالة y = 3x + 2:	2	3	5	6	1	\N	2026-04-15 18:55:05.19996
617	second	1	2	الجزء المقطوع من y في y = -x + 5:	-1	5	-5	1	1	\N	2026-04-15 18:55:05.202335
618	second	1	2	إذا y = 2x، فما y عند x = 3؟	5	6	8	9	1	\N	2026-04-15 18:55:05.204671
619	second	1	2	الدالة y = 4 هي:	خطية	تربيعية	ثابتة	أسية	2	\N	2026-04-15 18:55:05.207433
620	second	1	2	ميل خط أفقي:	1	0	غير معرّف	-1	1	\N	2026-04-15 18:55:05.209351
621	second	1	3	نقطة تقاطع خطين هي:	الميل	الحل	المقطع	القمة	1	\N	2026-04-15 18:55:05.212235
622	second	1	3	خطان متوازيان لهما:	حل واحد	لا حل	حلول لانهائية	حلان	1	\N	2026-04-15 18:55:05.214456
623	second	1	3	نظام له حلول لانهائية عندما:	الخطان متقاطعان	الخطان متطابقان	الخطان متوازيان	لا شيء	1	\N	2026-04-15 18:55:05.217341
624	second	1	4	درجة كثيرة الحدود 3x⁴ + 2x - 1:	1	2	3	4	3	\N	2026-04-15 18:55:05.219682
625	second	1	4	2(3x + 1) = ؟	6x + 1	6x + 2	5x + 2	3x + 2	1	\N	2026-04-15 18:55:05.222264
626	second	1	4	عدد حدود 5x³ - 2x + 7:	1	2	3	4	2	\N	2026-04-15 18:55:05.224916
627	second	2	0	إذا أ=5، ج=13، ب=؟	8	12	18	10	1	\N	2026-04-15 18:55:05.227645
628	second	2	0	الوتر هو:	أقصر ضلع	أطول ضلع	أي ضلع	القاعدة	1	\N	2026-04-15 18:55:05.230594
629	second	2	1	الانسحاب يغير:	الحجم	الشكل	الموقع	الزوايا	2	\N	2026-04-15 18:55:05.232706
630	second	2	1	دوران 180° يعادل:	انسحاب	انعكاس	تمدد	تصغير	1	\N	2026-04-15 18:55:05.23568
631	second	2	1	التمدد بمعامل 2 يجعل الشكل:	أصغر	أكبر	نفسه	مقلوب	1	\N	2026-04-15 18:55:05.237701
632	second	2	2	شكلان متطابقان لهما:	نفس الشكل فقط	نفس الحجم فقط	نفس الشكل والحجم	لا شيء	2	\N	2026-04-15 18:55:05.23999
633	second	2	2	مثلثان متشابهان زواياهما:	مختلفة	متساوية	متكاملة	متتامة	1	\N	2026-04-15 18:55:05.242053
634	second	2	2	نسبة التشابه 1:2 تعني:	نفس الحجم	الثاني ضعف الأول	الأول ضعف الثاني	لا علاقة	1	\N	2026-04-15 18:55:05.245331
635	second	2	2	شكلان متشابهان أضلاعهما:	متساوية	متناسبة	مختلفة	لا علاقة	1	\N	2026-04-15 18:55:05.24765
636	second	2	2	كل الدوائر:	متطابقة	متشابهة	مختلفة	لا علاقة	1	\N	2026-04-15 18:55:05.249965
637	second	2	3	حجم منشور مساحة قاعدته 20 وارتفاعه 5:	25	100	200	400	1	\N	2026-04-15 18:55:05.25274
638	second	2	3	وحدة قياس الحجم:	سم	سم²	سم³	سم⁴	2	\N	2026-04-15 18:55:05.256022
639	second	2	3	حجم مكعب ضلعه 3 سم:	9	18	27	36	2	\N	2026-04-15 18:55:05.258669
640	second	2	4	مساحة سطح مكعب ضلعه 4:	64	96	24	16	1	\N	2026-04-15 18:55:05.260828
641	second	2	4	عدد أوجه المنشور الثلاثي:	3	4	5	6	2	\N	2026-04-15 18:55:05.264119
642	second	2	4	مساحة سطح أسطوانة تشمل:	قاعدتين فقط	سطح جانبي فقط	قاعدتين + سطح جانبي	لا شيء	2	\N	2026-04-15 18:55:05.266992
643	second	2	4	وحدة مساحة السطح:	سم	سم²	سم³	م	1	\N	2026-04-15 18:55:05.269158
644	second	2	4	مساحة سطح متوازي مستطيلات أبعاده 2×3×4:	24	52	48	26	1	\N	2026-04-15 18:55:05.271431
645	second	3	0	المدى لـ 3, 7, 1, 9, 5:	4	6	8	10	2	\N	2026-04-15 18:55:05.273734
646	second	3	0	إذا كانت البيانات متقاربة، الانحراف المعياري:	كبير	صغير	صفر	سالب	1	\N	2026-04-15 18:55:05.276231
647	second	3	0	الانحراف المعياري يقيس:	المركز	التشتت	النسبة	الميل	1	\N	2026-04-15 18:55:05.278432
648	second	3	0	المدى لـ 2, 5, 8, 11, 14:	9	12	3	14	1	\N	2026-04-15 18:55:05.280609
649	second	3	1	احتمال ظهور صورة مرتين في رمي عملة مرتين:	1/2	1/4	3/4	1	1	\N	2026-04-15 18:55:05.282983
650	second	3	1	رمي نرد مرتين، احتمال 6 مرتين:	1/6	1/12	1/36	2/6	2	\N	2026-04-15 18:55:05.285547
651	second	3	1	حدثان مستقلان:	يؤثران ببعض	لا يؤثران	متنافيان	متكاملان	1	\N	2026-04-15 18:55:05.288125
652	second	3	1	P(A) = 0.3, P(B) = 0.5 (مستقلان)، P(A و B):	0.8	0.15	0.2	0.35	1	\N	2026-04-15 18:55:05.290109
653	second	3	1	احتمال عدم وقوع حدث احتماله 0.7:	0.7	0.3	1	0	1	\N	2026-04-15 18:55:05.292515
654	second	3	2	الصندوق وطرفيه يظهر:	الوسط فقط	الوسيط والربيعيات	المنوال	المتوسط	1	\N	2026-04-15 18:55:05.295189
655	second	3	2	الرسم النقطي يستخدم لـ:	المقارنة	العلاقة بين متغيرين	التكرار	النسبة	1	\N	2026-04-15 18:55:05.297219
656	second	3	2	النقاط المتطرفة (outliers):	في المنتصف	بعيدة عن البقية	قريبة من الوسط	لا وجود لها	1	\N	2026-04-15 18:55:05.300657
657	second	3	3	عدد طرق ترتيب 3 أشخاص:	3	6	9	12	1	\N	2026-04-15 18:55:05.303338
658	second	3	3	4! = ؟	4	12	24	120	2	\N	2026-04-15 18:55:05.30607
659	second	3	3	C(5,2) = ؟	5	10	20	60	1	\N	2026-04-15 18:55:05.308668
660	second	3	3	عدد طرق اختيار 2 من 4 (بدون ترتيب):	4	6	8	12	1	\N	2026-04-15 18:55:05.311302
661	second	3	3	P(4,2) = ؟	6	8	12	24	2	\N	2026-04-15 18:55:05.313477
\.


--
-- Data for Name: session; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.session (sid, sess, expire) FROM stdin;
2ASJKvYPHD28ObEA5K44yQocVAVjEkc7	{"cookie":{"originalMaxAge":604800000,"expires":"2026-04-20T23:00:54.397Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"isAdmin":true}	2026-04-20 23:00:55
3LGaVESBvfA6ZbMrLB0bICbaJEOQhtgh	{"cookie":{"originalMaxAge":604800000,"expires":"2026-04-20T23:01:05.366Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"isAdmin":true}	2026-04-20 23:01:06
U8rvyLv5wIPv-v7JP4nv_6-k2LUy5sjG	{"cookie":{"originalMaxAge":604800000,"expires":"2026-04-20T23:34:29.046Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"isAdmin":true}	2026-04-20 23:34:30
SCE7wGZO0zBTgfpPijQeM-m10CksL2p3	{"cookie":{"originalMaxAge":604800000,"expires":"2026-04-20T23:38:42.831Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"isAdmin":true}	2026-04-20 23:38:44
29el-rDwjLnvgR5wh59Y1zOLMsfN9mOw	{"cookie":{"originalMaxAge":604800000,"expires":"2026-04-21T00:55:40.874Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"isAdmin":true}	2026-04-21 00:55:41
Dnx0UUDpP_jOqSD3aC2mw7zPoXhceEsG	{"cookie":{"originalMaxAge":604800000,"expires":"2026-04-20T23:39:07.887Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"isAdmin":true}	2026-04-20 23:39:08
_nm2uoYpWeFDrgVQEs1m2G7zwo1flaYQ	{"cookie":{"originalMaxAge":604800000,"expires":"2026-04-20T23:59:15.330Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"isAdmin":true}	2026-04-20 23:59:16
J3LOGte4mgPwAQbDUiMIZTC7zZGqR1uD	{"cookie":{"originalMaxAge":604800000,"expires":"2026-04-21T00:03:18.672Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"isAdmin":true}	2026-04-21 00:03:19
3PwGtlmHUeaxXHrWF9qi9Ku_KRlnWKEe	{"cookie":{"originalMaxAge":604800000,"expires":"2026-04-21T14:01:58.608Z","secure":false,"httpOnly":true,"path":"/","sameSite":"lax"},"isAdmin":true}	2026-04-25 09:10:18
\.


--
-- Data for Name: student_scores; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.student_scores (id, student_name, grade_key, unit_index, lesson_index, score, total, created_at) FROM stdin;
1	.	first	0	0	1	5	2026-04-14 09:37:01.014003
2	Test User	first	0	0	0	5	2026-04-16 03:44:56.73415
\.


--
-- Name: lesson_content_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.lesson_content_id_seq', 1, false);


--
-- Name: questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.questions_id_seq', 661, true);


--
-- Name: student_scores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.student_scores_id_seq', 3, true);


--
-- Name: lesson_content lesson_content_grade_key_unit_index_lesson_index_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lesson_content
    ADD CONSTRAINT lesson_content_grade_key_unit_index_lesson_index_key UNIQUE (grade_key, unit_index, lesson_index);


--
-- Name: lesson_content lesson_content_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lesson_content
    ADD CONSTRAINT lesson_content_pkey PRIMARY KEY (id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: questions questions_unique_text; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_unique_text UNIQUE (grade_key, unit_index, lesson_index, question_text);


--
-- Name: session session_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_pkey PRIMARY KEY (sid);


--
-- Name: student_scores student_scores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_scores
    ADD CONSTRAINT student_scores_pkey PRIMARY KEY (id);


--
-- Name: student_scores student_scores_student_name_grade_key_unit_index_lesson_ind_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_scores
    ADD CONSTRAINT student_scores_student_name_grade_key_unit_index_lesson_ind_key UNIQUE (student_name, grade_key, unit_index, lesson_index);


--
-- Name: idx_session_expire; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_session_expire ON public.session USING btree (expire);


--
-- PostgreSQL database dump complete
--

\unrestrict ghVJbVeVjzZ3dmwwwFJkixJqLUIlktvhz0yt2aEh73QHKqR6fxl0Y1Rqy9alwbE

