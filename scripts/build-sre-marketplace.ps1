#Requires -Version 7.4
param([switch]$Check)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$utf8 = [System.Text.UTF8Encoding]::new($false)
$expected = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
$domains = @('apex', 'db', 'fusion', 'graal', 'oci')
$entries = [System.Collections.Generic.List[object]]::new()
$problems = [System.Collections.Generic.List[string]]::new()

function Get-RepoPath([string]$Path) {
    Join-Path $root ($Path.Replace('/', [IO.Path]::DirectorySeparatorChar))
}

function Write-PackageFile([string]$Path, [byte[]]$Bytes) {
    if (!$expected.Add($Path)) { throw "Duplicate output path: $Path" }
    $target = Get-RepoPath $Path
    if ([IO.File]::Exists($target)) {
        $existing = [IO.File]::ReadAllBytes($target)
        if ([Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($existing)) -ceq
            [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($Bytes))) { return }
    }
    if ($Check) {
        $problems.Add("Missing or out of date: $Path")
        return
    }
    $null = [IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($target))
    [IO.File]::WriteAllBytes($target, $Bytes)
}

function Write-PackageJson([string]$Path, [System.Collections.IDictionary]$Data) {
    $json = ($Data | ConvertTo-Json -Depth 6) -replace "`r`n", "`n"
    Write-PackageFile $Path ($utf8.GetBytes("$json`n"))
}

function Copy-SkillFiles([string]$Prefix, [string]$Target) {
    foreach ($file in $sourceFiles) {
        if (!$file.StartsWith($Prefix, [StringComparison]::Ordinal)) { continue }
        $source = Get-RepoPath $file
        $destination = "$Target/$($file.Substring($Prefix.Length))"
        Write-PackageFile $destination ([IO.File]::ReadAllBytes($source))
        if (!$Check -and !$IsWindows) {
            [IO.File]::SetUnixFileMode((Get-RepoPath $destination), [IO.File]::GetUnixFileMode($source))
        }
    }
}

$sourceFiles = @(git --no-pager -C $root -c core.quotepath=false ls-files --cached --others --exclude-standard -- $domains | Sort-Object -Unique)
if ($LASTEXITCODE -ne 0) { throw 'Unable to list skill sources.' }
foreach ($domain in $domains) {
    $file = "$domain/SKILL.md"
    $frontmatter = [regex]::Match([IO.File]::ReadAllText((Get-RepoPath $file)), '\A---\r?\n(.*?)\r?\n---(?:\r?\n|\z)', 'Singleline')
    $name = [regex]::Match($frontmatter.Groups[1].Value, '(?m)^name:[ \t]*([a-z0-9]+(?:-[a-z0-9]+)*)[ \t]*\r?$').Groups[1].Value
    $description = [regex]::Match($frontmatter.Groups[1].Value, '(?m)^description:[ \t]*(\S[^\r\n]*)').Groups[1].Value.Trim().Trim('"', "'")
    if ($name -cne $domain -or !$description -or $description -match '^[>|]') {
        throw "Expected skill name '$domain' and a single-line description in $file"
    }

    $plugin = "plugins/oracle-$name"
    $skill = "$plugin/skills/$name"
    Write-PackageJson "$plugin/plugin.json" ([ordered]@{ name = $name; description = $description; skills = @('skills/') })
    Copy-SkillFiles "$domain/" $skill
    $entries.Add([ordered]@{ name = $name; description = $description; source = "./$plugin" })
}

Write-PackageJson '.github/plugin/marketplace.json' ([ordered]@{
    name = 'oracle-skills'
    owner = [ordered]@{ name = 'Oracle' }
    metadata = [ordered]@{ description = 'Oracle domain skills for Azure SRE Agent.' }
    plugins = $entries.ToArray()
})

foreach ($file in Get-ChildItem -LiteralPath (Get-RepoPath 'plugins') -File -Force -Recurse) {
    $relative = [IO.Path]::GetRelativePath($root, $file.FullName).Replace('\', '/')
    if (!$expected.Contains($relative)) { $problems.Add("Unexpected package file (remove explicitly): $relative") }
}
if ($problems.Count) { throw ($problems -join "`n") }

Write-Output "SRE marketplace: $($entries.Count) individual plugins and $($expected.Count) package files verified."
