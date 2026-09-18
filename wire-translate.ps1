<#
.SYNOPSIS
  Wires up Google Translate for the language dropdown:
    1. Patches js/main.js to hook the data-lang links to Google Translate
    2. Appends hiding CSS to styles.css
    3. Inserts the Google Translate loader script into every .html page

.USAGE
  Run this from inside your site's root folder (where index.html, js/, styles.css live).
    powershell -ExecutionPolicy Bypass -File .\wire-translate.ps1
#>

$ErrorActionPreference = "Stop"

Write-Host "==> Starting Google Translate wiring..."

# ---------------------------------------------------------------------
# 1. Patch js/main.js
# ---------------------------------------------------------------------
$mainJsPath = ".\js\main.js"
if (-not (Test-Path $mainJsPath)) {
    Write-Host "!! Could not find $mainJsPath - aborting main.js patch."
} else {
    $mainJs = Get-Content $mainJsPath -Raw

    if ($mainJs -match "googleTranslateElementInit") {
        Write-Host "-- js/main.js already patched, skipping."
    } else {
        # Match the whole "Language dropdown" comment block up to (but not including)
        # the next "/* ====" section comment, and replace it entirely.
        $pattern = '(?s)/\*\s*=+\s*\r?\n\s*Language dropdown\s*\r?\n\s*=+\s*\*/.*?(?=\r?\n/\*\s*=+)'

        $replacement = @'
/* ============================================================
   Language dropdown + Google Translate
   ============================================================ */
const langBtn = document.getElementById('langBtn');
const langMenu = document.getElementById('langMenu');
if (langBtn && langMenu) {
  langBtn.addEventListener('click', (e) => {
    e.stopPropagation();
    const open = langMenu.classList.toggle('is-open');
    langBtn.setAttribute('aria-expanded', open);
  });
  document.addEventListener('click', () => {
    langMenu.classList.remove('is-open');
    langBtn.setAttribute('aria-expanded', 'false');
  });
}

// Wire up the language links to Google Translate
function changeLanguage(langCode) {
  const select = document.querySelector('#google_translate_element select.goog-te-combo');
  if (select) {
    select.value = langCode;
    select.dispatchEvent(new Event('change'));
  } else {
    document.cookie = `googtrans=/en/${langCode}; path=/`;
    document.cookie = `googtrans=/en/${langCode}; domain=.${location.hostname}; path=/`;
    location.reload();
  }
}

document.querySelectorAll('.lang-select__menu a[data-lang]').forEach((link) => {
  link.addEventListener('click', (e) => {
    e.preventDefault();
    changeLanguage(link.getAttribute('data-lang'));
    if (langMenu) langMenu.classList.remove('is-open');
    if (langBtn) langBtn.setAttribute('aria-expanded', 'false');
  });
});

window.googleTranslateElementInit = function () {
  new google.translate.TranslateElement(
    {
      pageLanguage: 'en',
      includedLanguages: 'en,mr,hi',
      layout: google.translate.TranslateElement.InlineLayout.SIMPLE,
      autoDisplay: false,
    },
    'google_translate_element'
  );
};
'@

        if ($mainJs -match $pattern) {
            $newMainJs = [regex]::Replace($mainJs, $pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $replacement }, 1)
            Set-Content -Path $mainJsPath -Value $newMainJs -NoNewline
            Write-Host "-- js/main.js patched successfully."
        } else {
            Write-Host "!! Could not find the 'Language dropdown' block in main.js automatically."
            Write-Host "   Appending the new logic to the end of the file instead (safe, won't break anything)."
            Add-Content -Path $mainJsPath -Value "`n$replacement"
        }
    }
}

# ---------------------------------------------------------------------
# 2. Append CSS to styles.css
# ---------------------------------------------------------------------
$cssPath = ".\styles.css"
if (-not (Test-Path $cssPath)) {
    Write-Host "!! Could not find $cssPath - aborting CSS patch."
} else {
    $css = Get-Content $cssPath -Raw
    if ($css -match "goog-te-banner-frame") {
        Write-Host "-- styles.css already patched, skipping."
    } else {
        $cssBlock = @"

/* Google Translate widget hiding (added by wire-translate.ps1) */
#google_translate_element { display: none !important; }
.goog-te-banner-frame { display: none !important; }
body { top: 0 !important; }
.goog-tooltip, .goog-tooltip:hover { display: none !important; }
.goog-text-highlight { background: none !important; box-shadow: none !important; }
"@
        Add-Content -Path $cssPath -Value $cssBlock
        Write-Host "-- styles.css patched successfully."
    }
}

# ---------------------------------------------------------------------
# 3. Insert Google Translate loader script into every HTML page
# ---------------------------------------------------------------------
Write-Host "==> Patching HTML pages..."
$htmlFiles = Get-ChildItem -Filter *.html -File
$loaderTag = '<script src="https://translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>'

foreach ($file in $htmlFiles) {
    $content = Get-Content $file.FullName -Raw
    if ($content -match [regex]::Escape("translate_a/element.js")) {
        Write-Host "-- $($file.Name) already has the loader script, skipping."
        continue
    }

    if ($content -match '<script src="js/main\.js"></script>') {
        $newContent = $content -replace '(<script src="js/main\.js"></script>)', ('$1' + "`r`n" + $loaderTag)
        Set-Content -Path $file.FullName -Value $newContent -NoNewline
        Write-Host "-- $($file.Name) patched."
    } else {
        # Fallback: insert right before </body>
        $newContent = $content -replace '(</body>)', ($loaderTag + "`r`n" + '$1')
        Set-Content -Path $file.FullName -Value $newContent -NoNewline
        Write-Host "-- $($file.Name) patched (fallback: inserted before </body>)."
    }
}

Write-Host ""
Write-Host "==> Done. Now test locally:"
Write-Host "      python -m http.server 8000"
Write-Host "    Open http://localhost:8000, click the language dropdown, and confirm it translates."
Write-Host "    Then: git add . ; git commit -m 'Wire up Google Translate' ; git push"
