# Oracle Skills

Oracle Skills is a collection of practical, installable skills for working with Oracle technologies.

The goal is to give developers and agents a single place to find source-backed Oracle guidance across Oracle Database, Oracle Cloud Infrastructure, GraalVM, Oracle Fusion, Oracle APEX, and future domains.

## Installation

In Azure SRE Agent, open **Plugins > Manage marketplaces** and add the GitHub
repository URL. Choose **db**, **apex**, **fusion**, **graal**, or **oci**, confirm
that the domain skill is listed, and select **Install**. Nested guides like Data
Guard are included in their domain package and are not installed separately.

To install all five together, use **Install GitHub plugin** with the repository
URL and leave **Path in repo** blank. The [root plugin manifest](./plugin.json)
uses the same skill directories as the [marketplace](./.github/plugin/marketplace.json).

Edit skills directly under [`plugins/`](./plugins/); there is no separate source
copy or generation step. Refresh the marketplace after publishing changes.

## Repository Goals

- Provide Oracle-wide skills in one repository.
- Define domain entry points that help developers and agents route to the right topic quickly.
- Keep each skill practical, source-backed, and easy to consume on demand.
- Allow each domain to evolve its own taxonomy without breaking repo-wide consistency.

## Domains

- [db](./plugins/oracle-db/skills/db/) includes Oracle Database, ORDS, SQLcl, VecDB, framework, container, and agent workflow guidance.
- [oci](./plugins/oracle-oci/skills/oci/) covers OCI Functions, Kubernetes Engine, IoT Platform, and Enterprise AI.
- [fusion](./plugins/oracle-fusion/skills/fusion/) is a placeholder for future Oracle Fusion guidance.
- [apex](./plugins/oracle-apex/skills/apex/) covers Oracle APEX application development.
- [graal](./plugins/oracle-graal/skills/graal/) covers GraalVM Native Image.

## Start Here

1. Pick the skill closest to your task.
2. Install that skill from the SRE Agent marketplace.
3. Add other skills only when needed.

## Repository Layout

```text
.
├── .github/plugin/marketplace.json
├── plugin.json
└── plugins/
    ├── oracle-apex/
    ├── oracle-db/
    │   ├── plugin.json
    │   └── skills/db/
    │       ├── SKILL.md
    │       └── ... (supporting files)
    ├── oracle-fusion/
    ├── oracle-graal/
    └── oracle-oci/
```

Each domain has its own `SKILL.md` and any supporting index files it needs.

For a real domain, organize content by category directories and use `SKILL.md` as the table of contents. A domain `SKILL.md` should normally include:

- `## How to Use This Domain`
- `## Directory Structure`
- `## Category Routing`
- `## Key Starting Points`
- `## Common Multi-Step Flows`

For stub domains, keep `SKILL.md` minimal and point users back to this `README.md` and `SKILL_AUTHORING_GUIDE.md`.

## Version Coverage Standard

- Skills that include version-specific behavior must include a section named `## Oracle Version Notes (19c vs 26ai)`.
- Use Oracle Database 19c as the baseline compatibility target unless stated otherwise.
- Explicitly call out features that require newer releases and provide 19c-compatible alternatives where practical.

## Sources

- https://docs.oracle.com/en-us/iaas/Content/ContEng/home.htm
- https://docs.oracle.com/en-us/iaas/Content/internet-of-things/home.htm
- https://github.com/oracle-samples/oci-iot-samples
- https://www.graalvm.org/latest/reference-manual/native-image/
