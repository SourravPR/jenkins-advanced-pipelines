# Jenkins Advanced Pipelines: Terraform Drift Remediation & Docker Hardening

Ready-to-run Windows PowerShell-compatible Jenkins pipelines for DevOps classroom demonstration.

## Folder Structure
- `terraform/` - AWS EC2 + Security Group baseline with dynamic `tls_private_key` (no Windows `local_file` lock issues).
- `app/` - Node.js service with `Dockerfile.vulnerable` vs `Dockerfile.hardened` (multi-stage Alpine, non-root `node` user, stripped `npm`/`npx`, healthcheck).
- `pipelines/Jenkinsfile.drift` - Automated Terraform drift detection (`-detailed-exitcode`) & auto-remediation pipeline.
- `pipelines/Jenkinsfile.hardened-build` - Multi-stage Docker build, image size comparison, UID/root audit, and read-only runtime test pipeline.
