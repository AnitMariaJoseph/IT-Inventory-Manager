Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# === SQLite paths ===
$sqlitePath = "C:\SQLite\sqlite3.exe"
<<<<<<< HEAD
$dbPath = "C:\Users\user\Desktop\Python\Database project\inventory.db"
=======
$dbPath = "C:\Users\user\Desktop\Python\IT Inventory Manager\inventory.db"
>>>>>>> 7d3917d6df0e8d813971e14adbe99a291f3b30a9

# === Main Form ===
$form = New-Object System.Windows.Forms.Form
$form.Text = "Search Inventory"
$form.Size = New-Object System.Drawing.Size(700, 400)
$form.StartPosition = "CenterScreen"

# === Search TextBox ===
$txtSearch = New-Object System.Windows.Forms.TextBox
$txtSearch.Location = New-Object System.Drawing.Point(20, 20)
$txtSearch.Size = New-Object System.Drawing.Size(400, 25)
$form.Controls.Add($txtSearch)

# === Search Button ===
$btnSearch = New-Object System.Windows.Forms.Button
$btnSearch.Text = "Search"
$btnSearch.Location = New-Object System.Drawing.Point(440, 18)
$btnSearch.Size = New-Object System.Drawing.Size(80, 30)
$form.Controls.Add($btnSearch)

# === DataGridView ===
$grid = New-Object System.Windows.Forms.DataGridView
$grid.Location = New-Object System.Drawing.Point(20, 60)
$grid.Size = New-Object System.Drawing.Size(640, 260)
$grid.ReadOnly = $true
$grid.AutoSizeColumnsMode = 'Fill'
$form.Controls.Add($grid)

# === Close Button ===
$btnClose = New-Object System.Windows.Forms.Button
$btnClose.Text = "Close"
$btnClose.Size = New-Object System.Drawing.Size(80, 30)
$btnClose.Location = New-Object System.Drawing.Point(580, 330)
$btnClose.Add_Click({ $form.Close() })
$form.Controls.Add($btnClose)

# === Button Click ===
$btnSearch.Add_Click({
    $term = $txtSearch.Text.Trim()
    if (-not $term) {
        [System.Windows.Forms.MessageBox]::Show("Please enter a search term.", "Info")
        return
    }

    # === SQL query ===
    $query = "SELECT * FROM devices WHERE name LIKE '%$term%' OR type LIKE '%$term%' OR location LIKE '%$term%' OR status LIKE '%$term%';"

    # === Raw output ===
    $rawOutput = & $sqlitePath $dbPath $query

    if (-not $rawOutput) {
        [System.Windows.Forms.MessageBox]::Show("No results found.", "Info")
        $grid.DataSource = $null
        return
    }

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
   

    $grid.DataSource = $table
})

# === Show Form ===
$form.Topmost = $true
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()
