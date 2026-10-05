Add-Type -AssemblyName System.Drawing

$sourcePath = Join-Path $PSScriptRoot "assets\images\store-counter.jpg"
$img = [System.Drawing.Bitmap]::FromFile($sourcePath)

Write-Output "Image size: $($img.Width) x $($img.Height)"

# In store-counter (997x1024), top right logo is against the pale cream/yellow wall!
$rect = New-Object System.Drawing.Rectangle(710, 30, 260, 115)
$crop = $img.Clone($rect, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$outputPath = Join-Path $PSScriptRoot "assets\images\logo-store.png"
$crop.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)

$crop.Dispose()
$img.Dispose()
Write-Output "Saved logo-store.png"
