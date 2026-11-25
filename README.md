# Oracle Skills

Oracle Skills is a collection of practical, installable skills for working with Oracle technologies.

The goal is to give developers and agents a single place to find source-backed Oracle guidance across Oracle Database, Oracle Cloud Infrastructure, GraalVM, Oracle Fusion, Oracle APEX, and future domains.

## Installation

In Azure SRE Agent, open **Plugins > Manage marketplaces** and add the GitHub
repository URL. Choose **db**, **apex**, **fusion**, **graal**, or **oci**, confirm
that the domain skill is listed, and select **Install**. Nested guides like Data
Guard are included in their domain package and are not installed separately.

The [marketplace manifest](./.github/plugin/marketplace.json) and packages under
[`plugins/`](./plugins/) are generated. Edit the source files in the top-level
domain directories, then run these commands with PowerShell 7.4 or later and
commit the generated files:

```powershell
pwsh -File .\scripts\build-sre-marketplace.ps1
pwsh -File .\scripts\build-sre-marketplace.ps1 -Check
```

If a skill or supporting file was renamed or removed, the script reports obsolete
package files. Remove those files explicitly, then rerun the check. Refresh the
marketplace in SRE Agent after publishing a change.

## Repository Goals

- Provide Oracle-wide skills in one repository.
- Define domain entry points that help developers and agents route to the right topic quickly.
- Keep each skill practical, source-backed, and easy to consume on demand.
- Allow each domain to evolve its own taxonomy without breaking repo-wide consistency.

## Domains

- `db/` is the active Oracle Database domain and includes database, ORDS, SQLcl, VecDB, framework, container, and agent workflow skills.
- `oci/` contains Oracle Cloud Infrastructure skills, including OCI Functions deployment and troubleshooting, OCI Kubernetes Engine cluster design and troubleshooting, OCI IoT Platform digital twin workflows, plus Enterprise AI guidance for OCI Generative AI, agents, RAG, governance, model endpoints, Autonomous Database, APEX, and integrations.
- `fusion/` is the root for future Oracle Fusion skills.
- `apex/` is the root for future Oracle APEX skills.
- `graal/` contains GraalVM skills, starting with Native Image.

## Start Here

1. Pick the skill closest to your task.
2. Install that skill from the SRE Agent marketplace.
3. Add other skills only when needed.

## Repository Layout

```text
.
├── db/
│   ├── SKILL.md
│   ├── admin/
│   ├── agent/
│   ├── appdev/
│   ├── architecture/
│   ├── containers/
│   ├── design/
│   ├── devops/
│   ├── features/
│   ├── frameworks/
│   ├── migrations/
│   ├── monitoring/
│   ├── ords/
│   ├── performance/
│   ├── plsql/
│   ├── security/
│   ├── sql-dev/
│   ├── sqlcl/
│   └── vecdb/
├── fusion/
│   └── SKILL.md
├── apex/
│   └── SKILL.md
├── graal/
│   ├── SKILL.md
│   └── native-image/
│       ├── build-native-image.md
│       ├── native-build-tools.md
│       ├── reachability-metadata.md
│       └── troubleshooting.md
└── oci/
    ├── SKILL.md
    ├── enterprise-ai/
    │   ├── SKILL.md
    │   ├── models/
    │   ├── agent-workflows/
    │   ├── governance/
    │   ├── data/
    │   ├── cost/
    │   └── integrations/
    ├── functions/
    │   ├── oci-functions-deploy/
    │   └── oci-functions-troubleshoot/
    ├── iot-platform/
    │   ├── SKILL.md
    │   ├── agents/
    │   ├── references/
    │   ├── scripts/
    │   ├── templates/
    │   └── tests/
    └── oke/
        ├── cluster-design.md
        ├── troubleshooting.md
        ├── gva-node-pools.md
        ├── multus-multihome.md
        ├── skills/
        ├── scripts/
        ├── agents/
        ├── shared/
        ├── examples/
        └── tests/
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
