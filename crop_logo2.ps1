Add-Type -AssemblyName System.Drawing

$sourcePath = Join-Path $PSScriptRoot "assets\images\podis-shelves.jpg"
$img = [System.Drawing.Bitmap]::FromFile($sourcePath)

Write-Output "Image size: $($img.Width) x $($img.Height)"

$rect = New-Object System.Drawing.Rectangle(710, 20, 265, 120)
$crop = $img.Clone($rect, $img.PixelFormat)
$outputPath = Join-Path $PSScriptRoot "assets\images\logo-test2.png"
$crop.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)

$crop.Dispose()
$img.Dispose()
Write-Output "Saved logo-test2.png"
