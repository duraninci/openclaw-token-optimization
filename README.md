# ⚡ OpenClaw Token Optimization Guide

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![OpenClaw Compatible](https://img.shields.io/badge/OpenClaw-Compatible-blue.svg)](https://github.com/openclaw/openclaw)
[![Cost Reduction](https://img.shields.io/badge/Cost%20Reduction-90%25+-brightgreen.svg)]()

**Reduce your AI agent costs by 90% or more.** This comprehensive guide shows you how to optimize token usage, implement intelligent model routing, leverage prompt caching, and use free local models for routine tasks—without sacrificing capability.

> **From $1,500/month to under $100/month.** Real results from production AI agent deployments.

---

## 💰 The Problem

Running AI agents 24/7 gets expensive fast:

| Cost Driver | Monthly Cost | Waste Factor |
|-------------|--------------|--------------|
| Heartbeats on Opus/Sonnet | $15-50 | 100% wasteable |
| Full context on every message | $50-100 | 80% wasteable |
| Using Opus for simple tasks | $100-500 | 90% wasteable |
| No prompt caching | $20-50 | 50% wasteable |
| **Typical Total** | **$200-700/mo** | **85% waste** |

---

## 🎯 The Solution

This guide implements four optimization strategies:

### 1. Free Local Models for Heartbeats
Use Ollama with Llama 3.2 (3B) for heartbeat checks—completely free.

```bash
# Install Ollama
brew install ollama && ollama serve
ollama pull llama3.2:3b
```

**Savings: 100% on heartbeat costs**

### 2. Intelligent Model Routing
Use the right model for each task:

| Task Type | Model | Cost |
|-----------|-------|------|
| Heartbeats, file ops | Ollama (local) | $0 |
| Simple queries | Haiku | $0.25/1M tokens |
| Writing, code review | Sonnet | $3/1M tokens |
| Architecture, legal | Opus | $15/1M tokens |

**Savings: 60-90% on model costs**

### 3. Context Compression
Stop loading 50KB+ on every message:

- Load only essential files on session start
- Use `memory_search` for on-demand recall
- Keep context files lean (< 2KB each)
- Clear session history after major tasks

**Savings: 80% on context costs**

### 4. Prompt Caching
Cache static content that doesn't change:

- System prompts
- Reference documentation
- User preferences
- Tool configurations

**Savings: 50% on repeated content**

---

## 📊 Results

| Metric | Before | After | Savings |
|--------|--------|-------|---------|
| Heartbeats (24/7) | $15/mo | $0 | 100% |
| Daily operations | $60/mo | $10/mo | 83% |
| Research tasks | $100/mo | $15/mo | 85% |
| Context overhead | $50/mo | $5/mo | 90% |
| **TOTAL** | **$225/mo** | **$30/mo** | **87%** |

---

## 🚀 Quick Start

### 5-Minute Setup

```bash
# 1. Install Ollama
brew install ollama
ollama serve &
ollama pull llama3.2:3b

# 2. Configure OpenClaw
openclaw config set heartbeat.model ollama/llama3.2:3b
openclaw config set model anthropic/claude-haiku-4-5
openclaw config set models.ollama.enabled true
openclaw config set cache.enabled true

# 3. Restart
openclaw gateway restart

# 4. Verify
openclaw status
```

### Full Implementation

See [IMPLEMENTATION.md](IMPLEMENTATION.md) for the complete guide with:
- Detailed configuration examples
- System prompt optimization rules
- Workspace file management
- Troubleshooting guide
- Team rollout plan

---

## 📁 Repository Contents

```
openclaw-token-optimization/
├── README.md              # This file
├── IMPLEMENTATION.md      # Complete implementation guide
├── configs/
│   ├── config.example.yaml    # OpenClaw config template
│   └── system-prompt-rules.md # System prompt additions
├── scripts/
│   └── verify-setup.sh        # Verification script
└── LICENSE
```

---

## ⚙️ Configuration Templates

### OpenClaw Config (config.yaml)

```yaml
# Default to cheapest capable model
agents:
  defaults:
    model:
      primary: anthropic/claude-haiku-4-5

# Heartbeats use free local model
heartbeat:
  every: 1h
  model: ollama/llama3.2:3b
  prompt: "Check HEARTBEAT.md. If nothing needs attention, reply HEARTBEAT_OK."

# Enable prompt caching
cache:
  enabled: true
  ttl: 5m

# Enable local models
models:
  ollama:
    enabled: true
    baseUrl: http://localhost:11434
```

### System Prompt Rules

```markdown
## MODEL SELECTION

Default: Haiku (fast, cheap)

Switch to Sonnet ONLY when:
- Writing client-facing content
- Code review or debugging
- Complex multi-step reasoning

Switch to Opus ONLY when:
- Architecture decisions
- Legal/contract analysis
- Security-critical review

When in doubt: Try Haiku first. Escalate only if it fails.
```

---

## 💡 Key Principles

### 1. Haiku First
Haiku is 60x cheaper than Opus. Use it for everything that doesn't require heavy reasoning.

### 2. Local for Routine
Heartbeats, file operations, and simple checks should use free local models.

### 3. Lean Context
Every KB of context costs money. Keep files small, load on demand.

### 4. Cache Static Content
System prompts and reference docs don't change—cache them.

### 5. Batch Operations
One request for 10 items beats 10 requests for 1 item.

---

## 📈 Cost Reference

| Model | Input (per 1M) | Output (per 1M) | Best For |
|-------|----------------|-----------------|----------|
| Opus | $15.00 | $75.00 | Legal, architecture |
| Sonnet | $3.00 | $15.00 | Writing, code review |
| Haiku | $0.25 | $1.25 | Everything else |
| Ollama | $0.00 | $0.00 | Heartbeats, file ops |

**Rule of Thumb:** If Haiku can do it, use Haiku.

---

## 🔧 Troubleshooting

| Issue | Fix |
|-------|-----|
| Ollama not responding | Run `ollama serve` in terminal |
| Still using expensive models | Check config syntax, restart gateway |
| Context still large | Add session init rules to system prompt |
| 429 rate limits | Reduce batch sizes, add delays |
| Cache not working | Verify `cache.enabled: true` |

---

## 🔄 Fallback LLMs — Free & Cheap Alternatives

Not every task needs Claude. Here's when to use alternatives:

### The Golden Rule

| Task | Best Model | Why |
|------|------------|-----|
| **Writing code** | Claude (Sonnet/Opus) | Best code quality, fewest bugs, understands context |
| **Everything else** | Use fallbacks | Save money without sacrificing output |

**Claude is the best code writer. Don't cheap out on code. But for everything else? Fallbacks work fine.**

---

### Free Tier Options

| Provider | Model | Free Tier | Best For |
|----------|-------|-----------|----------|
| **Google Gemini** | gemini-1.5-flash | 1,500 req/day | Summarization, Q&A, research |
| **Google Gemini** | gemini-1.5-pro | 50 req/day | Complex reasoning, analysis |
| **Grok** | grok-beta | Free on X Premium | Real-time info, casual queries |
| **Groq** | llama-3.1-70b | 30 req/min | Fast inference, simple tasks |
| **Groq** | mixtral-8x7b | 30 req/min | Multilingual, general purpose |
| **Mistral** | mistral-small | Limited free | European hosting, GDPR |
| **Ollama (local)** | llama3.2:3b | Unlimited | Heartbeats, file ops, routing |
| **Ollama (local)** | qwen2.5:7b | Unlimited | Better reasoning, still free |

---

### Task-to-Model Routing

| Task Type | Primary | Fallback | Cost Savings |
|-----------|---------|----------|--------------|
| **Code generation** | Claude Sonnet | — | Don't fallback |
| **Code review** | Claude Sonnet | — | Don't fallback |
| **Debugging** | Claude Sonnet | — | Don't fallback |
| **Summarization** | Gemini Flash | Groq Llama | 100% (free) |
| **Research/Q&A** | Gemini Flash | Grok | 100% (free) |
| **Translation** | Gemini Flash | Mistral | 100% (free) |
| **Data extraction** | Gemini Flash | Groq Mixtral | 100% (free) |
| **Email drafting** | Gemini Pro | Claude Haiku | 90% |
| **Document analysis** | Gemini Pro | Claude Haiku | 90% |
| **Heartbeats** | Ollama local | — | 100% (free) |
| **File operations** | Ollama local | — | 100% (free) |
| **Routing decisions** | Ollama local | Groq | 100% (free) |

---

### Configuration Example

```yaml
# Multi-model routing in OpenClaw
agents:
  defaults:
    model:
      primary: anthropic/claude-haiku-4-5
    
    # Route by task type
    routing:
      code: anthropic/claude-sonnet-4-5      # Never compromise on code
      summarize: google/gemini-1.5-flash     # Free tier
      research: google/gemini-1.5-flash      # Free tier
      translate: google/gemini-1.5-flash     # Free tier
      heartbeat: ollama/llama3.2:3b          # Local, free
      default: anthropic/claude-haiku-4-5    # Cheap fallback

# Provider configs
models:
  google:
    enabled: true
    apiKey: ${GOOGLE_API_KEY}
  groq:
    enabled: true
    apiKey: ${GROQ_API_KEY}
  ollama:
    enabled: true
    baseUrl: http://localhost:11434
```

---

### Getting API Keys (All Free)

| Provider | Sign Up | Free Tier |
|----------|---------|-----------|
| **Google AI Studio** | [aistudio.google.com](https://aistudio.google.com) | 1,500 req/day |
| **Groq** | [console.groq.com](https://console.groq.com) | 30 req/min |
| **Mistral** | [console.mistral.ai](https://console.mistral.ai) | Limited free |
| **Grok** | X Premium subscription | Unlimited with sub |

---

### When NOT to Fallback

**Always use Claude for:**
- ✅ Writing new code
- ✅ Refactoring existing code
- ✅ Debugging complex issues
- ✅ Code review and security analysis
- ✅ System architecture decisions
- ✅ Anything that touches production

**Why?** Claude produces fewer bugs, better structure, and actually understands your codebase context. The cost difference is negligible compared to debugging bad code.

---

### Real Cost Comparison

Running 1,000 queries/day:

| Strategy | Monthly Cost |
|----------|--------------|
| All Claude Opus | $450+ |
| All Claude Sonnet | $90+ |
| All Claude Haiku | $15 |
| **Smart routing (code=Claude, rest=free)** | **$5-10** |

**80% of queries don't need Claude. Route them to free tiers.**

---

## 🔁 API Key Failover — Automatic Rate Limit Recovery

Got multiple API accounts? Set up automatic failover so rate limits don't stop your work.

### The Problem

```
Error 429: Rate limit exceeded
```

Your workflow stops. You manually switch keys. Waste of time.

### The Solution

Automatic failover between accounts — company key hits limit, personal key takes over. Zero intervention.

---

### Option 1: LiteLLM Proxy (Recommended) ⭐

LiteLLM is a proxy that sits between your app and AI providers. Handles failover, load balancing, and retries automatically.

**Install:**
```bash
pip install litellm
```

**Create config file** (`litellm_config.yaml`):
```yaml
model_list:
  # Primary: Company account
  - model_name: claude-sonnet
    litellm_params:
      model: anthropic/claude-sonnet-4-5
      api_key: sk-ant-company-xxxxx
    
  # Fallback: Personal account
  - model_name: claude-sonnet
    litellm_params:
      model: anthropic/claude-sonnet-4-5
      api_key: sk-ant-personal-xxxxx

  # Can add more providers too
  - model_name: claude-sonnet
    litellm_params:
      model: anthropic/claude-sonnet-4-5
      api_key: sk-ant-backup-xxxxx

router_settings:
  retry_after: 60              # Wait 60s before retry
  allowed_fails: 1             # Fail once, then switch
  fallbacks: [{"claude-sonnet": ["claude-sonnet"]}]
  routing_strategy: "least-busy"  # Or "simple-shuffle"
```

**Start the proxy:**
```bash
litellm --config litellm_config.yaml --port 4000
```

**Point OpenClaw to the proxy:**
```yaml
# In your OpenClaw config
models:
  anthropic:
    baseUrl: http://localhost:4000
```

**What happens:**
1. Request goes to LiteLLM proxy
2. Proxy tries company key
3. If 429 → automatically tries personal key
4. If that fails → tries backup key
5. Your app never sees the error

**Run as background service:**
```bash
# Using pm2
pm2 start "litellm --config litellm_config.yaml --port 4000" --name litellm-proxy

# Or using systemd (create /etc/systemd/system/litellm.service)
```

---

### Option 2: OpenClaw Native Config

If your OpenClaw version supports multiple keys:

```yaml
models:
  anthropic:
    apiKeys:
      - ${ANTHROPIC_API_KEY_COMPANY}
      - ${ANTHROPIC_API_KEY_PERSONAL}
      - ${ANTHROPIC_API_KEY_BACKUP}
    fallbackOnRateLimit: true
    retryDelay: 60
```

Check your version: `openclaw --version` and docs at [docs.openclaw.ai](https://docs.openclaw.ai)

---

### Option 3: Environment Variable Rotation

Simple script for manual or cron-triggered rotation:

```bash
#!/bin/bash
# rotate-api-key.sh

COMPANY_KEY="sk-ant-company-xxxxx"
PERSONAL_KEY="sk-ant-personal-xxxxx"

# Check which key is active
if [ "$ANTHROPIC_API_KEY" == "$COMPANY_KEY" ]; then
  export ANTHROPIC_API_KEY=$PERSONAL_KEY
  echo "Switched to personal key"
else
  export ANTHROPIC_API_KEY=$COMPANY_KEY
  echo "Switched to company key"
fi

# Restart to pick up new key
openclaw gateway restart
```

**Trigger on rate limit detection:**
```bash
# In your monitoring script
if grep -q "429" /var/log/openclaw/error.log; then
  ./rotate-api-key.sh
fi
```

---

### Comparison

| Approach | Auto-Failover | Setup Time | Maintenance |
|----------|---------------|------------|-------------|
| **LiteLLM Proxy** ⭐ | ✅ Instant | 10 min | Low |
| OpenClaw Native | ✅ Instant | 5 min | None |
| Env Rotation Script | ❌ Manual/Cron | 5 min | Medium |

---

### Pro Tips

1. **Stagger rate limit windows** — If both accounts share the same billing cycle, they'll hit limits together. Use accounts with different reset times if possible.

2. **Monitor which key is active** — LiteLLM logs which key handled each request. Useful for cost allocation.

3. **Set up alerts** — If you're falling back frequently, you need more capacity or better routing.

4. **Combine with model routing** — Use cheap/free models for non-critical tasks (see Fallback LLMs section above), save your rate limit budget for code.

---

## 🤝 Contributing

Found a new optimization? Submit a PR!

1. Fork the repository
2. Add your optimization technique
3. Include before/after metrics
4. Submit a pull request

---

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.

---

## 🔗 Related Projects

- [OpenClaw](https://github.com/openclaw/openclaw) — The AI agent framework
- [RookOS](https://github.com/duraninci/rookos) — AI Agent Command Center
- [OpenClaw Legal Skills](https://github.com/duraninci/openclaw-legal-skills) — AI-powered legal analysis

---

## 🛠️ Who Built This

Built by **[Duran Inci](https://duraninci.com)** and the teams at **[Optimum7](https://optimum7.com)** and **[Zen Media](https://zenmedia.com)**.

We run AI agents 24/7 for ecommerce operations, lead enrichment, and content automation. Our bill got stupid. So we fixed it. This guide is how.

**More of our work:**
- 📺 [YouTube](https://youtube.com/@duraninci) — AI implementation, ecommerce, business
- 🔗 [LinkedIn](https://linkedin.com/in/duraninci)
- 🐦 [Twitter/X](https://twitter.com/duraninci)

---

## 🤝 Work With Us

Running AI at scale and burning cash? We've been there.

| What | Who |
|------|-----|
| AI systems & ecommerce automation | [Optimum7](https://optimum7.com) |
| B2B marketing & AI visibility | [Zen Media](https://zenmedia.com) |

Happy to trade notes with anyone optimizing their stack.
