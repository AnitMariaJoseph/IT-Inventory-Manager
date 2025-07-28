Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# === SQLite paths ===
$sqlitePath = "C:\SQLite\sqlite3.exe"
$dbPath = "C:\Users\user\Desktop\Python\IT Inventory Manager\inventory.db"

# === Form ===
$form = New-Object Windows.Forms.Form
$form.Text = "Add Asset"
$form.Size = '350,300'
$form.StartPosition = 'CenterScreen'

# === Label + TextBox Helper ===
function Add-Field($text, $top) {
    $label = New-Object Windows.Forms.Label
    $label.Text = $text
    $label.Location = "20,$top"
    $label.Size = '100,20'
    $form.Controls.Add($label)

    $textbox = New-Object Windows.Forms.TextBox
    $textbox.Location = "130,$top"
    $textbox.Size = '180,20'
    $form.Controls.Add($textbox)

    return $textbox
}

$nameBox     = Add-Field "Device Name:" 30
$typeBox     = Add-Field "Device Type:" 70
$locationBox = Add-Field "Location:" 110
$statusBox   = Add-Field "Status:" 150

# === Add Button ===
$addBtn = New-Object Windows.Forms.Button
$addBtn.Text = "Add"
$addBtn.Location = "130,200"
$addBtn.Size = '80,30'
$addBtn.Add_Click({
    $name = $nameBox.Text
    $type = $typeBox.Text
    $location = $locationBox.Text
    $status = $statusBox.Text

    if ($name -and $type -and $location -and $status) {
        $query = "INSERT INTO devices (name, type, location, status) VALUES ('$name', '$type', '$location', '$status');"
        & $sqlitePath $dbPath $query
        [Windows.Forms.MessageBox]::Show("Asset added.")
        $form.Close()
    } else {
        [Windows.Forms.MessageBox]::Show("Fill all fields.")
    }
})

$form.Controls.Add($addBtn)

$form.Topmost = $true
$form.ShowDialog()
