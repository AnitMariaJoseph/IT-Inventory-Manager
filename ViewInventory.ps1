Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# === SQLite paths ===
$sqlitePath = "C:\SQLite\sqlite3.exe"
$dbPath = "C:\Users\user\Desktop\Python\Database project\inventory.db"
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

# === Form ===
$form = New-Object System.Windows.Forms.Form
$form.Text = "IT Asset Inventory"
$form.Size = New-Object System.Drawing.Size(720, 400)
$form.StartPosition = "CenterScreen"

# === DataGridView ===
$grid = New-Object System.Windows.Forms.DataGridView
$grid.Size = New-Object System.Drawing.Size(690, 300)
$grid.Location = New-Object System.Drawing.Point(10, 10)
$grid.ReadOnly = $true
$grid.AutoSizeColumnsMode = 'Fill'
$grid.DataSource = $table
$form.Controls.Add($grid)

# === Close Button ===
$closeBtn = New-Object System.Windows.Forms.Button
$closeBtn.Text = "Close"
$closeBtn.Size = New-Object System.Drawing.Size(80, 30)
$closeBtn.Location = New-Object System.Drawing.Point(610, 320)
$closeBtn.Add_Click({ $form.Close() })
$form.Controls.Add($closeBtn)

# === Show the form ===
$form.Topmost = $true
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()
