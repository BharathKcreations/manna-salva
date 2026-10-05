Add-Type -AssemblyName System.Drawing

$sourcePath = Join-Path $PSScriptRoot "assets\images\pandugappa-pickle.jpg"
$img = [System.Drawing.Bitmap]::FromFile($sourcePath)

# Let's inspect slightly wider: x=680, y=75, w=250, h=120
$rect = New-Object System.Drawing.Rectangle(680, 75, 250, 120)
$crop = $img.Clone($rect, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# Save exact crop
$outputPath = Join-Path $PSScriptRoot "assets\images\logo.png"
$crop.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)

$crop.Dispose()
$img.Dispose()
Write-Output "Saved logo.png"
