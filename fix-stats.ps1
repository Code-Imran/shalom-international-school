<#
.SYNOPSIS
  Adds the missing .stats section CSS to styles.css, matching the
  .feature-strip card style (accent top-border, shadow) but for
  the number+label stat cards on the homepage.

.USAGE
  Run from inside your site's root folder (where styles.css lives).
    powershell -ExecutionPolicy Bypass -File .\fix-stats.ps1
#>

$ErrorActionPreference = "Stop"

$cssPath = ".\styles.css"

if (-not (Test-Path $cssPath)) {
    Write-Host "!! Could not find $cssPath - make sure you're running this from your site's root folder."
    exit 1
}

$css = Get-Content $cssPath -Raw

if ($css -match "\.stat__num\s*\{") {
    Write-Host "-- styles.css already has .stats styling, skipping."
    exit 0
}

$statsBlock = @"


.stats {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 2rem;
  max-width: var(--container-width);
  margin: 3rem auto;
  padding: 0 1.5rem;
}
.stat {
  padding: 1.75rem 1.5rem;
  text-align: center;
  border: 1px solid #eadfca;
  border-top: 3px solid var(--color-accent);
  background: #fff;
  box-shadow: 0 8px 22px rgba(68, 6, 6, .07);
}
.stat__num {
  display: block;
  font-family: var(--font-body);
  font-size: 2.5rem;
  font-weight: 700;
  color: var(--color-primary);
  line-height: 1.1;
  margin-bottom: .5rem;
}
.stat__label {
  display: block;
  font-size: .9rem;
  color: #555;
  line-height: 1.4;
}
"@

$anchor = '.feature-strip__icon { display: grid; place-items: center; width: 2.7rem; height: 2.7rem; margin-bottom: .8rem; border-radius: 50%; background: var(--color-primary); color: #fff; font-size: 1.35rem; }'

if ($css -match [regex]::Escape($anchor)) {
    $newCss = $css -replace [regex]::Escape($anchor), ($anchor + $statsBlock)
    Set-Content -Path $cssPath -Value $newCss -NoNewline
    Write-Host "-- styles.css patched: .stats block inserted after .feature-strip__icon."
} else {
    # Fallback: just append to the end of the file, still valid CSS regardless of position
    Add-Content -Path $cssPath -Value $statsBlock
    Write-Host "-- Anchor rule not found exactly as expected - appended .stats block to the end of styles.css instead (still works)."
}

Write-Host ""
Write-Host "==> Done. Now test locally:"
Write-Host "      python -m http.server 8000"
Write-Host "    Check the homepage stats section, then commit and push (or run Deploy Website.bat)."