Add-Type -AssemblyName System.Drawing

$inputPath = Join-Path $PSScriptRoot "assets\images\logo-store.png"
$bmp = [System.Drawing.Bitmap]::FromFile($inputPath)
$w = $bmp.Width
$h = $bmp.Height

$outBmp = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# We can do a flood fill BFS from the edges to find all connected background pixels.
# The background is warm light color: high brightness, R > 180, G > 150, B > 130.
# The logo border is gold (R~180..220, G~140..170, B~60..100) or dark black (R<60, G<60, B<60).
# Notice the background has R, G, B relatively close to each other (cream/pinkish), whereas gold has B much lower than R and G (B < 120, R > 150), and black has low R, G, B.

$visited = New-Object 'bool[,]' $w, $h
$queue = New-Object System.Collections.Generic.Queue[System.Drawing.Point]

# Enqueue border pixels that are clearly background
for ($x = 0; $x -lt $w; $x++) {
    $queue.Enqueue((New-Object System.Drawing.Point($x, 0)))
    $queue.Enqueue((New-Object System.Drawing.Point($x, $h - 1)))
    $visited[$x, 0] = $true
    $visited[$x, $h - 1] = $true
}
for ($y = 0; $y -lt $h; $y++) {
    if (-not $visited[0, $y]) {
        $queue.Enqueue((New-Object System.Drawing.Point(0, $y)))
        $visited[0, $y] = $true
    }
    if (-not $visited[$w - 1, $y]) {
        $queue.Enqueue((New-Object System.Drawing.Point($w - 1, $y)))
        $visited[$w - 1, $y] = $true
    }
}

function IsBackgroundPixel($c) {
    # Background wall is warm cream: high R, G, B, with B > 130 and not gold (where B is low)
    # Check if pixel is part of background:
    # Black badge: R < 70, G < 70, B < 70 -> False
    # Gold ribbon/rim: R > 140, G > 100, B < 120 -> False (gold has low blue)
    # White text inside badge: R > 200, G > 200, B > 200 -> but inside black badge, BFS won't reach it!
    # Background wall: R > 190, G > 160, B > 140
    # Also white fluorescent light line in background: R > 230, G > 230, B > 230
    if ($c.R -lt 100 -and $c.G -lt 100 -and $c.B -lt 100) { return $false } # Dark badge/border
    if ($c.R -gt 130 -and $c.G -gt 90 -and $c.B -lt 115) { return $false } # Gold ribbon / contour
    return $true
}

# Copy pixels first
for ($x = 0; $x -lt $w; $x++) {
    for ($y = 0; $y -lt $h; $y++) {
        $outBmp.SetPixel($x, $y, $bmp.GetPixel($x, $y))
    }
}

while ($queue.Count -gt 0) {
    $pt = $queue.Dequeue()
    $c = $bmp.GetPixel($pt.X, $pt.Y)
    
    if (IsBackgroundPixel($c)) {
        $outBmp.SetPixel($pt.X, $pt.Y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
        
        # Check 4 neighbors
        $dirs = @((New-Object System.Drawing.Point(1, 0)), (New-Object System.Drawing.Point(-1, 0)), (New-Object System.Drawing.Point(0, 1)), (New-Object System.Drawing.Point(0, -1)))
        foreach ($d in $dirs) {
            $nx = $pt.X + $d.X
            $ny = $pt.Y + $d.Y
            if ($nx -ge 0 -and $nx -lt $w -and $ny -ge 0 -and $ny -lt $h) {
                if (-not $visited[$nx, $ny]) {
                    $visited[$nx, $ny] = $true
                    $queue.Enqueue((New-Object System.Drawing.Point($nx, $ny)))
                }
            }
        }
    }
}

$outputPath = Join-Path $PSScriptRoot "assets\images\logo-transparent.png"
$outBmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)

$outBmp.Dispose()
$bmp.Dispose()
Write-Output "Saved logo-transparent.png"
