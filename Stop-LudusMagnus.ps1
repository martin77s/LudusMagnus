param(
    [Parameter(Mandatory=$true)]
	[string] $ResourceGroupName,

    [switch] $ShutdownOnly
)

if($ResourceGroupName -match '*') {
	Write-Warning 'Wildcard specified in the resource group name. Please run again with one resource gorup name:'
	Get-AzResourceGroup -Name $ResourceGroupName | Select-Object -ExpandProperty ResourceGroupName
}

if (Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue) {
    if($ShutdownOnly) {
        $vms = Get-AzVM -ResourceGroupName $ResourceGroupName
        Write-Verbose ('ShutdownOnly switch specified. Shutting down {0} VM(s)' -f $vms.Count) -Verbose
        $jobs = foreach($vm in $vms) {
            Stop-AzVM -ResourceGroupName $ResourceGroupName -Name $vm.Name -Force -NoWait -Verbose
        }
        $jobs
    } else {
        Remove-AzResourceGroup -Name $ResourceGroupName -Force -Verbose
    }
} else {
	Write-Warning 'The specified resource group does not exist'
}