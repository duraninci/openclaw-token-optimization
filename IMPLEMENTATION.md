# OpenClaw Token Optimization — Implementation Plan

**Goal:** Reduce AI costs by 90%+ without sacrificing capability
**Expected Outcome:** $1,500+/month → $50-100/month
**Time to Implement:** 30-60 minutes

---

## Executive Summary

We're burning tokens on:
1. Heartbeats using expensive models (should be free)
2. Loading full session history on every message
3. Using Opus/Sonnet for simple tasks
4. Not leveraging prompt caching

This plan fixes all four. Each team member should implement on their OpenClaw instance.

---

## Phase 1: Quick Wins (15 minutes)

### 1.1 Install Ollama (Free Local LLM)

```bash
# macOS
brew install ollama

# Start the service
ollama serve

# Pull lightweight model for heartbeats
ollama pull llama3.2:3b
```

**Verify it works:**
```bash
ollama run llama3.2:3b "respond with OK"
```

---

### 1.2 Update OpenClaw Config

Edit `~/.openclaw/config.yaml` (or `openclaw.json`):

```yaml
# Model Configuration
agents:
  defaults:
    model:
      primary: anthropic/claude-haiku-4-5
    models:
      anthropic/claude-opus-4-5:
        alias: opus
      anthropic/claude-sonnet-4-5:
        alias: sonnet
      anthropic/claude-haiku-4-5:
        alias: haiku
      ollama/llama3.2:3b:
        alias: local
      ollama/qwen2.5:7b:
        alias: qwen

# Heartbeat Configuration - USE FREE LOCAL MODEL
heartbeat:
  every: 1h
  model: ollama/llama3.2:3b
  prompt: "Check HEARTBEAT.md. If nothing needs attention, reply HEARTBEAT_OK."

# Enable Prompt Caching
cache:
  enabled: true
  ttl: 5m

# Ollama Configuration
models:
  ollama:
    enabled: true
    baseUrl: http://localhost:11434
```

**Restart OpenClaw after changes:**
```bash
openclaw gateway restart
```

---

## Phase 2: System Prompt Updates (10 minutes)

Add these rules to your agent's system prompt (AGENTS.md or equivalent):

### 2.1 Session Initialization Rule

```markdown
## SESSION INITIALIZATION

On every session start:
1. Load ONLY these files:
   - SOUL.md
   - USER.md  
   - IDENTITY.md
   - memory/YYYY-MM-DD.md (today's date)

2. DO NOT auto-load:
   - MEMORY.md (use memory_search on demand)
   - Full session history
   - Previous tool outputs
   - Old daily memory files

3. When user asks about prior context:
   - Use memory_search() first
   - Pull only relevant snippets with memory_get()
   - Never load entire files unless asked

This reduces context from 50KB to 5-8KB per message.
```

### 2.2 Model Selection Rule

```markdown
## MODEL SELECTION

Default: Haiku (fast, cheap)

Switch to Sonnet ONLY when:
- Writing client-facing content
- Code review or debugging
- Complex multi-step reasoning
- Strategic analysis

Switch to Opus ONLY when:
- Architecture decisions
- Legal/contract analysis
- Security-critical review
- Multi-project coordination

When in doubt: Try Haiku first. Escalate only if it fails.
```

### 2.3 Rate Limits

```markdown
## RATE LIMITS

- 5 seconds minimum between API calls
- 10 seconds between web searches
- Max 5 searches per batch, then 2-minute break
- Batch similar work (one request for 10 items, not 10 requests)
- If you hit 429 error: STOP, wait 5 minutes, retry

DAILY BUDGET: $10 (warning at 75%)
MONTHLY BUDGET: $300 (warning at 75%)
```

---

## Phase 3: Workspace Optimization (10 minutes)

### 3.1 Keep Context Files Lean

| File | Max Size | Purpose |
|------|----------|---------|
| SOUL.md | 2KB | Core principles only |
| USER.md | 1KB | Key info about the user |
| IDENTITY.md | 500B | Agent identity |
| TOOLS.md | 2KB | Tool-specific notes |
| HEARTBEAT.md | 1KB | Current tasks only |

