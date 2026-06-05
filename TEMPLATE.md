# System Instruction Template

Copy this file to the appropriate platform folder, rename it, and fill in your content. Every field in the YAML frontmatter is required unless marked optional.

```markdown
---
title: "Agent Name — Short Description"
version: "1.0.0"
created: "YYYY-MM-DD"
updated: "YYYY-MM-DD"
author: "Your Name"
platform: "elevenlabs"
platforms: ["elevenlabs", "gemini-gems"]
status: "active"
tags: ["tag1", "tag2"]
character_count: 0
---

## Role

Who is this AI? What is its purpose? 2-3 sentences.

## Context

What does it know about? What domain, audience, or use case?

## How You Work

- **Voice & tone**: Describe the communication style
- **Key behaviors**: What it should always do
- **Workflow**: How it should approach tasks

## Capabilities

What can it do? List specific functions or skills.

## Constraints

What must it NOT do? Specific prohibitions.

## Output Format

How should responses be structured? Include examples if helpful.

---

### Version History

- **1.0.0** (YYYY-MM-DD): Initial version
```

## Frontmatter fields

| Field | Required | Description |
|-------|:--------:|-------------|
| `title` | Yes | Display name. Format: `"Agent Name — Short Description"` |
| `version` | Yes | Semantic version: `MAJOR.MINOR.PATCH` |
| `created` | Yes | First creation date: `YYYY-MM-DD` |
| `updated` | Yes | Last modified date: `YYYY-MM-DD` |
| `author` | Yes | Who wrote this version |
| `platform` | Yes | Primary platform: `elevenlabs`, `claude-code`, `claude-api`, `claude-ai-projects`, `gemini-gems`, `clickup` |
| `platforms` | Yes | All platforms this instruction is deployed to (array) |
| `status` | Yes | `draft`, `active`, `deprecated` |
| `tags` | No | Search/filter tags |
| `character_count` | No | Approximate length — quick check against platform limits |

## Platform character limits

| Platform | Limit |
|----------|-------|
| ElevenLabs | ~100K chars (via pointer pattern) |
| Claude API | 200K tokens |
| Gemini Gems | ~32K tokens |
| ClickUp Super Agent | Unknown (UI only) |

## Section guidelines

- **Role**: Who and what. Keep it tight — this is the first thing the model reads.
- **Context**: Domain knowledge, audience, use case. What the model needs to know before it starts.
- **How You Work**: Behavioral patterns, tone, approach. "Always X. Never Y."
- **Capabilities**: Specific functions. Bullet list.
- **Constraints**: Hard prohibitions. Bullet list. These are non-negotiable.
- **Output Format**: Structure expectations. Examples help.
- **Version History**: Every version gets a dated entry. Don't delete old entries.

## Version numbering

- **MAJOR** (`2.0.0`): Breaking change — role, platform, or core constraints changed
- **MINOR** (`1.1.0`): New capability, new constraint, significant rewrite
- **PATCH** (`1.0.1`): Typo fix, wording tweak, minor clarification

## Writing tips

1. **Start with the Role section.** If you can't describe what the AI is in 2-3 sentences, you're not ready to write instructions.
2. **Constraints before capabilities.** What it must NOT do is more important than what it can do.
3. **Be specific.** "Be helpful" is useless. "When asked for legal advice, say: 'I'm not qualified to give legal advice. You should consult an attorney.'"
4. **Test with edge cases.** Try prompt injection, out-of-scope requests, topic drift.
5. **Version everything.** Even a typo fix gets a new version number and a changelog entry.
