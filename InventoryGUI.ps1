Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# === Form ===
$form = New-Object System.Windows.Forms.Form
$form.Text = "IT Inventory Manager"
$form.Size = New-Object System.Drawing.Size(700, 450)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(230, 245, 250)
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false

# === Title Panel ===
$titlePanel = New-Object System.Windows.Forms.Panel
$titlePanel.Size = New-Object System.Drawing.Size(700, 60)
$titlePanel.BackColor = [System.Drawing.Color]::FromArgb(140, 70, 130)
$titlePanel.Dock = 'Top'
$form.Controls.Add($titlePanel)

# === Title Label ===
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "  IT Inventory Manager"
$titleLabel.ForeColor = "White"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$titleLabel.AutoSize = $false
$titleLabel.Dock = "Fill"
$titleLabel.TextAlign = "MiddleCenter"
$titleLabel.Location = New-Object System.Drawing.Point(20, 15)
$titlePanel.Controls.Add($titleLabel)

# === Button Style ===
function New-Button($text, $x, $y) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $text
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    $btn.Size = New-Object System.Drawing.Size(150, 50)
    $btn.Location = New-Object System.Drawing.Point($x, $y)
    $btn.BackColor = [System.Drawing.Color]::FromArgb(200, 90, 130)
    $btn.ForeColor = "White"
    $btn.FlatStyle = 'Flat'
    $btn.FlatAppearance.BorderSize = 0
    return $btn
}

# === Buttons ===
$btnView = New-Button " View Inventory" 160 100
$btnAdd = New-Button " Add Asset" 370 100
$btnSearch = New-Button " Search Asset" 160 190
$btnExport = New-Button " Export CSV" 370 190
$btnDeleteEntry = New-Button " Delete Entry" 260 290

$form.Controls.AddRange(@($btnView, $btnAdd, $btnSearch, $btnExport, $btnDeleteEntry))




$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$viewScript = Join-Path $scriptDir "ViewInventory.ps1"

$btnView.Add_Click({
    try {
        Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$viewScript`"" -WindowStyle Normal
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Failed to run ViewInventory.ps1`n$($_.Exception.Message)", "Error")
    }
})

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$addScript = Join-Path $scriptDir "AddToInventory.ps1"

$btnAdd.Add_Click({
    try {
        Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$addScript`"" -WindowStyle Normal
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Failed to run AddToInventory.ps1`n$($_.Exception.Message)", "Error")
    }
})


$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$searchScript = Join-Path $scriptDir "SearchInventory.ps1"

$btnSearch.Add_Click({
    try {
        Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$searchScript`"" -WindowStyle Normal
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Failed to run SearchInventory.ps1`n$($_.Exception.Message)", "Error")
    }
})

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$exportScript = Join-Path $scriptDir "ExportInventory.ps1"

$btnExport.Add_Click({
    try {
        Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$exportScript`"" -WindowStyle Normal
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Failed to run ExportInventory.ps1`n$($_.Exception.Message)", "Error")
    }
})

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$deleteScript = Join-Path $scriptDir "DeleteFromInventory.ps1"

$btnDeleteEntry.Add_Click({
    try {
        Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$deleteScript`"" -WindowStyle Normal
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Failed to run DeleteFromInventory.ps1`n$($_.Exception.Message)", "Error")
    }
})

# === Show Form ===

$form.ShowDialog()