Add-Type -AssemblyName System.Drawing

$logoPath = Join-Path $PSScriptRoot "assets\images\logo.png"
$bmp = [System.Drawing.Bitmap]::FromFile($logoPath)
$width = $bmp.Width
$height = $bmp.Height

Write-Output "Logo dimensions: $width x $height"

# Let's inspect some pixel colors around the corners and along borders
$c00 = $bmp.GetPixel(2, 2)
$cTopMid = $bmp.GetPixel([int]($width/2), 2)
$cBotLeft = $bmp.GetPixel(2, $height - 2)

Write-Output "Top-Left: R=$($c00.R), G=$($c00.G), B=$($c00.B)"
Write-Output "Top-Mid: R=$($cTopMid.R), G=$($cTopMid.G), B=$($cTopMid.B)"
Write-Output "Bot-Left: R=$($cBotLeft.R), G=$($cBotLeft.G), B=$($cBotLeft.B)"

$bmp.Dispose()
