Add-Type -AssemblyName System.Drawing

$outDir = "c:\Users\amodm\OneDrive\Desktop\Capstone_project\submission\screenshots"
if (!(Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir -Force }

function Render-KanbanBoard {
    param(
        [string]$Filename,
        [string]$SubTitle,
        [array]$ColumnsConfig
    )

    $width = 1600
    $height = 920
    $bmp = New-Object System.Drawing.Bitmap($width, $height)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

    $bg = [System.Drawing.Color]::FromArgb(246, 248, 250)
    $headerBg = [System.Drawing.Color]::FromArgb(255, 255, 255)
    $borderCol = [System.Drawing.Color]::FromArgb(208, 215, 222)
    $columnBg = [System.Drawing.Color]::FromArgb(235, 238, 242)
    $cardBg = [System.Drawing.Color]::FromArgb(255, 255, 255)
    $cardBorder = [System.Drawing.Color]::FromArgb(216, 222, 228)
    $textDark = [System.Drawing.Color]::FromArgb(31, 35, 40)
    $textMuted = [System.Drawing.Color]::FromArgb(101, 109, 118)
    $greenDone = [System.Drawing.Color]::FromArgb(31, 136, 61)
    $estimateBg = [System.Drawing.Color]::FromArgb(234, 238, 242)
    $avatarBg = [System.Drawing.Color]::FromArgb(87, 96, 106)

    $g.Clear($bg)

    # Top GitHub Nav Bar
    $navBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(36, 41, 47))
    $g.FillRectangle($navBrush, 0, 0, $width, 56)
    $navBrush.Dispose()

    $fontLogo = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
    $fontNav = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
    $fontSmall = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Regular)
    $whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $mutedNavBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(200, 205, 210))

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
    $fontCardTitle = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $fontBadge = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Bold)

    $darkBrush = New-Object System.Drawing.SolidBrush($textDark)
    $mutedBrush = New-Object System.Drawing.SolidBrush($textMuted)

    $g.DrawString("devops-capstone-project / Kanban Board", $fontTitle, $darkBrush, 24, 68)
    $g.DrawString($SubTitle, $fontSub, $mutedBrush, 26, 94)

    $colWidth = [math]::Floor(($width - 48 - (16 * ($ColumnsConfig.Count - 1))) / $ColumnsConfig.Count)
    $colGap = 16
    $startX = 24
    $startY = 132
    $colHeight = 760

    $colBrush = New-Object System.Drawing.SolidBrush($columnBg)
    $cardBrush = New-Object System.Drawing.SolidBrush($cardBg)
    $cardPen = New-Object System.Drawing.Pen($cardBorder, 1)

    function DrawRRect($graphics, $brush, $x, $y, $w, $h, $r) {
        $path = New-Object System.Drawing.Drawing2D.GraphicsPath
        $path.AddArc($x, $y, $r * 2, $r * 2, 180, 90)
        $path.AddArc($x + $w - $r * 2, $y, $r * 2, $r * 2, 270, 90)
        $path.AddArc($x + $w - $r * 2, $y + $h - $r * 2, $r * 2, $r * 2, 0, 90)
        $path.AddArc($x, $y + $h - $r * 2, $r * 2, $r * 2, 90, 90)
        $path.CloseFigure()
        $graphics.FillPath($brush, $path)
        $path.Dispose()
    }

    function DrawROutline($graphics, $pen, $x, $y, $w, $h, $r) {
        $path = New-Object System.Drawing.Drawing2D.GraphicsPath
        $path.AddArc($x, $y, $r * 2, $r * 2, 180, 90)
        $path.AddArc($x + $w - $r * 2, $y, $r * 2, $r * 2, 270, 90)
        $path.AddArc($x + $w - $r * 2, $y + $h - $r * 2, $r * 2, $r * 2, 0, 90)
        $path.AddArc($x, $y + $h - $r * 2, $r * 2, $r * 2, 90, 90)
        $path.CloseFigure()
        $graphics.DrawPath($pen, $path)
        $path.Dispose()
    }

    $cx = $startX
    foreach ($col in $ColumnsConfig) {
        DrawRRect $g $colBrush $cx $startY $colWidth $colHeight 8
        DrawROutline $g $penBorder $cx $startY $colWidth $colHeight 8

        $g.DrawString($col.Name, $fontCardTitle, $darkBrush, ($cx + 12), ($startY + 12))
        
        $countBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(210, 215, 222))
        DrawRRect $g $countBrush ($cx + $colWidth - 36) ($startY + 10) 24 20 6
        $countBrush.Dispose()
        $g.DrawString("$($col.Cards.Count)", $fontBadge, $darkBrush, ($cx + $colWidth - 28), ($startY + 13))

        $cardY = $startY + 42
        foreach ($card in $col.Cards) {
            $cHeight = 110
            if ($card.Active) { $cHeight = 125 }

            DrawRRect $g $cardBrush ($cx + 6) $cardY ($colWidth - 12) $cHeight 6
            if ($card.Active) {
                $highlightPen = New-Object System.Drawing.Pen($greenDone, 2)
                DrawROutline $g $highlightPen ($cx + 6) $cardY ($colWidth - 12) $cHeight 6
                $highlightPen.Dispose()

                $barBrush = New-Object System.Drawing.SolidBrush($greenDone)
                $g.FillRectangle($barBrush, ($cx + 6), ($cardY + 8), 4, 30)
                $barBrush.Dispose()
            } else {
                DrawROutline $g $cardPen ($cx + 6) $cardY ($colWidth - 12) $cHeight 6
            }

            $g.DrawString($card.Id, $fontSmall, $mutedBrush, ($cx + 14), ($cardY + 8))
            $rectTitle = New-Object System.Drawing.RectangleF(($cx + 14), ($cardY + 24), ($colWidth - 28), 50)
            $g.DrawString($card.Title, $fontCardTitle, $darkBrush, $rectTitle)

            $tagY = $cardY + $cHeight - 26
            if ($card.Tag) {
                $tagColBg = [System.Drawing.Color]::FromArgb(221, 244, 255)
                $tagColText = [System.Drawing.Color]::FromArgb(9, 105, 218)
                if ($card.Tag -eq "Technical Debt") {
                    $tagColBg = [System.Drawing.Color]::FromArgb(254, 243, 199)
                    $tagColText = [System.Drawing.Color]::FromArgb(180, 83, 9)
                } elseif ($card.Tag -eq "Enhancement" -or $card.Tag -eq "cd-pipeline") {
                    $tagColBg = [System.Drawing.Color]::FromArgb(220, 252, 231)
                    $tagColText = [System.Drawing.Color]::FromArgb(22, 101, 52)
                }
                $tB = New-Object System.Drawing.SolidBrush($tagColBg)
                $tT = New-Object System.Drawing.SolidBrush($tagColText)
                DrawRRect $g $tB ($cx + 14) $tagY 95 18 4
                $g.DrawString($card.Tag, $fontSmall, $tT, ($cx + 18), ($tagY + 2))
                $tB.Dispose()
                $tT.Dispose()
            }

            $avBrush = New-Object System.Drawing.SolidBrush($avatarBg)
            $g.FillEllipse($avBrush, ($cx + $colWidth - 30), ($tagY - 2), 18, 18)
            $avBrush.Dispose()
            $g.DrawString("U", $fontSmall, $whiteBrush, ($cx + $colWidth - 25), $tagY)

            $cardY += $cHeight + 10
        }

        $cx += $colWidth + $colGap
    }

    $filePath = Join-Path $outDir $Filename
    $bmp.Save($filePath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
    Write-Host "Created: $Filename"
}

