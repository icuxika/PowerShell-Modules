# (@(($Env:PSModulePath).Split(";")) -clike (([Environment]::GetFolderPath([System.Environment+SpecialFolder]::MyDocuments)) + "*"))[0]

@(Get-ChildItem -Directory | Select-Object -ExpandProperty Name) | ForEach-Object { Remove-Item -Recurse ((@(($Env:PSModulePath).Split(";")) -clike (([Environment]::GetFolderPath([System.Environment+SpecialFolder]::MyDocuments)) + "*"))[0] + "\" + $_) }