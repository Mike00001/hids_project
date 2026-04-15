
---

# 📄 README — Differences Between Versions

```markdown
# Comparison — File Integrity Monitor (v1 vs v2)

## Overview
Both scripts monitor SUID file integrity using hashing and a baseline approach.

However, they differ in how they analyze changes.

---

## Key Differences

### 1. Analysis Method
- **v1**: Uses `diff` → global comparison
- **v2**: Analyzes each file individually

👉 v1 tells you "something changed"  
👉 v2 tells you exactly *what changed*

---

### 2. Detection Capabilities

| Feature          | v1 | v2 |
|------------------|----|----|
| Detect changes   | ✅ | ✅ |
| Detect new files | ❌ | ✅ |
| Detect modified files | ⚠️ (not precise) | ✅ |
| Detect deleted files | ❌ | ✅ |

---

### 3. Output Quality
- **v1**: Basic alert, low detail
- **v2**: Detailed alerts with context

---

### 4. Logging
- **v1**: Logs generic "integrity change"
- **v2**: Logs:
  - New file
  - Modified file
  - Deleted file

---

### 5. Complexity
- **v1**: Simple and fast
- **v2**: More complex but more accurate

---

## When to use each version

### Use v1 if:
- You want a quick integrity check
- You prioritize simplicity

### Use v2 if:
- You need real security monitoring
- You want actionable alerts
- You are doing incident analysis

---

## Conclusion
Version 1 is a basic proof of concept.

Version 2 is a more complete and realistic file integrity monitoring tool, suitable for cybersecurity use cases.
