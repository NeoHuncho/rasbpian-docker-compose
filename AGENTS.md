# Repository instructions

- Keep each service self-contained in its `docker-compose.yml`.
- Declare the service's environment variables directly in Compose `environment:` blocks. Do not add or reference separate `.env`, `docker.env`, or `env_file` files for service configuration.
- Use Compose variable interpolation for secrets and deployment-specific values when needed, and document the expected variable names beside the service configuration.
