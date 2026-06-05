# Implementation Plan

## This Week (by 2026-06-06)

- [x] **Create GitHub repo** — `The-Bradbury-Group/tbg-system-instructions` — **Charlie**
- [x] **Scaffold folder structure** — README, TEMPLATE, PLAYBOOK, CHANGELOG — **Charlie**
- [x] **Write standard format** — YAML frontmatter + Markdown template — **Charlie**
- [x] **Migrate Solomon 1 & 2** — ElevenLabs agent instructions to standard format — **Charlie**
- [x] **Migrate Walter** — Full system instructions to standard format — **Charlie**
- [x] **Write ElevenLabs sync script** — `_scripts/sync-elevenlabs.sh` — **Charlie**
- [x] **Write GitHub Actions** — ElevenLabs auto-sync, Slack notifications, YAML validation — **Charlie**
- [x] **Write playbook** — Per-platform update instructions for Aperna and Paige — **Charlie**
- [ ] **Add TBG team as repo collaborators** — Paige, Aperna — **Charlie**
- [ ] **Set up repo secrets** — `ELEVENLABS_API_KEY`, `SLACK_WEBHOOK_URL` — **Charlie**
- [ ] **Paige review** — Read through all files, confirm format and structure — **Paige**
- [ ] **Aperna walkthrough** — Show Aperna the Gemini Gems copy/paste workflow in PLAYBOOK.md — **Charlie**

## Next Week (by 2026-06-13)

- [ ] **Migrate Solomon 3 & 4** — Remaining ElevenLabs agent instructions — **Charlie**
- [ ] **Migrate SuperAssistant function library** — `library_baseline` to `claude/claude-api/` — **Charlie**
- [ ] **Create course-tutor Gem instruction** — For Paige's L&D cohort — **Paige/Charlie**
- [ ] **Audit Google Drive `system-instructions/` folder** — List every file, last modified, decide migrate/archive/delete — **Charlie**
- [ ] **Set up Supabase Storage sync** — GitHub Action pushes to Supabase Storage bucket on change — **Charlie**
- [ ] **Test ElevenLabs auto-sync end-to-end** — Push a change, verify agent updates — **Charlie**
- [ ] **Test Slack notification** — Push a gemini-gems change, verify Slack message — **Charlie**
- [ ] **Add remaining ElevenLabs agent IDs** — Solomon 3 & 4 to agent ID mapping — **Charlie**
- [ ] **Write Gemini Gems solomon-interview instruction** — Combined version for manual Gem use — **Charlie**

## Month 1 (by 2026-07-04)

- [ ] **Migrate all remaining Drive instructions** — Any active instructions still in the stale Drive folder — **Charlie**
- [ ] **ClickUp Super Agent instruction** — Write and add to `clickup/` — **Paige**
- [ ] **Claude.ai Projects instructions** — Write for any active Projects — **Charlie/Paige**
- [ ] **L&D Cohort module built** — Paige's course module on system instruction architecture, using this repo as the example — **Paige**
- [ ] **Aperna fully independent** — Aperna can handle Gemini Gems copy/paste without Charlie — **Charlie**
- [ ] **CI validation hardened** — Add character count checks, platform limit warnings, duplicate title detection — **Charlie**
- [ ] **Slack → confirmation workflow** — Aperna reacts ✅ on Slack when copy/paste complete, CI tracks pending/complete — **Charlie**
- [ ] **Version diff summaries** — Auto-generate human-readable diff when version bumps (what changed between 1.3 and 1.4) — **Charlie**

## Backlog

- [ ] **PR-based review workflow** — Paige reviews and approves instruction changes via PR before merge — **Charlie/Paige**
- [ ] **Gemini Gems auto-create** — If Google ships a Gems API, switch from copy/paste to automated — **Charlie**
- [ ] **ClickUp API watch** — If ClickUp ships Super Agent API, wire up auto-sync — **Charlie**
- [ ] **Multi-language support** — If TBG expands internationally, add translated instruction variants — **Paige**
- [ ] **Analytics dashboard** — Track which instructions change most often, which platforms have stale instructions — **Charlie**

## Owner Key

| Owner | Role |
|-------|------|
| **Charlie** | Architect/builder — owns GitHub, ElevenLabs, Claude Code, CI/CD |
| **Paige** | CEO — owns Gemini Gems, ClickUp AI, Claude.ai Projects, content review |
| **Aperna** | Ops — executes Gemini Gems copy/paste, confirms updates in Slack |
