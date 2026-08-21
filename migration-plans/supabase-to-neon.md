# Supabase → Neon Migration Plan

**Status:** On Hold — Awaiting Decision  
**Created:** 2026-08-20  
**Context:** Supabase free tier pauses after 7 days of inactivity, requiring $24/month to keep always-on. Neon free tier does not pause (scales to zero after 5 min, wakes in ~500ms).

---

## Current Setup

### Database Schema (from `supabase/schema.sql`)
- **campaigns** — campaign state (fear counter, scene, tokens, shop)
- **players** — character data synced across devices
- **items** — shop items
- **character_updates** — pending GM approvals
- **gold_rewards** — GM-to-player gold transfers
- Uses **RLS** (open access for dev) and **Realtime** for live sync

### Features Used
- Supabase Auth: ❌ No (open access)
- Supabase Storage: ❌ No (just database)
- Supabase Realtime: ✅ Yes (live sync across devices)
- Row Level Security: ✅ Yes (but open policy for dev)

---

## Migration Options

### Option A: Keep Supabase Client + Self-Hosted PostgREST (Recommended)
- **Pros:** Minimal code changes — just swap the URL
- **PostgREST** gives the same REST API (`/rest/v1/campaigns`, etc.)
- Can run PostgREST on UGREEN NAS alongside Postgres
- Neon becomes the pure Postgres host
- **Cons:** Need public URL for PostgREST (Cloudflare Tunnel works)

**Architecture:**
```
Netlify (static app) → Cloudflare Tunnel → UGREEN NAS
                                          ├── PostgREST (REST API)
                                          └── Postgres (Neon or local)
```

### Option B: Refactor to Direct Postgres
- **Pros:** No PostgREST dependency, cleaner architecture
- **Cons:** Rewrite all data access code using `pg` or `postgres.js`
- More work upfront

### Option C: Use Supabase Client with Neon (Not Recommended)
- Supabase client is tightly coupled to Supabase's API shape
- Neon is just Postgres — no auth, no realtime, no REST layer
- Would require a compatibility shim anyway

---

## Migration Steps (When Ready)

1. ✅ Create Neon project (Kane has account)
2. ✅ Run schema SQL (adapted for Neon — remove Supabase-specific realtime)
3. ⬜ Export current Supabase data
4. ⬜ Import to Neon
5. ⬜ Update Netlify env vars (`VITE_SUPABASE_URL` → `VITE_DATABASE_URL`)
6. ⬜ Update app code to use chosen backend (PostgREST or direct Postgres)
7. ⬜ Test live sync still works
8. ⬜ Update documentation

---

## Neon Free Tier Limits
- **Compute:** 100 CU-hours/month (auto-suspends after 5 min idle)
- **Storage:** 0.5 GB/project
- **Egress:** 5 GB/month
- **Branches:** 10 per project
- **Does NOT pause** — auto-wakes on query (~500ms cold start)

---

## Notes

- Neon account created: 2026-08-20
- Repo cloned locally at: `/tmp/Tidebound-Winds-of-Plunder/`
- Schema file: `supabase/schema.sql`
- App URL: https://windsofplunder.netlify.app

---

## Decision Needed

Kane to decide:
1. Which architecture option (A, B, or hybrid)
2. Whether to use Neon as hosted Postgres or self-host Postgres on UGREEN
3. Timeline for migration
