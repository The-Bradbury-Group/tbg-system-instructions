# TBG System Instructions

Central source of truth for The Bradbury Group's AI system instructions. One repo. One format. Every platform.

## What's here

System prompts and behavioral instructions for every AI surface TBG uses:
- **ElevenLabs** — voice interview agents (Solomon 1–4)
- **Claude** — Claude Code (CLAUDE.md), Claude API (Walter, SuperAssistant), Claude.ai Projects
- **Gemini Gems** — course tutors, client-facing assistants
- **ClickUp AI** — Super Agent instructions and knowledge sources

## How it works

```
GitHub (source) ──┬──▶ Supabase Storage ──▶ ElevenLabs agents (auto)
                  │
                  ├──▶ Claude API (code deploy)
                  │
                  ├──▶ Slack notification ──▶ Gemini Gems (copy/paste)
                  │
                  └──▶ Slack notification ──▶ ClickUp AI (copy/paste)
```

Each platform has its own constraints — see [PLAYBOOK.md](PLAYBOOK.md) for step-by-step instructions per platform.

## Format

All instructions use a single standard: **YAML frontmatter + Markdown body**. Copy [TEMPLATE.md](TEMPLATE.md) to start a new one.

## Folder structure

```
tbg-system-instructions/
├── README.md
├── CHANGELOG.md
├── PLAYBOOK.md              # How to update each platform
├── TEMPLATE.md              # Standard format for new instructions
├── gemini-gems/             # Google Gemini Gems instructions
│   └── _shared/             # Shared persona/voice text
├── elevenlabs/              # ElevenLabs voice agent instructions
├── claude/                  # Claude Code, Claude API, Claude.ai Projects
│   ├── claude-code/
│   └── claude-ai-projects/
├── clickup/                 # ClickUp Super Agent instructions
└── _scripts/                # Sync scripts and utilities
```

## Contributing

1. Copy `TEMPLATE.md` to the right platform folder
2. Write your instructions (YAML frontmatter + Markdown)
3. Commit with format: `system(platform): description`
4. Push — auto-sync handles ElevenLabs, Slack notifies for manual platforms

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