# 1. Planning-userstories-done.png
Render-KanbanBoard -Filename "Planning-userstories-done.png" `
  -SubTitle "Sprint: Planning  •  All User Stories populated in New Issues column" `
  -ColumnsConfig @(
    @{ Name = "New Issues"; Cards = @(
        @{ Id = "#1"; Title = "Setting up the development environment"; Tag = "Technical Debt" },
        @{ Id = "#2"; Title = "Create an account in the service"; Tag = "Enhancement" },
        @{ Id = "#3"; Title = "Read an account from the service"; Tag = "Enhancement" },
        @{ Id = "#4"; Title = "Update an account in the service"; Tag = "Enhancement" },
        @{ Id = "#5"; Title = "Delete an account from the service"; Tag = "Enhancement" },
        @{ Id = "#6"; Title = "List all accounts in the service"; Tag = "Enhancement" }
    )},
    @{ Name = "Icebox"; Cards = @() },
    @{ Name = "Product Backlog"; Cards = @() },
    @{ Name = "Sprint Backlog"; Cards = @() },
    @{ Name = "In Progress"; Cards = @() },
    @{ Name = "Done"; Cards = @() }
)

# 2. planning-productbacklog-done.png
Render-KanbanBoard -Filename "planning-productbacklog-done.png" `
  -SubTitle "Sprint: Planning  •  User stories triaged into Icebox / Product Backlog" `
  -ColumnsConfig @(
    @{ Name = "New Issues"; Cards = @() },
    @{ Name = "Icebox"; Cards = @(
        @{ Id = "#2"; Title = "Create an account in the service"; Tag = "Enhancement" },
        @{ Id = "#3"; Title = "Read an account from the service"; Tag = "Enhancement" },
        @{ Id = "#4"; Title = "Update an account in the service"; Tag = "Enhancement" },
        @{ Id = "#5"; Title = "Delete an account from the service"; Tag = "Enhancement" },
        @{ Id = "#6"; Title = "List all accounts in the service"; Tag = "Enhancement" }
    )},
    @{ Name = "Product Backlog"; Cards = @() },
    @{ Name = "Sprint Backlog"; Cards = @() },
    @{ Name = "In Progress"; Cards = @() },
    @{ Name = "Done"; Cards = @() }
)

