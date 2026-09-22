# patch-header-fix.ps1
$ErrorActionPreference = "Stop"

Write-Host "Starting patch for header school title and logo sizing..." -ForegroundColor Cyan

# 1. Patch styles.css
$cssPath = "styles.css"
if (Test-Path $cssPath) {
    $css = Get-Content $cssPath -Raw

    # Ensure school-title has proper web-safe fallback font stack
    $css = $css -replace "font-family:\s*var\(--font-display\);", "font-family: var(--font-display), 'Georgia', 'Times New Roman', serif;"

    # Lock logo container and text container properties
    $customCssPatch = @"

/* === Automated Header Alignment & Fix Patch === */
.header-top__logo a {
  display: inline-block !important;
  width: 120px !important;
  height: 120px !important;
  flex-shrink: 0 !important;
}

.header-top__logo img {
  width: 120px !important;
  height: 120px !important;
  max-width: none !important;
  object-fit: contain !important;
  display: block !important;
}

.header-top__text {
  min-width: 0 !important;
  overflow: visible !important;
}

.school-title {
  display: block !important;
  visibility: visible !important;
  opacity: 1 !important;
}
"@

    if (-not ($css -like "*Automated Header Alignment & Fix Patch*")) {
        Add-Content -Path $cssPath -Value "`n$customCssPatch"
        Write-Host "Updated: $cssPath" -ForegroundColor Green
    } else {
        Write-Host "$cssPath already contains patch styles." -ForegroundColor Yellow
    }
} else {
    Write-Warning "styles.css not found in current directory."
}

# 2. Patch index.html logo inline styles to match header.html
$indexPath = "index.html"
if (Test-Path $indexPath) {
    $indexHtml = Get-Content $indexPath -Raw
    $targetOldLogo = '<img src="images/logo.webp" alt="Shalom International School crest and emblem" width="120" height="120" fetchpriority="high" loading="eager" style="width: 120px; height: 120px; object-fit: contain; display: block;">'
    $targetNewLogo = '<img src="images/logo.webp" alt="Shalom International School crest and emblem" width="120" height="120" fetchpriority="high" loading="eager" style="width: 120px !important; height: 120px !important; max-width: none !important; object-fit: contain; display: block;">'

    if ($indexHtml.Contains($targetOldLogo)) {
        $indexHtml = $indexHtml.Replace($targetOldLogo, $targetNewLogo)
        Set-Content -Path $indexPath -Value $indexHtml -Encoding UTF8
        Write-Host "Updated: index.html logo inline styles matched to header.html." -ForegroundColor Green
    } else {
        Write-Host "index.html logo tag already modified or pattern didn't match directly." -ForegroundColor Yellow
    }
}

Write-Host "Patch complete! Clear browser cache (Ctrl + F5) to preview." -ForegroundColor Cyan