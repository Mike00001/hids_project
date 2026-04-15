# File Integrity Monitor — Basic Version

## Overview
This script monitors the integrity of SUID files on the system.

It creates a baseline of file hashes and compares future scans against it to detect any changes.

## How it works
1. Scan all SUID files in `/usr/bin`
2. Generate SHA256 hashes
3. Store results in a baseline file (first run)
4. Compare current scan with baseline
5. Trigger alert if differences are found

## Features
- Simple baseline creation
- Global comparison using `diff`
- Logging of critical changes
- Lightweight and easy to use

## Usage
```bash
chmod +x file_integrity.sh
./file_integrity.sh
