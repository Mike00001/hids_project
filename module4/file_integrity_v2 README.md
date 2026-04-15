
---

# 📄 README — Version 2 (Advanced)

(Projet : :contentReference[oaicite:1]{index=1})

```markdown
# File Integrity Monitor — Advanced Version

## Overview
This script provides a more precise integrity monitoring of SUID files.

Instead of a global diff, it analyzes each file individually to detect:
- New files
- Modified files
- Deleted files

## How it works
1. Scan all SUID files in `/usr/bin`
2. Generate SHA256 hashes
3. Create baseline if it does not exist
4. Compare each file with baseline:
   - Detect new files
   - Detect hash changes
5. Check for deleted files

## Features
- Fine-grained analysis
- Detection of:
  - New SUID files
  - Modified files (hash change)
  - Deleted files
- More informative alerts
- Structured logging

## Usage
```bash
chmod +x file_integrity_v2.sh
./file_integrity_v2.sh
