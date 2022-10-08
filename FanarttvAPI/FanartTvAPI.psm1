$FanartTv_Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$FanartTv_Headers.Add("Content-Type", 'application/json')

Set-Variable -Name "FanartTv_Headers" -Value $FanartTv_Headers -Scope global

Import-FanartTvModuleSettings