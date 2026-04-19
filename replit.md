# Workspace

## Overview

pnpm workspace monorepo using TypeScript. Each package manages its own dependencies.

## Stack

- **Monorepo tool**: pnpm workspaces
- **Node.js version**: 24
- **Package manager**: pnpm
- **TypeScript version**: 5.9
- **API framework**: Express 5
- **Database**: PostgreSQL + Drizzle ORM
- **Validation**: Zod (`zod/v4`), `drizzle-zod`
- **API codegen**: Orval (from OpenAPI spec)
- **Build**: esbuild (CJS bundle)

## Artifacts

### منصة نور التعليمية (nour-edu)
- **Type**: Static HTML site served via Vite
- **Path**: `/` (root)
- **Description**: Interactive educational platform for middle school math (Grades 1 & 2 intermediate). Features curriculum browsing, lesson content, and interactive quizzes.
- **Tech**: Plain HTML + Tailwind CSS (CDN) + Lucide icons + vanilla JavaScript
- **Data**: Hardcoded curriculum data in HTML + additional DB-stored questions fetched from API at quiz time
- **Admin Panel**: `/admin.html` - No-code question manager (add/edit/delete questions, image support)

### API Server (api-server)
- **Path**: `/api`
- **Database**: PostgreSQL (`questions` table)
- **Questions API**: GET/POST `/api/questions`, PUT/DELETE `/api/questions/:id`
- **Schema**: grade_key, unit_index, lesson_index, question_text, option_a-d, correct_answer, image_url

## Key Commands

- `pnpm run typecheck` — full typecheck across all packages
- `pnpm run build` — typecheck + build all packages
- `pnpm --filter @workspace/api-spec run codegen` — regenerate API hooks and Zod schemas from OpenAPI spec
- `pnpm --filter @workspace/db run push` — push DB schema changes (dev only)
- `pnpm --filter @workspace/api-server run dev` — run API server locally

See the `pnpm-workspace` skill for workspace structure, TypeScript setup, and package details.
