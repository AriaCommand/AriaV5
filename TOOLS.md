# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- **Image generation:** built-in OpenAI/GPT image generation for suggestive / anime-style images (Kane's preferred canonical look). Pollinations.ai connector for explicit NSFW images. See Image Generation section below.
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

### Image Generation (Pollinations.ai)
- **Connector script:** `workspace/tools/pollinations-image.js`
- **Usage:** `node workspace/tools/pollinations-image.js "prompt" output.png [model=flux] [width=1024] [height=1024] [seed=123] [nologo=true]`
- **Notes:** Free, no API key, NSFW not filtered by default. Anonymous rate limit ~1 req/15s. Paid/registered tiers available at `auth.pollinations.ai`. Default model is `flux`.
- **Policy (Kane, 2026-08-06):** Use Pollinations for explicit NSFW images. Use built-in `image_generate` (OpenAI/GPT) for suggestive/teasing images and the anime-style canonical look.

### Romm (Retro Game Library)
- **NAS Address:** `http://192.168.0.197:8998` (Docker container on Ugreen NAS)
- **Library Path:** `/volume1/docker/romm/library/`
- **Config Path:** `/volume1/docker/romm/config/`
- **Upload Notes:** Use Chrome (Safari has WebSocket timeout issues with uploads)
- **Setup Date:** 2026-08-29

### Jellyfin
- **NAS Address:** `http://192.168.0.197:46109` (Docker container on Ugreen NAS)
- **Media Drive:** OWC Express 1M2 (3.6TB APFS)
- **Media Path:** `/Volumes/OWC Express 1M2/`

### Daggerheart App
- **Live Site:** https://windsofplunder.netlify.app (auto-deploys from GitHub main branch)
- **Repo:** `AriaCommand/Tidebound-Winds-of-Plunder.git`

### The Salty Scholar (FFXIV Scholar Dashboard)
- **Netlify:** https://thesaltyscholar.netlify.app
- **Custom Domain:** https://thesaltyscholarxiv.com (purchased 2026-07-02, DNS configuring)
- **Repo:** `AriaCommand/TheSaltyScholar.git`
- **Features:** Scholar combos, damage/healing calculators, Elpis Reforged static retrospective, FRU mitigation timeline with live Supabase sync
- **Future:** Blog section planned (name TBD — "Salty Notes" or "Medic Notes")

## Timers & Tools

- **Chinese Practice Timer** — `workspace/chinese-practice-timer.html`
  - 30-minute Pomodoro-style timer with start/stop/reset
  - Dark theme, progress bar, visual warnings at 5min/1min
  - Auto-opens in browser via `open` command
  - Created 2026-05-21, designed for Kane's Chinese study sessions

### Chinese Flashcards (Anki / TTS)
- **Format:**
  - **Front:** Chinese character(s) only (TTS reads this aloud — clean, correct tones)
  - **Back:** Pinyin + English translation
  - **Example:**
    - Front: 你好
    - Back: nǐ hǎo — Hello
- **Deck:** "Chinese Vocabulary"
- **Note:** Pinyin moved to back side to prevent TTS from repeating the word twice (once correctly in Chinese, once incorrectly as butchered pinyin).

---

Add whatever helps you do your job. This is your cheat sheet.

## Related

- [Agent workspace](/concepts/agent-workspace)
