########### CONFIG ###########

$booksonicDirectory = "$($env:SystemDrive)\Booksonic"
$port = 4040
$filename = "booksonic.war"
$repo = "popeen/Booksonic-Air"

########### CONFIG ###########


function Invoke-ElevateIfNeeded{
    param(
        [ValidateSet("AllSigned", "Bypass", "Default", "RemoteSigned", "Restricted")]
        [String]
        $ExecutionPolicy = "Default"
    )
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    $isElevated = (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    if(-not $isElevated){
        Start-Process powershell -Verb runAs -ArgumentList "-ExecutionPolicy $ExecutionPolicy -File $PSCommandPath"
        break
    }
}

Invoke-ElevateIfNeeded -ExecutionPolicy Bypass


if(-not (Get-Command java)){
    Write-Host "No java installation was detected. Booksonic requires Java to run. Please install Java and then run this script again"
    pause
    break
}

if(-not (Invoke-WebRequest -uri "https://google.com")){ #Invoke-Webrequest will throw an error if internet explorer has never been opened on the computer
    Write-Host "Due to a limitation in powershell you need to have opened internet explorer at least once on this computer before you can run this script"
    Write-Host "Starting internet explorer and closing it again"
    Start-Process iexplore.exe
    Start-Sleep 5
    Stop-Process -Name iexplore
}

########### Install Booksonic if needed ###########
if(-not (Test-Path $booksonicDirectory)){

    Write-Host "Booksonic has not been installed yet."
    Write-Host "The script will now download and install Booksonic"

    
    Write-Host "Creating Booksonic directory"
    New-Item -Name "Booksonic" -Path "$($env:SystemDrive)\" -ItemType Directory| Out-Null
    
    Write-Host "Copying start script to correct folder"
    Copy-Item -Path $MyInvocation.MyCommand.Path -Destination "$booksonicDirectory\start-booksonic.ps1"


    ########### Start Booksonic on boot ###########
    Write-Host "Setting up scheduled task for starting Booksonic on boot"
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument " -ExecutionPolicy Bypass -File $booksonicDirectory\start-booksonic.ps1"
    $trigger = New-ScheduledTaskTrigger -AtStartup
    $principal = New-ScheduledTaskPrincipal -LogonType S4U -UserID "NT AUTHORITY\SYSTEM"
    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Booksonic start on boot" -Description "Starts Booksonic when the computer is rebooted" -Principal $principal| Out-Null

}

Set-Location -Path $booksonicDirectory



########### Check for for updates ###########

$json = Invoke-WebRequest -Uri "https://api.github.com/repos/$repo/releases/latest"| Select-Object -ExpandProperty Content| ConvertFrom-Json
$latestVersion = $json| Select-Object -ExpandProperty tag_name

if(-not (Test-Path .\version)){

    Write-Host "This is the first time Booksonic is running on this computer"
    $firstRun = $true

}
else{

    Write-Host "Checking if a new update is available"
    $installedVersion = Get-Content .\version -Raw
        
    if($installedVersion.trim() -ne $latestVersion.trim()){

        Write-Host "A new version of Booksonic has been released"
        $shouldUpdate = $true

    }else{
        Write-Host "Latest version already installed"
    }

}



########### Download update ###########

if($firstRun -OR $shouldUpdate){

    Write-Host "Downloading Booksonic $latestVersion, this can take a few minutes"
    (New-Object System.Net.WebClient).DownloadFile($json.assets[0].browser_download_url, "$booksonicDirectory\$filename")
    $latestVersion| Out-File .\version -Encoding ascii

}



########### Start Booksonic ###########

Write-Host "Starting Booksonic"
cmd /c "java -Dairsonic.home=`"$($booksonicDirectory.replace("\", "\\"))`" -Dserver.port=$port -jar $filename"