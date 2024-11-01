## Description: Explains the tool’s purpose and typical use cases.
- User checks SUID permissions on linux machine. Copy output into script. Tells user if there is an interesting SUID that is in GTFOBins.
## Usage Instructions: Provides command-line syntax and usage examples.
- On target linux machine, run: find / -type f -perm -04000 -ls 2>/dev/null
- Copy entire output. Run script: ./GTFOBins_SUID.py
- Paste the entire SUID output.
- If script returns an output, then check GTFOBins for escalation steps.
## Dependencies: Lists required packages and modules, if any.
- python3