# System Prompt Rules for Token Optimization

Add these rules to your agent's system prompt (AGENTS.md or equivalent):

---

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

---

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

---

## RATE LIMITS

- 5 seconds minimum between API calls
- 10 seconds between web searches
- Max 5 searches per batch, then 2-minute break
- Batch similar work (one request for 10 items, not 10 requests)
- If you hit 429 error: STOP, wait 5 minutes, retry

---

## CONTEXT MANAGEMENT

Keep workspace files lean:

| File | Max Size | Purpose |
|------|----------|---------|
| SOUL.md | 2KB | Core principles only |
| USER.md | 1KB | Key info about the user |
| IDENTITY.md | 500B | Agent identity |
| TOOLS.md | 2KB | Tool-specific notes |
| HEARTBEAT.md | 1KB | Current tasks only |

If a file grows beyond these limits, archive old content to memory/*.md

---

## SESSION COMMANDS

When user says "new session" or "clear session":
1. Save current session summary to memory/YYYY-MM-DD.md
2. Clear conversation history
3. Reload only essential context files
4. Confirm: "Session cleared. Context reset to 5KB."

---

## BATCH OPERATIONS

When processing multiple items:
- Combine into single requests where possible
- Process in batches of 10, not one at a time
- Use loops within a single API call, not multiple calls

Example:
- ❌ Bad: 10 separate API calls for 10 files
- ✅ Good: 1 API call that processes 10 files