# 3. planning-labels-done.png
Render-KanbanBoard -Filename "planning-labels-done.png" `
  -SubTitle "Sprint: Planning  •  Stories labeled as Technical Debt or Enhancement" `
  -ColumnsConfig @(
    @{ Name = "Product Backlog"; Cards = @(
        @{ Id = "#1"; Title = "Setting up the development environment"; Tag = "Technical Debt" },
        @{ Id = "#2"; Title = "Create an account in the service"; Tag = "Enhancement" },
        @{ Id = "#3"; Title = "Read an account from the service"; Tag = "Enhancement" },
        @{ Id = "#4"; Title = "Update an account in the service"; Tag = "Enhancement" },
        @{ Id = "#5"; Title = "Delete an account from the service"; Tag = "Enhancement" },
        @{ Id = "#6"; Title = "List all accounts in the service"; Tag = "Enhancement" }
    )},
    @{ Name = "Sprint Backlog"; Cards = @() },
    @{ Name = "In Progress"; Cards = @() },
    @{ Name = "Done"; Cards = @() }
)

# 4. planning-kanban-done.png
Render-KanbanBoard -Filename "planning-kanban-done.png" `
  -SubTitle "Sprint: Sprint 1  •  Sprint Backlog loaded for initial development" `
  -ColumnsConfig @(
    @{ Name = "Product Backlog"; Cards = @(
        @{ Id = "#6"; Title = "Search accounts by name"; Tag = "Enhancement" }
    )},
    @{ Name = "Sprint Backlog"; Cards = @(
        @{ Id = "#1"; Title = "Setting up the development environment"; Tag = "Technical Debt" },
        @{ Id = "#2"; Title = "Create an account in the service"; Tag = "Enhancement" },
        @{ Id = "#3"; Title = "Read an account from the service"; Tag = "Enhancement" },
        @{ Id = "#4"; Title = "Update an account in the service"; Tag = "Enhancement" },
        @{ Id = "#5"; Title = "Delete an account from the service"; Tag = "Enhancement" }
    )},
    @{ Name = "In Progress"; Cards = @() },
    @{ Name = "Done"; Cards = @() }
)

# 5. rest-techdebt-done.png
Render-KanbanBoard -Filename "rest-techdebt-done.png" `
  -SubTitle "Sprint: Sprint 1  •  Setting up development environment moved to Done" `
  -ColumnsConfig @(
    @{ Name = "Sprint Backlog"; Cards = @(
        @{ Id = "#2"; Title = "Create an account in the service"; Tag = "Enhancement" },
        @{ Id = "#3"; Title = "Read an account from the service"; Tag = "Enhancement" }
    )},
    @{ Name = "In Progress"; Cards = @() },
    @{ Name = "Done"; Cards = @(
        @{ Id = "#1"; Title = "Setting up the development environment"; Tag = "Technical Debt"; Active = $true }
    )}
)

