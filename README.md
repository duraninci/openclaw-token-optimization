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
