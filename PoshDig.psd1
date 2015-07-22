@{
	## Module Info
	ModuleVersion      = '1.0.0.0'
	Description        = 'PoshDig'
	GUID               = 'c347d230-5734-4c40-a084-0579c7bcaf6e'

	## Module Components
	ScriptsToProcess   = @()
	ModuleToProcess    = @('PoshDig.psm1')
	TypesToProcess     = @()
	FormatsToProcess   = @()
	ModuleList         = @('PoshDig.psm1')
	FileList           = @()

	## Public Interface
	CmdletsToExport    = ''
	FunctionsToExport  = @('Get-DNSRecord')
	VariablesToExport  = '*'
	AliasesToExport    = '*'

	## Requirements
	PowerShellVersion      = '3.0'
	PowerShellHostName     = ''
	PowerShellHostVersion  = ''
	RequiredModules        = @()
	RequiredAssemblies     = @()
	ProcessorArchitecture  = 'None'
	DotNetFrameworkVersion = '2.0'
	CLRVersion             = '2.0'

	## Author
	Author             = 'Dylan Addison'
	CompanyName        = 'Malgra'
	Copyright          = ''

	## Private Data
	PrivateData        = ''
}
