# GUI for RustDesk Instance Selection
#
# (c) 2024 by suuhm
#

[string]$global:IPATH=""

Function Create-GUI {
    Param(
        [string]$RustDeskExePath,
        [string]$InstanzPath
    )

    $Form = New-Object System.Windows.Forms.Form
    $Form.Text = "RustDesk Multi Instance (c) 2024 by suuhm"
    $Form.Size = New-Object System.Drawing.Size(400, 380)
    $Form.FormBorderStyle = "FixedDialog"
    $Form.MaximizeBox = $false

    $ButtonBrowseRustDesk = New-Object System.Windows.Forms.Button
    $ButtonBrowseRustDesk.Text = "Browse RustDesk.exe"
    $ButtonBrowseRustDesk.Size = New-Object System.Drawing.Size(150, 30)
    $ButtonBrowseRustDesk.Location = New-Object System.Drawing.Point(20, 20)
    $ButtonBrowseRustDesk.add_Click({
        $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
        $openFileDialog.Filter = "Executable Files (*.exe)|*.exe"
        if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            $global:RustDeskExePath = $openFileDialog.FileName
        }
    })
    $Form.Controls.Add($ButtonBrowseRustDesk)

    $ButtonBrowseInstanz = New-Object System.Windows.Forms.Button
    $ButtonBrowseInstanz.Text = "Browse Instance Path"
    $ButtonBrowseInstanz.Size = New-Object System.Drawing.Size(150, 30)
    $ButtonBrowseInstanz.Location = New-Object System.Drawing.Point(20, 60)
    $ButtonBrowseInstanz.add_Click({
        $folderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
        if ($folderBrowserDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            $InstanzPath = $folderBrowserDialog.SelectedPath
            UpdateListView $InstanzPath
            $global:IPATH=$InstanzPath
        }
    })
    $Form.Controls.Add($ButtonBrowseInstanz)

    Function UpdateListView {
        Param([string]$path)
        $ListView.Items.Clear()
        $instanzDirs = Get-ChildItem -Path $path -Directory | Select-Object -ExpandProperty Name
        foreach ($dir in $instanzDirs) {
            $listViewItem = New-Object System.Windows.Forms.ListViewItem
            $listViewItem.Text = $dir
            $ListView.Items.Add($listViewItem)
        }
    }

    $ListView = New-Object System.Windows.Forms.ListView
    $ListView.Size = New-Object System.Drawing.Size(350, 150)
    $ListView.Location = New-Object System.Drawing.Point(20, 100)
    $ListView.View = [System.Windows.Forms.View]::Details
    $ListView.Columns.Add("Instances", 350)
    $Form.Controls.Add($ListView)

    # Start Button
    $ButtonStart = New-Object System.Windows.Forms.Button
    $ButtonStart.Text = "Start Instance"
    $ButtonStart.Size = New-Object System.Drawing.Size(150, 30)
    $ButtonStart.Location = New-Object System.Drawing.Point(20, 260)
    $ButtonStart.add_Click({
        $selectedItems = $ListView.SelectedItems
        if ($selectedItems.Count -eq 1) {
            $selectedInstanzPath = Join-Path -Path $global:IPATH -ChildPath ($selectedItems[0].Text)
            Write-Host $global:RustDeskExePath " - and " + $selectedInstanzPath 
            Set-ItemProperty -Path 'HKCU:\Environment' -Name APPDATA -Value $selectedInstanzPath
            Start-Process -FilePath $global:RustDeskExePath -NoNewWindow -WorkingDirectory $selectedInstanzPath
        }
    })
    $Form.Controls.Add($ButtonStart)

    $ButtonCreateInstanz = New-Object System.Windows.Forms.Button
    $ButtonCreateInstanz.Text = "Create Instance"
    $ButtonCreateInstanz.Size = New-Object System.Drawing.Size(150, 30)
    $ButtonCreateInstanz.Location = New-Object System.Drawing.Point(200, 60)
    $ButtonCreateInstanz.add_Click({
        $instanzName = Show-InputBox -Prompt "Enter Instance Name"
        #$instanzName = "Public"
        if ($instanzName -ne "") {
            $newInstanzPath = Join-Path -Path $global:IPATH -ChildPath $instanzName
            if (!(Test-Path $newInstanzPath)) {
                New-Item -ItemType Directory -Path $newInstanzPath
                $sourcePath = Join-Path -Path $env:APPDATA -ChildPath "RustDesk"
                $st = Join-Path -Path $global:IPATH -ChildPath "RustDesk"
                if ($(Test-Path $sourcePath) -and $(!$(Test-Path $st))) {
                    Write-Host "copy " + $sourcePath + " to " + $st
                    Copy-Item -Recurse -Path $sourcePath -Destination $global:IPATH
                }
                UpdateListView $global:IPATH
                Write-Output "New Instance '$instanzName' created successfully."
            } else {
                Write-Output "Instance '$instanzName' already exists."
            }
        } else {
            Write-Output "No instance name entered."
        }
    })
    $Form.Controls.Add($ButtonCreateInstanz)

    $Form.ShowDialog()
}

# Function for input box
Function Show-InputBox {
    Param(
        [string]$Prompt
    )
    $result = Read-Host -Prompt $Prompt
    return $result
}

# Start GUI
Create-GUI
