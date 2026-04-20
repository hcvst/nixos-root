# Enhanced Session

To check and enable XRDP enhanced session.

`Get-VMHost | Select-Object EnableEnhancedSessionMode` - to check host
`Get-VM` - to list VMs
`Get-VM -Name "NixAny" | Select-Object EnhancedSessionTransportType` - to check setting (likely `VMBus`)
`Set-VM -VMName "NixAny" -EnhancedSessionTransportType HvSocket` - to change setting to `HvSocket`

Reboot VM