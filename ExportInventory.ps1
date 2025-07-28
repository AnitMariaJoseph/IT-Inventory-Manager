Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# === SQLite paths ===
$sqlitePath = "C:\SQLite\sqlite3.exe"
<<<<<<< HEAD
$dbPath = "C:\Users\user\Desktop\Python\Database project\inventory.db"
=======
$dbPath = "C:\Users\user\Desktop\Python\IT Inventory Manager\inventory.db"
>>>>>>> 7d3917d6df0e8d813971e14adbe99a291f3b30a9
$query = "SELECT * FROM devices;"

# === Main Form ===
$form = New-Object System.Windows.Forms.Form
$form.Text = "Export Inventory to CSV"
$form.Size = New-Object System.Drawing.Size(400, 180)
$form.StartPosition = "CenterScreen"

# === Label ===
$label = New-Object System.Windows.Forms.Label
$label.Text = "Click 'Export' to save the inventory data as CSV:"
$label.Location = New-Object System.Drawing.Point(20, 20)
$label.Size = New-Object System.Drawing.Size(350, 20)
$form.Controls.Add($label)

# === Export Button ===
$btnExport = New-Object System.Windows.Forms.Button
$btnExport.Text = "Export"
$btnExport.Size = New-Object System.Drawing.Size(100, 30)
$btnExport.Location = New-Object System.Drawing.Point(50, 60)
$form.Controls.Add($btnExport)

# === Close Button ===
$btnClose = New-Object System.Windows.Forms.Button
$btnClose.Text = "Close"
$btnClose.Size = New-Object System.Drawing.Size(100, 30)
$btnClose.Location = New-Object System.Drawing.Point(200, 60)
$btnClose.Add_Click({ $form.Close() })
$form.Controls.Add($btnClose)

# === Export Logic ===
$btnExport.Add_Click({
   
    $saveDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveDialog.Filter = "CSV files (*.csv)|*.csv"
    $saveDialog.Title = "Save Inventory CSV"
    $saveDialog.FileName = "Inventory.csv"

    if ($saveDialog.ShowDialog() -eq "OK") {
        $csvPath = $saveDialog.FileName

        # === Run query ===
        $rawOutput = & $sqlitePath $dbPath $query

        if (-not $rawOutput) {
            [System.Windows.Forms.MessageBox]::Show("No data found to export.", "Info")
            return
        }

        # === Parse output ===
        $data = $rawOutput | ForEach-Object {
            if ($_ -match '\|') {
                $columns = $_ -split '\|'
                [PSCustomObject]@{
                    ID       = $columns[0]
                    Name     = $columns[1]
                    Type     = $columns[2]
                    Location = $columns[3]
                    Status   = $columns[4]
                }
            }
        }

        # === Export ===
        $data | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8
        [System.Windows.Forms.MessageBox]::Show("Exported to:`n$csvPath", "Success")
    }
})

# === Show Form ===
$form.Topmost = $true
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()
