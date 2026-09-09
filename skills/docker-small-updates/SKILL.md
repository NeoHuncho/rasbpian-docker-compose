---
name: docker-small-updates
description: Review Docker upgrades online, apply compatible releases regardless of version size on coprin over SSH, and explain required migrations.
---

Connect with `ssh william@192.168.68.54`. The user authorizes recurring compatible stable updates including major and calendar releases, Compose tag edits, image pulls, and targeted recreation with verification. Version size alone is not an approval gate. Do not commit or push unless requested.

Exclude `pomi/`, `archive/`, `william-automation-cron/`, `overseerr/`, `file-browser/`, and the entire `grafana-loki/` stack including Promtail. Honor `# codex-maintenance: ignore`. These exclusions apply to this maintenance workflow, not independent Watchtower settings. Do not update host-only stacks absent from the repository.

Check repository status, live versions/digests, health and restart counts first. Verify current registry tags and official publisher release notes, upgrade guides and compatibility requirements online for every candidate. Cover all intervening releases from the running version to the target, including supported upgrade paths and dependent database/extension versions. Watchtower may have already updated floating tags; skip current services.

Apply any stable upgrade, including major, calendar and database-related releases, when the documented upgrade path has no applicable breaking changes or manual migration and compatibility with this deployment is established. Assess documented changes against actual configuration and integrations without exposing secrets. Do not infer compatibility merely from a missing breaking-changes heading or an unchanged major number. Normal publisher-supported automatic migrations may proceed with the backup and recovery safeguards below.

If a breaking change or manual migration applies, leave the affected service unchanged and explain simply what must change, the migration order, backup/recovery requirements and how to verify success, with an official source link. If applicability or compatibility cannot be verified, report the exact uncertainty and required check rather than upgrading speculatively. Continue independent compatible upgrades. Do not report an upgrade solely because it crosses a major version.

Resolve project, service, configuration files and deployment environment from container Compose labels. Verify Portainer's `/data` mapping to `/var/lib/docker-volumes/portainer-data`. Preserve existing environment values without printing secrets. Mirror only accepted image edits between repository and deployed configuration; do not overwrite unrelated differences or introduce repository env files.

Record previous image IDs and save protected copies of deployed Compose before mutation. Retain old images and persistent data. Applications that migrate data need a verified restorable backup and release-specific recovery plan; image rollback does not undo migrations.

## Backup location and retention

Store all new maintenance backups on coprin (`192.168.68.54`) under `/var/lib/docker-volumes/maintenance-backups/`, including Compose copies, database dumps and application-data archives. Use a unique UTC timestamp and service name for each subdirectory (`YYYY-MM-DDTHHMMSSZ-service`); never overwrite an existing backup. Keep the backup root and run directories private (0700) and backup files protected (0600). Exclude this backup root from recursive source archives. Record a protected manifest with timestamp, service, source data/configuration paths, previous image IDs, backup contents, restore procedure and verification results; do not print secrets.

On every monthly run, inventory backups from previous runs with exact paths, dates and sizes. After completing the maintenance checks and verifying any new backups and updated services, ask the user whether to delete the explicitly listed older backups. Ask even if no upgrade was needed. Never automatically delete backups based on age, silence or a timeout: retain them unless the user explicitly approves the exact targets. Keep the newest recovery set and anything needed for an unresolved migration or failure; if no safe cleanup is possible, explain why. Revalidate approved paths before deletion, never delete the backup root, and report what was removed.

Retained original database directories from migrations are separate rollback data, not ordinary backup archives. Record their locations and do not move or delete them under a backup-cleanup approval; request separate explicit approval. Existing legacy backups outside the canonical root remain untouched unless relocation or cleanup is specifically authorized.

## Deployment and verification

Validate Compose using existing deployment values without printing resolved configuration. Pull the accepted image and recreate only its intended service with `up -d --no-deps`, preserving project name, relative mount resolution and overrides. No whole-host refresh, prune, volume deletion or unrelated configuration changes.

Verify intended running image ID, healthcheck, stable restart count, recent startup logs and a service-specific probe. Cloudflared must register tunnel connections; web apps must answer an appropriate health endpoint or HTTP probe. Redact credentials in logs. Observe again after at least 60 seconds. Running alone is not success. Stop further updates on failure; restore the prior image/config only if data compatibility permits, otherwise report recovery requirements.

Report completed updates with verification and remaining actionable decisions only. Record versions, outcomes, exclusions and time in automation memory. Never equate local validation with successful deployment.
