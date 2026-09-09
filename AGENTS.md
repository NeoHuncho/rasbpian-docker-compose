# Repository instructions

- For Docker maintenance, follow `skills/docker-small-updates/SKILL.md`. Updates of any version size on `william@192.168.68.54` are authorized after online verification establishes no applicable breaking change or manual migration; verify Docker/application health afterward. Explain required migrations simply instead of applying breaking updates.
- Exclude `pomi/`, `archive/`, `william-automation-cron/`, `overseerr/`, `file-browser/`, and all of `grafana-loki/` from maintenance; honor `# codex-maintenance: ignore` markers.

- Keep each service self-contained in its `docker-compose.yml`.
- Declare the service's environment variables directly in Compose `environment:` blocks. Do not add or reference separate `.env`, `docker.env`, or `env_file` files for service configuration.
- Use Compose variable interpolation for secrets and deployment-specific values when needed, and document the expected variable names beside the service configuration.
