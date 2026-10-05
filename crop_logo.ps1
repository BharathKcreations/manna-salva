Add-Type -AssemblyName System.Drawing

$sourcePath = Join-Path $PSScriptRoot "assets\images\pandugappa-pickle.jpg"
$img = [System.Drawing.Bitmap]::FromFile($sourcePath)

Write-Output "Image size: $($img.Width) x $($img.Height)"

# The logo is in the top right. Let's find its exact coordinates by checking pixels or saving a crop.
# In a 994x1024 image, top right logo is around x=680..950, y=80..200
$rect = New-Object System.Drawing.Rectangle(680, 80, 260, 110)
$crop = $img.Clone($rect, $img.PixelFormat)
$outputPath = Join-Path $PSScriptRoot "assets\images\logo-test.png"
$crop.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)

$crop.Dispose()
$img.Dispose()
Write-Output "Saved logo-test.png"