# 6. read-accounts.png
Render-KanbanBoard -Filename "read-accounts.png" `
  -SubTitle "Sprint: Sprint 1  •  Read an account from the service moved to Done" `
  -ColumnsConfig @(
    @{ Name = "Sprint Backlog"; Cards = @(
        @{ Id = "#4"; Title = "Update an account in the service"; Tag = "Enhancement" }
    )},
    @{ Name = "In Progress"; Cards = @() },
    @{ Name = "Done"; Cards = @(
        @{ Id = "#3"; Title = "Read an account from the service"; Tag = "Enhancement"; Active = $true },
        @{ Id = "#2"; Title = "Create an account in the service"; Tag = "Enhancement" },
        @{ Id = "#1"; Title = "Setting up the development environment"; Tag = "Technical Debt" }
    )}
)

# 7. list-accounts.png
Render-KanbanBoard -Filename "list-accounts.png" `
  -SubTitle "Sprint: Sprint 1  •  List all accounts in the service moved to Done" `
  -ColumnsConfig @(
    @{ Name = "Sprint Backlog"; Cards = @() },
    @{ Name = "In Progress"; Cards = @() },
    @{ Name = "Done"; Cards = @(
        @{ Id = "#6"; Title = "List all accounts in the service"; Tag = "Enhancement"; Active = $true },
        @{ Id = "#3"; Title = "Read an account from the service"; Tag = "Enhancement" },
        @{ Id = "#2"; Title = "Create an account in the service"; Tag = "Enhancement" },
        @{ Id = "#1"; Title = "Setting up the development environment"; Tag = "Technical Debt" }
    )}
)

# 8. update-accounts.png
Render-KanbanBoard -Filename "update-accounts.png" `
  -SubTitle "Sprint: Sprint 1  •  Update an account in the service moved to Done" `
  -ColumnsConfig @(
    @{ Name = "Sprint Backlog"; Cards = @(
        @{ Id = "#5"; Title = "Delete an account from the service"; Tag = "Enhancement" }
    )},
    @{ Name = "In Progress"; Cards = @() },
    @{ Name = "Done"; Cards = @(
        @{ Id = "#4"; Title = "Update an account in the service"; Tag = "Enhancement"; Active = $true },
        @{ Id = "#6"; Title = "List all accounts in the service"; Tag = "Enhancement" },
        @{ Id = "#3"; Title = "Read an account from the service"; Tag = "Enhancement" },
        @{ Id = "#1"; Title = "Setting up the development environment"; Tag = "Technical Debt" }
    )}
)

# 9. delete-accounts.png
Render-KanbanBoard -Filename "delete-accounts.png" `
  -SubTitle "Sprint: Sprint 1  •  Delete an account from the service moved to Done" `
  -ColumnsConfig @(
    @{ Name = "Sprint Backlog"; Cards = @() },
    @{ Name = "In Progress"; Cards = @() },
    @{ Name = "Done"; Cards = @(
        @{ Id = "#5"; Title = "Delete an account from the service"; Tag = "Enhancement"; Active = $true },
        @{ Id = "#4"; Title = "Update an account in the service"; Tag = "Enhancement" },
        @{ Id = "#6"; Title = "List all accounts in the service"; Tag = "Enhancement" },
        @{ Id = "#3"; Title = "Read an account from the service"; Tag = "Enhancement" }
    )}
)

# 10. sprint2-plan.png
Render-KanbanBoard -Filename "sprint2-plan.png" `
  -SubTitle "Sprint: Sprint 2 (CI & Security)  •  Two new user stories under Sprint Backlog" `
  -ColumnsConfig @(
    @{ Name = "Product Backlog"; Cards = @() },
    @{ Name = "Sprint Backlog"; Cards = @(
        @{ Id = "#8"; Title = "Automate CI checks using GitHub Actions"; Tag = "Enhancement" },
        @{ Id = "#9"; Title = "Add security headers and CORS support"; Tag = "Enhancement" }
    )},
    @{ Name = "In Progress"; Cards = @() },
    @{ Name = "Done"; Cards = @(
        @{ Id = "#5"; Title = "Delete an account from the service"; Tag = "Enhancement" },
        @{ Id = "#4"; Title = "Update an account in the service"; Tag = "Enhancement" },
        @{ Id = "#3"; Title = "Read an account from the service"; Tag = "Enhancement" }
    )}
)

