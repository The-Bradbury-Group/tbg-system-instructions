# Playbook — How to Update System Instructions Per Platform

This playbook covers how to update system instructions on each platform TBG uses. Some platforms auto-deploy on git push. Others require manual copy/paste — those steps are documented here.

---

## ElevenLabs (Auto)

**Owner:** Charlie
**Update method:** GitHub push → GitHub Actions → ElevenLabs API

### How it works

1. Edit the instruction file in `elevenlabs/<agent-name>/instructions.md`
2. Commit and push to `main`
3. GitHub Actions runs `_scripts/sync-elevenlabs.sh` — updates the live agent via ElevenLabs API
4. Check the Action run log for success/failure

### Manual override (if CI fails)

```bash
# Set your ElevenLabs API key
export ELEVENLABS_API_KEY="your-key"

# Run the sync script directly
./_scripts/sync-elevenlabs.sh elevenlabs/solomon-1-pain-points/instructions.md
```

### Agent IDs

| Agent | File | ElevenLabs Agent ID |
|-------|------|---------------------|
| Solomon 1 — Pain Points | `elevenlabs/solomon-1-pain-points/instructions.md` | `agent_9501kt898re7fcvak6ve4emd8jzy` |
| Solomon 2 — Work Style | `elevenlabs/solomon-2-work-style/instructions.md` | `agent_4201kt896q0fef6rymws3ntk7c39` |

### Runtime injection (TSE-stripped pattern)

For agents using the pointer pattern (short prompt in ElevenLabs UI, full instructions fetched at runtime):

1. Push updated instructions to Supabase Storage bucket `system-instructions`
2. The TSE-stripped worker fetches from Supabase Storage at call time — no agent update needed

---

## Claude API (Auto)

**Owner:** Charlie
**Update method:** Code deploy via Railway

### How it works

Instructions in `claude/claude-api/` are used by the backend at runtime via `system_instructions_loader.py`. Deploy the backend to apply changes.

### Backend loader pattern

```
Supabase Storage (system-instructions bucket)
       ↓
system_instructions_loader.py (fetches at runtime)
       ↓
Claude API system parameter
```

---

## Claude Code (Auto)

**Owner:** Charlie
**Update method:** Git push

### How it works

- Project-level: `CLAUDE.md` in the project repo
- Global: `~/.claude/CLAUDE.md`

This repo tracks the templates and shared instructions that feed into CLAUDE.md files.

---

## Gemini Gems (Manual)

**Owner:** Aperna
**Update method:** Copy/paste

### Why manual

Google has no API for Gemini Gems. Instructions must be pasted into the Gem editor UI. Additionally, `.com` and `.net` accounts are separate — the same instructions must be pasted twice.

### Step-by-step

1. **You'll receive a Slack notification** when a `gemini-gems/` file is updated on GitHub. The notification includes:
   - Which file changed
   - What changed (diff summary)
   - A direct link to the raw file

2. **Open the raw file** from the GitHub link

3. **Copy the full content** (YAML frontmatter + Markdown body)

4. **Open Gemini Gems** — go to [gemini.google.com](https://gemini.google.com) (`.com` account)

5. **Find the Gem** by name and open it for editing

6. **Replace the instructions** — select all in the instruction field, paste the new content

7. **Save the Gem**

8. **Repeat steps 4–7** for the `.net` account:
   - Sign out of `.com`
   - Sign in to `paige@thebradburygroup.net`
   - Go to [gemini.google.com](https://gemini.google.com)
   - Find the same Gem, paste the same content, save

9. **Confirm in Slack** — react with ✅ on the notification message

### Gems to update

| Gem | File | .com | .net |
|-----|------|:----:|:----:|
| Solomon Interview | `gemini-gems/solomon-interview/instructions.md` | ✓ | ✓ |
| Course Tutor | `gemini-gems/course-tutor/instructions.md` | ✓ | ✓ |

---

## Claude.ai Projects (Manual)

**Owner:** Charlie / Paige
**Update method:** Copy/paste

### Why manual

Claude.ai Projects have no API for updating project instructions programmatically.

### Step-by-step

1. **You'll receive a Slack notification** when a `claude/claude-ai-projects/` file is updated

2. **Open the raw file** from the GitHub link

3. **Copy the full content**

4. **Go to** [claude.ai](https://claude.ai) → Projects → find the project

5. **Click "Set custom instructions"** (or edit existing)

6. **Paste the new content**

7. **Save**

---

## ClickUp AI (Partial)

**Owner:** Paige
**Update method:** Hybrid — static UI config + runtime webhook fetch

### Why partial

ClickUp has no public API to set Super Agent instructions programmatically. The Super Agent's static instructions in the UI are a thin pointer — rarely changed. The real system prompt is fetched at runtime via the webhook pattern.

### Architecture

```
ClickUp trigger → webhook → external service → fetch instructions from Supabase → process → write response back to ClickUp
```

Same pointer pattern as ElevenLabs. The Super Agent's UI instructions say "fetch your full instructions from [URL]." The orchestration layer does the rest.

### What's manual

1. The Super Agent's static UI instructions (thin pointer — update rarely, maybe once per quarter)
2. Agent configuration (tools, memory, knowledge sources)

### What's automated

1. **Runtime instruction injection** — webhook → external service fetches latest from Supabase
2. **Instruction updates** — edit in GitHub, service picks up changes on next trigger
3. **Version history** — full git log on all instruction changes

### Step-by-step (when static instructions change)

1. Edit `clickup/` file in this repo
2. Push — Slack notification goes to Paige
3. Paige opens the Super Agent in ClickUp, pastes the updated pointer
4. That's it — runtime instructions update automatically on next trigger

### If ClickUp ships native HTTP/API calls

This entire path flips to auto. The feature request exists but isn't shipped yet.

---

## Commit message convention

```
system(<platform>): <description>
```

Examples:
- `system(elevenlabs): Update solomon-1 prompt, bump to 2.1.0`
- `system(gemini-gems): Add course-tutor instructions`
- `system(claude-api): Add guardrail for legal advice`
- `system(clickup): Update super-agent knowledge sources`

Platform values: `elevenlabs`, `claude-code`, `claude-api`, `claude-ai-projects`, `gemini-gems`, `clickup`

---

## Who does what

| Role | Responsibility |
|------|---------------|
| Charlie | Write/edit instructions, push to GitHub, ElevenLabs sync, Claude API deploys, Claude.ai Projects updates |
| Paige | Review instructions, ClickUp AI updates, Claude.ai Projects updates |
| Aperna | Gemini Gems copy/paste (both .com and .net), Slack confirmation |
