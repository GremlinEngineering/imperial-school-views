param([string]$MakeNSIS = "")
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$kit = $PSScriptRoot
$project = Join-Path $kit "Desktop/Desktop.csproj"
[xml]$metadata = Get-Content -LiteralPath $project
$version = [string]$metadata.Project.PropertyGroup.Version
$build = ([version]([string]$metadata.Project.PropertyGroup.FileVersion)).Revision
$payload = Join-Path $kit "build/win-x64"
$dist = Join-Path $kit "dist"
if ([string]::IsNullOrWhiteSpace($MakeNSIS)) {
    $command = Get-Command makensis.exe -ErrorAction SilentlyContinue
    if ($null -ne $command) { $MakeNSIS = $command.Source }
    else {
        foreach ($folder in @([Environment]::GetFolderPath([Environment+SpecialFolder]::ProgramFilesX86), [Environment]::GetFolderPath([Environment+SpecialFolder]::ProgramFiles))) {
            if ([string]::IsNullOrEmpty($folder)) { continue }
            $candidate = Join-Path $folder "NSIS/makensis.exe"
            if (Test-Path -LiteralPath $candidate) { $MakeNSIS = $candidate; break }
        }
    }
    if ([string]::IsNullOrWhiteSpace($MakeNSIS)) { throw "Установите NSIS 3.x или укажите путь параметром -MakeNSIS." }
}
New-Item -ItemType Directory -Force -Path $dist | Out-Null
Push-Location $kit
try {
    if (Test-Path -LiteralPath $payload) { Remove-Item -LiteralPath $payload -Recurse -Force }
    & dotnet publish $project -c Release -r win-x64 --self-contained true -p:RestoreLockedMode=true -o $payload
    if ($LASTEXITCODE -ne 0) { throw "Сборка приложения завершилась с ошибкой." }
    Copy-Item -LiteralPath (Join-Path $payload "ImperialSchoolViews.exe") -Destination (Join-Path $payload "ImperialSchoolViews.scr")
    $licenses = Join-Path $payload "LICENSES"
    New-Item -ItemType Directory -Force -Path $licenses | Out-Null
    Copy-Item -Path (Join-Path $kit "Desktop/Assets/*-OFL.txt") -Destination $licenses
    Copy-Item -Path (Join-Path $kit "Licenses/*") -Destination $licenses
    $uninstall = Join-Path $kit "build/uninstall-files.nsh"
    $lines = [System.Collections.Generic.List[string]]::new()
    foreach ($file in Get-ChildItem -LiteralPath $payload -File -Recurse | Sort-Object FullName) {
        $relative = $file.FullName.Substring($payload.Length + 1).Replace('/', '\')
        $lines.Add('Delete "$INSTDIR\' + $relative + '"')
    }
    foreach ($folder in Get-ChildItem -LiteralPath $payload -Directory -Recurse | Sort-Object FullName -Descending) {
        $relative = $folder.FullName.Substring($payload.Length + 1).Replace('/', '\')
        $lines.Add('RMDir "$INSTDIR\' + $relative + '"')
    }
    [IO.File]::WriteAllLines($uninstall, $lines, [Text.UTF8Encoding]::new($false))
    $output = Join-Path $dist "imperial-school-views-windows-$version-setup.exe"
    & $MakeNSIS "/DAPP_VERSION=$version" "/DAPP_BUILD=$build" "/DPAYLOAD=$payload" "/DOUTPUT=$output" "/DUNINSTALL_FILES=$uninstall" (Join-Path $kit "Installer/setup.nsi")
    if ($LASTEXITCODE -ne 0) { throw "Сборка установщика завершилась с ошибкой." }
    $receipt = [ordered]@{schema=1;app_id="ru.oopssre.imperial-school.views.windows";platform="windows";version=$version;build=$build;sha256=(Get-FileHash -LiteralPath $output -Algorithm SHA256).Hash.ToLowerInvariant()}
    [IO.File]::WriteAllText((Join-Path $dist "windows-release.json"), ($receipt | ConvertTo-Json) + [Environment]::NewLine, [Text.UTF8Encoding]::new($false))
    Write-Host "Готово: $output"
    Write-Host "Для сайта: EXE и windows-release.json из папки dist."
} finally { Pop-Location }