**Rule:** If a file grows beyond these limits, archive old content to memory/*.md

### 3.2 Daily Memory Structure

```
memory/
├── YYYY-MM-DD.md     ← Today's notes (load this)
├── YYYY-MM-DD.md     ← Yesterday (load on demand)
├── people.md         ← Reference only
├── projects.md       ← Reference only
└── archive/          ← Old daily files
```

---

## Phase 4: Session Management (5 minutes)

### 4.1 Clear Session History Command

Add to your workflow: When starting a new task, clear old context:

```
/session clear
```

Or create a custom command in your agent:

```markdown
## SESSION COMMANDS

When user says "new session" or "clear session":
1. Save current session summary to memory/YYYY-MM-DD.md
2. Clear conversation history
3. Reload only essential context files
4. Confirm: "Session cleared. Context reset to 5KB."
```

### 4.2 Messaging Platform Optimization

If using Slack/WhatsApp/Telegram:
- Session history compounds with every message
- Clear sessions daily or after major tasks
- Don't let history exceed 20 messages before clearing

---

## Phase 5: Prompt Caching (5 minutes)

### 5.1 What to Cache (Static Content)

| Cache This | Don't Cache |
|------------|-------------|
| SOUL.md | Daily memory files |
| USER.md | Recent messages |
| TOOLS.md | Tool outputs |
| Reference docs | Conversation history |
| System prompts | Dynamic content |

### 5.2 Maximize Cache Hits

- Batch requests within 5-minute windows
- Keep system prompts stable (don't edit mid-session)
- Separate static docs from dynamic notes
- Update config files during maintenance, not live

---

## Verification Checklist

After implementation, verify:

```bash
# Check OpenClaw status
openclaw status

# Should show:
# - Model: claude-haiku (not opus/sonnet)
# - Heartbeat: ollama/llama3.2:3b (not anthropic)
# - Cache: enabled
```

### Signs It's Working

| Metric | Before | After |
|--------|--------|-------|
| Context size | 50KB+ | 5-8KB |
| Default model | Opus/Sonnet | Haiku |
| Heartbeat cost | $5-15/mo | $0 |
| Daily idle cost | $2-5 | $0.10-0.50 |
| Overnight research task | $50-150 | $5-10 |

---

## Cost Comparison

| Scenario | Before | After | Savings |
|----------|--------|-------|---------|
| Heartbeats (24/7) | $15/mo | $0 | 100% |
| Daily operations | $60/mo | $10/mo | 83% |
| Research tasks | $100/mo | $15/mo | 85% |
| Context overhead | $50/mo | $5/mo | 90% |
| **TOTAL** | **$225/mo** | **$30/mo** | **87%** |

---

## Model Cost Reference

| Model | Input (per 1M tokens) | Output (per 1M tokens) | Use For |
|-------|----------------------|------------------------|---------|
| Opus | $15.00 | $75.00 | Legal, architecture, security |
| Sonnet | $3.00 | $15.00 | Writing, code review |
| Haiku | $0.25 | $1.25 | Everything else (DEFAULT) |
| Ollama | $0.00 | $0.00 | Heartbeats, file ops |

**Haiku is 60x cheaper than Opus for input, 60x cheaper for output.**

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| Ollama not responding | Run `ollama serve` in terminal |
| Still using Sonnet | Check config.yaml syntax, restart gateway |
| Context still large | Verify session init rules in system prompt |
| 429 rate limits | Reduce batch sizes, add delays |
| Cache not working | Verify `cache.enabled: true` in config |

---

## Quick Start Commands

```bash
# Install Ollama
brew install ollama && ollama serve

# Pull models
ollama pull llama3.2:3b
ollama pull qwen2.5:7b

# Set Haiku as default
openclaw config set model anthropic/claude-haiku-4-5

# Enable Ollama
openclaw config set models.ollama.enabled true

# Set heartbeat to Ollama
openclaw config set heartbeat.model ollama/llama3.2:3b

# Restart
openclaw gateway restart

# Verify
openclaw status
```

---

## Team Rollout

| Week | Action | Owner |
|------|--------|-------|
| 1 | Install Ollama on all dev machines | Each engineer |
| 1 | Update config files | Each engineer |
| 1 | Add system prompt rules | Each engineer |
| 2 | Monitor costs for 1 week | Team lead |
| 2 | Adjust model routing based on results | Team lead |
| 3 | Document any issues/edge cases | Team |

---

## Support

- OpenClaw Docs: https://docs.openclaw.ai
- Ollama Docs: https://ollama.com/library
- Original Guide: @mattganzak (YouTube/TikTok)

---

*Last Updated: March 1, 2026*
*Created by: Rook ♜*
