# TBG System Instructions

Central source of truth for The Bradbury Group's AI system instructions. One repo. One format. Every platform.

## The Problem

TBG's AI system instructions are scattered across platforms with no single source of truth. The `system-instructions/` folder in Google Drive is stale (last updated June 2025). Individual app repos have their own copies. Gemini Gems can't be shared across `.com` and `.net` accounts — same instructions pasted twice.

When a prompt changes, there's no way to know:
- What changed and why
- Who approved it
- Which platforms need updating
- Whether the update actually happened

These prompts are intellectual property that define how TBG's AI products behave. They should be versioned, reviewed, and deployed with the same rigor as code.

## Why GitHub

**GitHub is the canonical source of truth.** A sync script pushes to Supabase Storage for runtime fetch.

Why not the alternatives:

| Alternative | Problem |
|-------------|---------|
| Google Drive + Apps Script | No version control, no branching, no PR review, no diff |
| Lightweight API (Flask/Railway) | Adds deployment surface for no benefit — Supabase Storage already IS an API |
| Pure GitHub raw URLs | No auth, rate limiting, no caching/fallback |

GitHub gives us: git history, branch/PR review workflow, diff view, commit attribution, Actions for CI/CD, and Slack integration. For a 3-person team, this is the right level of infrastructure — no more, no less.

## Platform Reality

Not every platform has an API. We don't pretend otherwise.

| Platform | Has API? | Update Method | Owner |
|----------|:--------:|---------------|-------|
| **ElevenLabs** | Yes | Git push → GitHub Actions → API | Charlie |
| **Claude API** | Yes | Git push → Railway deploy | Charlie |
| **Claude Code** | Yes | Git push → CLAUDE.md | Charlie |
| **Gemini Gems** | **No** | Copy/paste after Slack notification | Aperna |
| **Claude.ai Projects** | **No** | Copy/paste after Slack notification | Charlie/Paige |
| **ClickUp AI** | **Partial** | UI: copy/paste. Runtime: webhook → external service fetches instructions | Paige |

For platforms with APIs, changes deploy automatically. For platforms without, a GitHub Actions workflow (built, pending `SLACK_WEBHOOK_URL` secret) will post to Slack with the changed file, diff summary, and explicit copy/paste instructions. Until the webhook is configured, the committer notifies the updater directly. The process is documented step-by-step in [PLAYBOOK.md](PLAYBOOK.md).

The Gemini Gems constraint is real — Google has no Gems API, and `.com` / `.net` accounts are separate. Accepting copy/paste as the answer and making it as painless as possible is the honest approach.

## Format

All instructions use a single standard: **YAML frontmatter + Markdown body**.

Why:
- GitHub renders Markdown natively
- YAML frontmatter is machine-parseable for scripts and CI validation
- Version history lives in-file alongside the content — immediate context without `git log`
- One format works for every platform (even the copy/paste ones)
- `character_count` field serves as a quick check against platform token limits

Copy [TEMPLATE.md](TEMPLATE.md) to start a new instruction.

## How it works

```
GitHub (source) ──┬──▶ Supabase Storage ──▶ ElevenLabs agents (auto, pending API key secret)
                  │
                  ├──▶ Claude API (code deploy)
                  │
                  ├──▶ Slack notification ──▶ Gemini Gems (copy/paste)
                  │         └─ workflow built, pending webhook secret
                  │
                  └──▶ Slack notification ──▶ ClickUp AI (copy/paste)
                            └─ workflow built, pending webhook secret
```

## Folder structure

```
tbg-system-instructions/
├── README.md
├── CHANGELOG.md
├── PLAYBOOK.md              # How to update each platform
├── TEMPLATE.md              # Standard format for new instructions
├── IMPLEMENTATION_PLAN.md   # Phased rollout plan
├── gemini-gems/             # Google Gemini Gems instructions
│   └── _shared/             # Shared persona/voice text
├── elevenlabs/              # ElevenLabs voice agent instructions
├── claude/                  # Claude Code, Claude API, Claude.ai Projects
│   ├── claude-code/
│   ├── claude-api/
│   └── claude-ai-projects/
├── clickup/                 # ClickUp Super Agent instructions
└── _scripts/                # Sync scripts and utilities
```

## Contributing

1. Copy `TEMPLATE.md` to the right platform folder
2. Write your instructions (YAML frontmatter + Markdown)
3. Commit with format: `system(platform): description`
4. Push — auto-sync handles ElevenLabs (once API key secret is set), Slack notifies for manual platforms (once webhook secret is set)

See [PLAYBOOK.md](PLAYBOOK.md) for platform-specific deployment steps.

## Owners

| Platform | Owner | Auto-deploy? |
|----------|-------|:--:|
| ElevenLabs | Charlie | Yes |
| Claude Code | Charlie | Yes (git push) |
| Claude API | Charlie | Code deploy |
| Gemini Gems | Aperna | No (copy/paste) |
| Claude.ai Projects | Charlie/Paige | No (copy/paste) |
| ClickUp AI | Paige | No (copy/paste) |
