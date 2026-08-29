# Raspberry Pi 4 Docker Compose Collection

Welcome to the Raspberry Pi 4 Docker Compose Collection! This repository contains a set of Docker Compose files tailored for running various services on a Raspberry Pi 4. Instead of manually configuring each service, these Docker Compose files provide a streamlined and reproducible way to set up your desired services.

## Prerequisites

Before you begin, ensure that you have the following:

- Raspberry Pi 4 with Docker installed
- Docker Compose installed on your Raspberry Pi
- Basic familiarity with Docker and Docker Compose

## Operations

Active Compose services use `restart: always` so a container that was manually
stopped is started again when the Docker daemon comes back after a server reboot.
After changing a Compose file, recreate that stack once with its normal deployment
variables so the new restart policy and image tag are applied to existing
containers.

Most active non-Pomi stacks use versioned image tags. A major tag is used when the
publisher provides one; otherwise the broadest valid stable release tag is used.
When a numeric major tag exists, it floats within that major so Watchtower can
apply compatible minor and bug-fix releases without crossing a breaking major.
Some publishers only publish exact, calendar-based, compound, or minor release
tags; those tags are retained when a usable floating major tag is not published.
Immich is pinned to its current `v3` major tag, BookOrbit directly uses
`ghcr.io/bookorbit/bookorbit:latest`, and the custom `william-automation-cron`
image currently exposes only the unqualified/latest tag; these exceptions are
intentionally reported by the monthly image review. The archived stacks under
`archive/` and the Pomi stack are outside this image-tag policy.

Docker Compose has no elapsed-time limit for a restart loop. `on-failure:N` can cap
failed restart attempts, but it is not a five-to-ten-minute timer and would not
preserve the desired recovery behavior after a manually stopped container. An
exact time-based breaker requires a host-level watchdog; the Compose policies stay
`restart: always` until such a watchdog is installed on the server.

## Contributing

If you have improvements or additional Docker Compose files for other services, contributions are welcome! Please fork this repository, make your changes, and submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE), which means you are free to use, modify, and distribute the code. See the [LICENSE](LICENSE) file for details.

Happy coding! 🚀
