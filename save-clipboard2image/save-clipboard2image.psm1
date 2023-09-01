function Save-Clipboard2Image {
    Add-Type -AssemblyName 'System.Windows.Forms'

    $chinese = [System.Globalization.CultureInfo]::CurrentCulture.Name -eq 'zh-CN'

    $dialog = New-Object System.Windows.Forms.Form
    $dialog.AutoSize = $true
    $dialog.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink
    if ($chinese) {
        $dialog.Text = '保存屏幕截图到文件'
    }
    else {
        $dialog.Text = 'Save screenshot to file'
    }

    $dialogLayout = New-Object System.Windows.Forms.FlowLayoutPanel
    $dialogLayout.AutoSize = $true
    $dialogLayout.FlowDirection = [System.Windows.Forms.FlowDirection]::TopDown
    $dialogLayout.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink

    $messageLabel = New-Object System.Windows.Forms.Label
    $messageLabel.AutoSize = $true
    $messageLabel.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom
    if ($chinese) {
        $messageLabel.Text = "选择要保存截图的文件夹并输入文件名称，文件名需要以.png为后缀"
    }
    else {
        $messageLabel.Text = "Select the folder where you want to save the screenshot and enter the file name, which needs to be suffixed with .png"
    }


    $folderTextBox = New-Object System.Windows.Forms.TextBox
    $folderTextBox.Text = [Environment]::GetFolderPath([System.Environment+SpecialFolder]::UserProfile) + "\Downloads\temp"
    $folderTextBox.Size = New-Object System.Drawing.Size(335, 23)
    $folderTextBox.ReadOnly = $true

    $filePath = [Environment]::GetFolderPath([System.Environment+SpecialFolder]::UserProfile) + "\Downloads\temp" + (Get-Date -UFormat "%Y-%m-%d").ToString() + "-" + (Get-Random).ToString() + ".png"
    $button = New-Object System.Windows.Forms.Button
    $button.Text = "选择文件夹"
    $button.add_click({
            $openFileDialog = New-Object System.Windows.Forms.FolderBrowserDialog
            $openFileDialog.Description = "Select the directory that you want to use as the default.";
            $openFileDialog.RootFolder = [System.Environment+SpecialFolder]::UserProfile;
            if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
                $filePath = $openFileDialog.SelectedPath;
                $folderTextBox.Text = $filePath
            }
        })

    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Text = (Get-Date -UFormat "%Y-%m-%d").ToString() + "-" + (Get-Random).ToString() + ".png"
    $textBox.Size = New-Object System.Drawing.Size(335, 23)

    $selectButtonPanel = New-Object System.Windows.Forms.FlowLayoutPanel
    $selectButtonPanel.AutoSize = $true
    $selectButtonPanel.Anchor = [System.Windows.Forms.AnchorStyles]::Right
    $selectButtonPanel.FlowDirection = [System.Windows.Forms.FlowDirection]::LeftToRight
    $selectButtonPanel.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink

    $yesButton = New-Object System.Windows.Forms.Button
    $noButton = New-Object System.Windows.Forms.Button
    $yesButton.DialogResult = [System.Windows.Forms.DialogResult]::Yes
    $noButton.DialogResult = [System.Windows.Forms.DialogResult]::No

    if ($chinese) {
        $yesButton.Text = '是'
        $noButton.Text = '否'
    }
    else {
        $yesButton.Text = 'Yes'
        $noButton.Text = 'No'
    }
    $selectButtonPanel.Controls.Add($yesButton)
    $selectButtonPanel.Controls.Add($noButton)

    $dialogLayout.Controls.Add($messageLabel)
    $dialogLayout.Controls.Add($button)
    $dialogLayout.Controls.Add($folderTextBox)
    $dialogLayout.Controls.Add($textBox)
    $dialogLayout.Controls.Add($selectButtonPanel)

    $dialog.Controls.Add($dialogLayout)

    $result = $dialog.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
        Write-Host $result
        Write-Host $folderTextBox.Text
        Write-Host $textBox.Text

        if ($([System.Windows.Forms.Clipboard]::ContainsImage())) {
            $image = [System.Windows.Forms.Clipboard]::GetImage()
            $filename = $folderTextBox.Text + "\" + $textBox.Text
            Write-Host $filename
            $image.Save($filename, [System.Drawing.Imaging.ImageFormat]::Png)
        }
        else {
            Write-Host "剪切板没有图片文件"
        }
    }
}
Export-ModuleMember -Function Save-Clipboard2Image

