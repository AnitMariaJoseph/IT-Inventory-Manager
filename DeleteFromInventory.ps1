Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# === SQLite paths ===
$sqlitePath = "C:\SQLite\sqlite3.exe"
<<<<<<< HEAD
$dbPath = "C:\Users\user\Desktop\Python\Database project\inventory.db"
=======
$dbPath = "C:\Users\user\Desktop\Python\IT Inventory Manager\inventory.db"
>>>>>>> 7d3917d6df0e8d813971e14adbe99a291f3b30a9
$logPath = "C:\Users\user\Desktop\Python\Database project\DeletedItems.log"
$query = "SELECT * FROM devices;"

# === Raw output from sqlite3 ===
$rawOutput = & $sqlitePath $dbPath $query

# === Create DataTable ===
$table = New-Object System.Data.DataTable
$null = $table.Columns.Add("ID")
$null = $table.Columns.Add("Name")
$null = $table.Columns.Add("Type")
$null = $table.Columns.Add("Location")
$null = $table.Columns.Add("Status")

# === Fill DataTable with parsed output ===
foreach ($line in $rawOutput) {
    if ($line -match '\|') {
        $cols = $line -split '\|'
        $row = $table.NewRow()
        $row["ID"]       = $cols[0].Trim()
        $row["Name"]     = $cols[1].Trim()
        $row["Type"]     = $cols[2].Trim()
        $row["Location"] = $cols[3].Trim()
        $row["Status"]   = $cols[4].Trim()
        $table.Rows.Add($row)
    }
}


# === GUI setup ===
$form = New-Object System.Windows.Forms.Form
$form.Text = "Delete Asset"
$form.Size = New-Object System.Drawing.Size(720, 420)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::WhiteSmoke

# ===Table/Grid ===
$grid = New-Object System.Windows.Forms.DataGridView
$grid.Size = New-Object System.Drawing.Size(680, 300)
$grid.Location = New-Object System.Drawing.Point(10, 10)
$grid.ReadOnly = $true
$grid.SelectionMode = 'FullRowSelect'
$grid.MultiSelect = $false
$grid.AutoSizeColumnsMode = 'Fill'
$grid.DataSource = $table
$form.Controls.Add($grid)

# === Delete Button ===
$btnDelete = New-Object System.Windows.Forms.Button
$btnDelete.Text = "Delete Selected"
$btnDelete.Size = New-Object System.Drawing.Size(140, 35)
$btnDelete.Location = New-Object System.Drawing.Point(180, 330)
$btnDelete.BackColor = "IndianRed"
$btnDelete.ForeColor = "White"
$btnDelete.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($btnDelete)

# === Close Button ===
$btnClose = New-Object System.Windows.Forms.Button
$btnClose.Text = "Close"
$btnClose.Size = New-Object System.Drawing.Size(140, 35)
$btnClose.Location = New-Object System.Drawing.Point(380, 330)
$btnClose.BackColor = "LightGray"
$btnClose.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$btnClose.Add_Click({ $form.Close() })
$form.Controls.Add($btnClose)

# === Deletion ===
$btnDelete.Add_Click({
    if ($grid.SelectedRows.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Please select a row to delete.", "Warning")
        return
    }

    $selectedRow = $grid.SelectedRows[0]
    $idToDelete = $selectedRow.Cells["ID"].Value
    $logEntry = "Deleted: ID=$($selectedRow.Cells["ID"].Value), Name=$($selectedRow.Cells["Name"].Value), Type=$($selectedRow.Cells["Type"].Value), Location=$($selectedRow.Cells["Location"].Value), Status=$($selectedRow.Cells["Status"].Value) - $(Get-Date)"

    $confirm = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to delete this item?", "Confirm Delete", "YesNo")
    if ($confirm -eq "Yes") {
        # === Delete from DB ===
        & $sqlitePath $dbPath "DELETE FROM devices WHERE id=$idToDelete;"

        # === Log deletion ===
        Add-Content -Path $logPath -Value $logEntry

        [System.Windows.Forms.MessageBox]::Show("Asset deleted successfully. Please reopen to refresh list.", "Success")
        $form.Close()
    }
})


$form.Topmost = $true
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()