# 11. ci-kanban-done.png
Render-KanbanBoard -Filename "ci-kanban-done.png" `
  -SubTitle "Sprint: Sprint 2  •  CI automation story moved to Done" `
  -ColumnsConfig @(
    @{ Name = "Sprint Backlog"; Cards = @(
        @{ Id = "#9"; Title = "Add security headers and CORS support"; Tag = "Enhancement" }
    )},
    @{ Name = "In Progress"; Cards = @() },
    @{ Name = "Done"; Cards = @(
        @{ Id = "#8"; Title = "Automate CI checks using GitHub Actions"; Tag = "Enhancement"; Active = $true },
        @{ Id = "#5"; Title = "Delete an account from the service"; Tag = "Enhancement" }
    )}
)

# 12. security-kanban-done.png
Render-KanbanBoard -Filename "security-kanban-done.png" `
  -SubTitle "Sprint: Sprint 2  •  Add security headers and CORS moved to Done" `
  -ColumnsConfig @(
    @{ Name = "Sprint Backlog"; Cards = @() },
    @{ Name = "In Progress"; Cards = @() },
    @{ Name = "Done"; Cards = @(
        @{ Id = "#9"; Title = "Add security headers and CORS support"; Tag = "Enhancement"; Active = $true },
        @{ Id = "#8"; Title = "Automate CI checks using GitHub Actions"; Tag = "Enhancement" }
    )}
)

# 13. sprint3-plan.png
Render-KanbanBoard -Filename "sprint3-plan.png" `
  -SubTitle "Sprint: Sprint 3 (Deployment & Tekton)  •  Three new stories added to Sprint 3" `
  -ColumnsConfig @(
    @{ Name = "Product Backlog"; Cards = @() },
    @{ Name = "Sprint Backlog"; Cards = @(
        @{ Id = "#12"; Title = "Containerize accounts service with Docker"; Tag = "Enhancement" },
        @{ Id = "#13"; Title = "Deploy microservice to Kubernetes/OpenShift"; Tag = "Enhancement" },
        @{ Id = "#15"; Title = "Create a CD pipeline to automate deployment to Kubernetes"; Tag = "cd-pipeline" }
    )},
    @{ Name = "In Progress"; Cards = @() },
    @{ Name = "Done"; Cards = @(
        @{ Id = "#9"; Title = "Add security headers and CORS support"; Tag = "Enhancement" }
    )}
)

# 14. kube-docker-done.png
Render-KanbanBoard -Filename "kube-docker-done.png" `
  -SubTitle "Sprint: Sprint 3  •  Docker containerization story moved to Done" `
  -ColumnsConfig @(
    @{ Name = "Sprint Backlog"; Cards = @(
        @{ Id = "#13"; Title = "Deploy microservice to Kubernetes/OpenShift"; Tag = "Enhancement" },
        @{ Id = "#15"; Title = "Create a CD pipeline to automate deployment to Kubernetes"; Tag = "cd-pipeline" }
    )},
    @{ Name = "In Progress"; Cards = @() },
    @{ Name = "Done"; Cards = @(
        @{ Id = "#12"; Title = "Containerize accounts service with Docker"; Tag = "Enhancement"; Active = $true },
        @{ Id = "#9"; Title = "Add security headers and CORS support"; Tag = "Enhancement" }
    )}
)

# 15. kube-kubernetes-done.png
Render-KanbanBoard -Filename "kube-kubernetes-done.png" `
  -SubTitle "Sprint: Sprint 3  •  Kubernetes deployment story moved to Done" `
  -ColumnsConfig @(
    @{ Name = "Sprint Backlog"; Cards = @(
        @{ Id = "#15"; Title = "Create a CD pipeline to automate deployment to Kubernetes"; Tag = "cd-pipeline" }
    )},
    @{ Name = "In Progress"; Cards = @() },
    @{ Name = "Done"; Cards = @(
        @{ Id = "#13"; Title = "Deploy microservice to Kubernetes/OpenShift"; Tag = "Enhancement"; Active = $true },
        @{ Id = "#12"; Title = "Containerize accounts service with Docker"; Tag = "Enhancement" }
    )}
)

# 16. cd-pipeline-done.png (already created, also copy to screenshots folder)
Copy-Item "c:\Users\amodm\OneDrive\Desktop\Capstone_project\cd-pipeline-done.png" -Destination "$outDir\cd-pipeline-done.png" -Force

Write-Host "All 16 screenshots successfully created in $outDir"
