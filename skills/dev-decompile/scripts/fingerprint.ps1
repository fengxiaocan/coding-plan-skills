# fingerprint.ps1 — Triage an APK/XAPK before decompiling on Windows.
param(
    [Parameter(Position=0)]
    [string]$InputFile,
    [Alias('h')]
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

function Show-Usage {
    Write-Host @"
Usage: fingerprint.ps1 <file.apk|file.xapk>

Prints a one-screen summary:
  * Mobile framework (Flutter / React Native / Cordova / Xamarin / Native)
  * HTTP / DI / serialization stack hints
  * Obfuscation indicator
  * Native libraries (consolidated across split APKs)
  * Notable third-party SDKs
  * Recommended next step
"@
    exit 0
}

if ($Help -or -not $InputFile) { Show-Usage }

if (-not (Test-Path $InputFile)) {
    Write-Host "Error: File not found: $InputFile" -ForegroundColor Red
    exit 1
}

Add-Type -AssemblyName System.IO.Compression.FileSystem

$inputFileAbs = (Resolve-Path $InputFile).Path
$extLower = [IO.Path]::GetExtension($inputFileAbs).TrimStart('.').ToLower()

$tempDir = Join-Path $env:TEMP "apkfp_$(Get-Random)"
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

try {
    $apkPaths = @()
    if ($extLower -in @('xapk', 'apks', 'apkm', 'zip')) {
        $xapkDir = Join-Path $tempDir "unpacked"
        [System.IO.Compression.ZipFile]::ExtractToDirectory($inputFileAbs, $xapkDir)
        $apkPaths = Get-ChildItem -Path $xapkDir -Filter "*.apk" -Recurse | Select-Object -ExpandProperty FullName
    } elseif ($extLower -eq 'apk') {
        $apkPaths = @($inputFileAbs)
    } else {
        Write-Host "Error: Unsupported file type: .$extLower" -ForegroundColor Red
        exit 1
    }

    $allEntries = [System.Collections.Generic.HashSet[string]]::new()
    $dexStrings = [System.Collections.Generic.HashSet[string]]::new()

    foreach ($apk in $apkPaths) {
        $zip = [System.IO.Compression.ZipFile]::OpenRead($apk)
        try {
            foreach ($entry in $zip.Entries) {
                [void]$allEntries.Add($entry.FullName)

                if ($entry.FullName -match '^classes\d*\.dex$') {
                    # Fast ASCII string extraction from DEX stream
                    $stream = $entry.Open()
                    $ms = [System.IO.MemoryStream]::new()
                    $stream.CopyTo($ms)
                    $stream.Dispose()
                    $bytes = $ms.ToArray()
                    $ms.Dispose()

                    $sb = [System.Text.StringBuilder]::new()
                    for ($i = 0; $i -lt $bytes.Length; $i++) {
                        $b = $bytes[$i]
                        if ($b -ge 32 -and $b -le 126) {
                            [void]$sb.Append([char]$b)
                        } else {
                            if ($sb.Length -ge 8) {
                                $s = $sb.ToString()
                                if ($s -match 'L[a-zA-Z][a-zA-Z0-9_]*(/[a-zA-Z0-9_$]+)+;') {
                                    $clean = $Matches[0].TrimStart('L').TrimEnd(';')
                                    [void]$dexStrings.Add($clean)
                                }
                            }
                            $sb.Clear()
                        }
                    }
                }
            }
        } finally {
            $zip.Dispose()
        }
    }

    function Has-Pattern([string]$pattern) {
        foreach ($e in $allEntries) {
            if ($e -match $pattern) { return $true }
        }
        foreach ($s in $dexStrings) {
            if ($s -match $pattern) { return $true }
        }
        return $false
    }

    # Framework detection
    $framework = "unknown"
    $rationale = ""

    if (Has-Pattern '^lib/[^/]+/libflutter\.so$') {
        $framework = "Flutter"
        $rationale = "lib/<abi>/libflutter.so present"
        if (Has-Pattern '^lib/[^/]+/libapp\.so$') {
            $rationale += "; libapp.so contains AOT-compiled Dart"
        }
    } elseif (Has-Pattern '^lib/[^/]+/libhermes\.so$' -or Has-Pattern '^assets/index\.android\.bundle$' -or Has-Pattern '^lib/[^/]+/libreactnativejni\.so$') {
        $framework = "React Native"
        $reasons = @()
        if (Has-Pattern '^lib/[^/]+/libhermes\.so$') { $reasons += "libhermes.so" }
        if (Has-Pattern '^lib/[^/]+/libreactnativejni\.so$') { $reasons += "libreactnativejni.so" }
        if (Has-Pattern '^assets/index\.android\.bundle$') { $reasons += "assets/index.android.bundle" }
        $rationale = $reasons -join ", "
    } elseif (Has-Pattern '^assets/www/index\.html$' -or Has-Pattern '^assets/www/cordova\.js$' -or Has-Pattern '^assets/public/index\.html$') {
        $framework = "Cordova / Capacitor (WebView hybrid)"
        $rationale = "assets/www/ or assets/public/ shell present"
    } elseif (Has-Pattern '^lib/[^/]+/libmonodroid\.so$' -or Has-Pattern '^assemblies/') {
        $framework = "Xamarin / .NET MAUI"
        $rationale = "libmonodroid.so or assemblies/ present — code is in .NET DLLs"
    } elseif (Has-Pattern '^lib/[^/]+/libmaui\.so$') {
        $framework = ".NET MAUI"
        $rationale = "libmaui.so present"
    } elseif (Has-Pattern '^assets/flutter_assets/') {
        $framework = "Flutter (code-only split?)"
        $rationale = "flutter_assets/ present but no libflutter.so in this APK"
    } else {
        if (Has-Pattern 'androidx\.compose') {
            $framework = "Native Android (Kotlin + Jetpack Compose)"
            $rationale = "androidx.compose.* libraries detected"
        } elseif (Has-Pattern '^META-INF/.*\.kotlin_module$') {
            $framework = "Native Android (Kotlin)"
            $rationale = "kotlin_module metadata present, no Compose markers"
        } else {
            $framework = "Native Android (Java/Kotlin)"
            $rationale = "no cross-platform framework markers found"
        }
    }

    # HTTP Stack
    $http = @()
    if (Has-Pattern 'retrofit2') { $http += "Retrofit" }
    if (Has-Pattern 'okhttp3') { $http += "OkHttp" }
    if (Has-Pattern 'io/ktor/') { $http += "Ktor" }
    if (Has-Pattern 'com/apollographql/') { $http += "Apollo (GraphQL)" }
    if (Has-Pattern 'com/android/volley') { $http += "Volley" }

    # DI
    $di = @()
    if (Has-Pattern 'dagger/hilt/') { $di += "Hilt" }
    if (Has-Pattern 'META-INF/.*dagger.*') { $di += "Dagger" }
    if (Has-Pattern 'org/koin/') { $di += "Koin" }
    if (Has-Pattern 'javax/inject/' -and $di.Count -eq 0) { $di += "javax.inject" }

    # Serialization
    $ser = @()
    if (Has-Pattern 'kotlinx/serialization/') { $ser += "kotlinx.serialization" }
    if (Has-Pattern 'com/google/gson/') { $ser += "Gson" }
    if (Has-Pattern 'com/squareup/moshi/') { $ser += "Moshi" }
    if (Has-Pattern 'com/fasterxml/jackson/') { $ser += "Jackson" }

    # Obfuscation indicator
    $shortDirs = [System.Collections.Generic.HashSet[string]]::new()
    foreach ($e in $allEntries) {
        if ($e -match '^[a-z]{1,2}/') {
            [void]$shortDirs.Add($Matches[0])
        }
    }
    $shortCount = $shortDirs.Count
    if ($shortCount -gt 30) {
        $obfuscation = "HIGH ($shortCount single/double-letter dirs at root)"
    } elseif ($shortCount -gt 10) {
        $obfuscation = "MODERATE ($shortCount short root dirs)"
    } else {
        $obfuscation = "LOW (no significant short-name namespace pollution)"
    }

    # Native libraries
    $nativeLibs = @()
    foreach ($e in $allEntries) {
        if ($e -match '^lib/[^/]+/[^/]+\.so$') {
            $nativeLibs += $e
        }
    }
    $nativeLibs = $nativeLibs | Sort-Object -Unique

    # Third-party SDKs
    $sdks = @()
    if (Has-Pattern '^assets/com/appsflyer/') { $sdks += "AppsFlyer" }
    if (Has-Pattern 'datadog\.buildId|com/datadog/') { $sdks += "Datadog" }
    if (Has-Pattern 'io/sentry/') { $sdks += "Sentry" }
    if (Has-Pattern 'com/google/firebase/') { $sdks += "Firebase" }
    if (Has-Pattern 'com/google/android/gms/') { $sdks += "Google Play Services" }
    if (Has-Pattern 'com/facebook/') { $sdks += "Facebook SDK" }
    if (Has-Pattern 'com/payu/') { $sdks += "PayU" }
    if (Has-Pattern 'com/stripe/') { $sdks += "Stripe" }
    if (Has-Pattern 'com/braintreepayments/') { $sdks += "Braintree" }
    if (Has-Pattern 'com/storyteller/') { $sdks += "Storyteller" }
    if (Has-Pattern 'zendesk/') { $sdks += "Zendesk" }
    if (Has-Pattern 'com/intercom/') { $sdks += "Intercom" }
    if (Has-Pattern 'com/segment/analytics') { $sdks += "Segment" }
    if (Has-Pattern 'com/amplitude/') { $sdks += "Amplitude" }
    if (Has-Pattern 'com/mixpanel/') { $sdks += "Mixpanel" }
    if (Has-Pattern 'com/onesignal/') { $sdks += "OneSignal" }
    if (Has-Pattern 'com/microsoft/clarity') { $sdks += "Microsoft Clarity" }
    if (Has-Pattern 'com/hotjar/') { $sdks += "Hotjar" }
    if (Has-Pattern 'com/instabug/') { $sdks += "Instabug" }

    $buildConfig = if (Has-Pattern 'BuildConfig\.class$') {
        "present (grep BuildConfig.java after decompile for base URLs / flavor)"
    } else {
        "not detected in zip listing (still worth grepping after decompile)"
    }

    # Summary
    Write-Host "=== APK Fingerprint: $([IO.Path]::GetFileName($InputFile)) ==="
    Write-Host ""
    Write-Host "Framework:        $framework"
    Write-Host "  Rationale:      $rationale"
    Write-Host "Obfuscation:      $obfuscation"
    Write-Host ""
    Write-Host "HTTP stack:       $([string]::Join(' ', $http))"
    Write-Host "DI:               $([string]::Join(' ', $di))"
    Write-Host "Serialization:    $([string]::Join(' ', $ser))"
    Write-Host "BuildConfig:      $buildConfig"
    Write-Host ""
    Write-Host "Third-party SDKs: $([string]::Join(' ', $sdks))"
    Write-Host ""
    Write-Host "Native libraries (consolidated across splits):"
    if ($nativeLibs.Count -gt 0) {
        foreach ($lib in $nativeLibs) {
            Write-Host "  $lib"
        }
    } else {
        Write-Host "  (none)"
    }
    Write-Host ""

    Write-Host "Recommended next step:"
    switch -Wildcard ($framework) {
        "Flutter*" {
            Write-Host "  Java decompilation will yield ~no app code. The Dart logic lives in"
            Write-Host "  libapp.so (AOT). Use tools designed for Flutter:"
            Write-Host "    - blutter / reFlutter (extract Dart class structure)"
            Write-Host "    - strings on libapp.so for endpoints & string constants"
        }
        "React*" {
            Write-Host "  Java code is just the RN host. Real app logic is in JS/Hermes:"
            Write-Host "    - if Hermes: hbctool disasm assets/index.android.bundle"
            Write-Host "    - if JSC: js-beautify the bundle and grep for 'fetch('/'axios'"
        }
        "Cordova*" {
            Write-Host "  All app code is in assets/www/ (or assets/public/). Just unzip and"
            Write-Host "  inspect the HTML/JS — no Java decompile needed."
        }
        "Xamarin*" {
            Write-Host "  App logic is in .NET DLLs (assemblies/). Use ILSpy or dotPeek;"
            Write-Host "  jadx will only show the Mono host."
        }
        default {
            Write-Host "  Proceed with Phase 3: decompile.ps1 `"$InputFile`""
        }
    }
} finally {
    if (Test-Path $tempDir) {
        Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
