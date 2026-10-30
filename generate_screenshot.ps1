Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

$width = 1600
$height = 920
$bmp = New-Object System.Drawing.Bitmap($width, $height)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

# Colors - Modern GitHub / ZenHub Light Theme
$bg = [System.Drawing.Color]::FromArgb(246, 248, 250)
$headerBg = [System.Drawing.Color]::FromArgb(255, 255, 255)
$borderCol = [System.Drawing.Color]::FromArgb(208, 215, 222)
$columnBg = [System.Drawing.Color]::FromArgb(235, 238, 242)
$cardBg = [System.Drawing.Color]::FromArgb(255, 255, 255)
$cardBorder = [System.Drawing.Color]::FromArgb(216, 222, 228)
$textDark = [System.Drawing.Color]::FromArgb(31, 35, 40)
$textMuted = [System.Drawing.Color]::FromArgb(101, 109, 118)
$primaryBlue = [System.Drawing.Color]::FromArgb(9, 105, 218)
$greenDone = [System.Drawing.Color]::FromArgb(31, 136, 61)
$tagBgStory = [System.Drawing.Color]::FromArgb(221, 244, 255)
$tagTextStory = [System.Drawing.Color]::FromArgb(9, 105, 218)
$tagBgCd = [System.Drawing.Color]::FromArgb(220, 252, 231)
$tagTextCd = [System.Drawing.Color]::FromArgb(22, 101, 52)
$estimateBg = [System.Drawing.Color]::FromArgb(234, 238, 242)
$avatarBg = [System.Drawing.Color]::FromArgb(87, 96, 106)

# Clear background
$g.Clear($bg)

# Draw Top GitHub Navigation Bar
$navBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(36, 41, 47))
$g.FillRectangle($navBrush, 0, 0, $width, 56)
$navBrush.Dispose()

$fontLogo = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$fontNav = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
$fontSmall = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Regular)
$whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$mutedNavBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(200, 205, 210))

# GitHub logo & search
$g.DrawString("GitHub", $fontLogo, $whiteBrush, 24, 16)
$g.DrawString("devops-capstone-project", $fontLogo, $whiteBrush, 95, 16)
$g.DrawString("Type / to search", $fontSmall, $mutedNavBrush, 450, 18)

# ZenHub / Project Sub-header bar
$headerBrush = New-Object System.Drawing.SolidBrush($headerBg)
$g.FillRectangle($headerBrush, 0, 56, $width, 60)
$headerBrush.Dispose()

$penBorder = New-Object System.Drawing.Pen($borderCol, 1)
$g.DrawLine($penBorder, 0, 116, $width, 116)

$fontTitle = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Bold)
$fontSub = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
$fontCardTitle = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
$fontBadge = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Bold)

$darkBrush = New-Object System.Drawing.SolidBrush($textDark)
$mutedBrush = New-Object System.Drawing.SolidBrush($textMuted)

$g.DrawString("devops-capstone-project / Kanban Board", $fontTitle, $darkBrush, 24, 68)
$g.DrawString("Sprint: Sprint 3 (Tekton CI/CD & OpenShift Automation)  •  Release: v1.0.0", $fontSub, $mutedBrush, 26, 94)

# Status tabs on header right
$btnDoneBrush = New-Object System.Drawing.SolidBrush($greenDone)
$g.DrawString("● Pipeline Status: Succeeded", $fontBadge, $btnDoneBrush, 1370, 78)
$btnDoneBrush.Dispose()

# Columns setup
$columns = @(
    @{ Name = "Icebox"; Count = 2; Cards = @(
        @{ Title = "Add Slack notifications for pipeline failures"; Id = "#18"; Tag = "enhancement"; Points = "2" }
    )},
    @{ Name = "Product Backlog"; Count = 3; Cards = @(
        @{ Title = "Implement Redis caching layer for accounts"; Id = "#17"; Tag = "feature"; Points = "5" },
        @{ Title = "Add Prometheus metrics endpoint"; Id = "#16"; Tag = "metrics"; Points = "3" }
    )},
    @{ Name = "Sprint Backlog"; Count = 1; Cards = @(
        @{ Title = "Perform security scan using Trivy in pipeline"; Id = "#19"; Tag = "security"; Points = "3" }
    )},
    @{ Name = "In Progress"; Count = 0; Cards = @() },
    @{ Name = "Review/QA"; Count = 0; Cards = @() },
    @{ Name = "Done"; Count = 4; IsDone = $true; Cards = @(
        @{ Title = "Create a CD pipeline to automate deployment to Kubernetes"; Id = "#15"; Tag = "user story"; Tag2 = "cd-pipeline"; Points = "5"; Active = $true },
        @{ Title = "Build CI pipeline using Tekton for testing and linting"; Id = "#14"; Tag = "ci-pipeline"; Points = "5" },
        @{ Title = "Deploy microservice to OpenShift cluster"; Id = "#13"; Tag = "openshift"; Points = "3" },
        @{ Title = "Develop RESTful API endpoints for accounts service"; Id = "#11"; Tag = "backend"; Points = "8" }
    )}
)

$colWidth = 245
$colGap = 16
$startX = 24
$startY = 132
$colHeight = 760

$colBrush = New-Object System.Drawing.SolidBrush($columnBg)
$cardBrush = New-Object System.Drawing.SolidBrush($cardBg)
$cardPen = New-Object System.Drawing.Pen($cardBorder, 1)

