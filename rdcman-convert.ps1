<#
  VERSION: 1.0.0
#>
$file = $args[0]
$fileName = get-item $file | Select Name -ExpandProperty Name
$fileName = $fileName -replace ".rdg",""
$outputName = ($fileName + ".rdb")
$content = Get-Content -Path $file
$name = $content | Select-String -Pattern "<name>","</name>"
$name = $name -replace "<name>","" -replace "</name>","" -replace " ",""


write-output @"
{
  "Version": 0.2,
  "GeneralSettings": {
    "UseThumbnails": true,
    "SendFeedback": true,
    "DisableInSessionLockScreen": false,
    "KeyboardInterceptorMode": 0,
    "ConnectFullscreen": true,
    "StartInNewWindow": true,
    "SessionResizeMode": 0,
    "LastShownConnectionCenterTab": 0,
    "PreferredTheme": 2,
    "ResizeOnFullscreen": false,
    "PersistentModelId": "00000000-0000-0000-0000-000000000000"
  },
  "Credentials": [],
  "Groups": [
    {
      "Name": "$fileName",
      "PersistentModelId": "ac66c7aa-4257-402e-813a-d61706d56051"
    }
  ],
  "Gateways": [],
  "Connections": [
"@ | Out-File ./$outputName -Force


foreach ($n in $name) {
    write-output @"
    {
      "HostName": "$n",
      "GroupId": "ac66c7aa-4257-402e-813a-d61706d56051",
      "FriendlyName": "",
      "LocalResourcesSettings": {
        "RedirectClipboard": true,
        "PersistentModelId": "00000000-0000-0000-0000-000000000000"
      },
       "PersistentModelId": "49cab540-22f1-4c2d-b9a9-0d307cee677c"
    },
"@ | Out-File ./$outputName -Append
} 
$content = Get-Content ./$outputName
$content[-1] = $content[-1] -replace ",",""
$content | Set-Content ./$outputName