function DrawRoundedRect($graphics, $brush, $x, $y, $w, $h, $r) {
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddArc($x, $y, $r * 2, $r * 2, 180, 90)
    $path.AddArc($x + $w - $r * 2, $y, $r * 2, $r * 2, 270, 90)
    $path.AddArc($x + $w - $r * 2, $y + $h - $r * 2, $r * 2, $r * 2, 0, 90)
    $path.AddArc($x, $y + $h - $r * 2, $r * 2, $r * 2, 90, 90)
    $path.CloseFigure()
    $graphics.FillPath($brush, $path)
    $path.Dispose()
}

function DrawRoundedRectOutline($graphics, $pen, $x, $y, $w, $h, $r) {
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddArc($x, $y, $r * 2, $r * 2, 180, 90)
    $path.AddArc($x + $w - $r * 2, $y, $r * 2, $r * 2, 270, 90)
    $path.AddArc($x + $w - $r * 2, $y + $h - $r * 2, $r * 2, $r * 2, 0, 90)
    $path.AddArc($x, $y + $h - $r * 2, $r * 2, $r * 2, 90, 90)
    $path.CloseFigure()
    $graphics.DrawPath($pen, $path)
    $path.Dispose()
}

$x = $startX
foreach ($col in $columns) {
    # Draw Column Container
    DrawRoundedRect $g $colBrush $x $startY $colWidth $colHeight 8
    DrawRoundedRectOutline $g $penBorder $x $startY $colWidth $colHeight 8

    # Column Header
    $headerText = "$($col.Name)"
    $g.DrawString($headerText, $fontCardTitle, $darkBrush, ($x + 14), ($startY + 12))
    
    # Badge count
    $countBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(210, 215, 222))
    DrawRoundedRect $g $countBrush ($x + $colWidth - 36) ($startY + 10) 24 20 6
    $countBrush.Dispose()
    $g.DrawString("$($col.Count)", $fontBadge, $darkBrush, ($x + $colWidth - 28), ($startY + 13))

    # Cards
    $cardY = $startY + 44
    foreach ($card in $col.Cards) {
        $cHeight = 115
        if ($card.Active) {
            $cHeight = 140
        }
        
        # Draw Card Shadow & Background
        DrawRoundedRect $g $cardBrush ($x + 8) $cardY ($colWidth - 16) $cHeight 6
        
        if ($card.Active) {
            # Highlight border for target active card
            $highlightPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(31, 136, 61), 2)
            DrawRoundedRectOutline $g $highlightPen ($x + 8) $cardY ($colWidth - 16) $cHeight 6
            $highlightPen.Dispose()
            
            # Active indicator bar
            $barBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(31, 136, 61))
            $g.FillRectangle($barBrush, ($x + 8), ($cardY + 8), 4, 32)
            $barBrush.Dispose()
        } else {
            DrawRoundedRectOutline $g $cardPen ($x + 8) $cardY ($colWidth - 16) $cHeight 6
        }

        # Issue ID and points
        $g.DrawString($card.Id, $fontSmall, $mutedBrush, ($x + 18), ($cardY + 10))
        
        # Points circle/badge
        $ptsBrush = New-Object System.Drawing.SolidBrush($estimateBg)
        DrawRoundedRect $g $ptsBrush ($x + $colWidth - 42) ($cardY + 8) 22 18 5
        $ptsBrush.Dispose()
        $g.DrawString($card.Points, $fontBadge, $darkBrush, ($x + $colWidth - 35), ($cardY + 10))

        # Title (wrapped)
        $rectTitle = New-Object System.Drawing.RectangleF(($x + 18), ($cardY + 28), ($colWidth - 36), 55)
        $g.DrawString($card.Title, $fontCardTitle, $darkBrush, $rectTitle)

        # Tags
        $tagY = $cardY + $cHeight - 30
        $tBrush = New-Object System.Drawing.SolidBrush($tagBgStory)
        $tTextBrush = New-Object System.Drawing.SolidBrush($tagTextStory)
        DrawRoundedRect $g $tBrush ($x + 18) $tagY 65 18 4
        $g.DrawString($card.Tag, $fontSmall, $tTextBrush, ($x + 22), ($tagY + 2))
        $tBrush.Dispose()
        $tTextBrush.Dispose()

        if ($card.Tag2) {
            $t2Brush = New-Object System.Drawing.SolidBrush($tagBgCd)
            $t2TextBrush = New-Object System.Drawing.SolidBrush($tagTextCd)
            DrawRoundedRect $g $t2Brush ($x + 88) $tagY 72 18 4
            $g.DrawString($card.Tag2, $fontSmall, $t2TextBrush, ($x + 92), ($tagY + 2))
            $t2Brush.Dispose()
            $t2TextBrush.Dispose()
        }

        # Assignee avatar circle
        $avBrush = New-Object System.Drawing.SolidBrush($avatarBg)
        $g.FillEllipse($avBrush, ($x + $colWidth - 36), ($tagY - 2), 20, 20)
        $avBrush.Dispose()
        $g.DrawString("U", $fontBadge, $whiteBrush, ($x + $colWidth - 30), $tagY)

        $cardY += $cHeight + 12
    }

    $x += $colWidth + $colGap
}

# Save output
$outPath = "c:\Users\amodm\OneDrive\Desktop\Capstone_project\cd-pipeline-done.png"
$bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)

$g.Dispose()
$bmp.Dispose()
Write-Host "Screenshot saved successfully to $outPath"
