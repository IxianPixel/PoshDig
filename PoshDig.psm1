param()

. {
    param
    (
        [String]
        $DigPath = 'C:\cmder\tools\dig\dig.exe'
    )
    
    Function Get-DNSRecord()
    {
        <#
            .SYNOPSIS
            Performs a DNS lookup.

            .DESCRIPTION
            Performs a DNS lookup using dig. Requires a least a hostname to perform the lookup. If no record type is specified, all supported record types will be returned. If no DNS server is specified the DNS server on the local adapter will be used.
        #>
        param
        (
            [Parameter(Mandatory=$true, Position=1)]
            [String]
            $Hostname,
        
            [Parameter(Position=2)]
            [ValidateSet('Any', 'A', 'MX', 'TXT', 'NS', 'CNAME')]
            [String]
            $RecordType = 'Any',
        
            [Parameter(Position=3)]
            [String]
            $DNSServer
        )
    
        $command = "& $DigPath $RecordType $Hostname +noall +answer"
        if ($DNSServer)
        {
            $command = "& $DigPath ``@$DNSServer $RecordType $Hostname +noall +answer"
        }
      
        $answers = Invoke-Expression -Command $command
        $answers = $answers | Select-Object -Skip 3
        return Start-AnswerProcessing -Answers $answers
    }

    Function Start-AnswerProcessing
    {
        param
        (
            [Parameter(Mandatory=$true)]
            [System.String[]]
            $Answers
        )

        $dnsRecords = @()
        ForEach($answer in $answers)
        {
            $recordType = Get-RecordType -Record $answer
        
            $dnsRecord = $null
        
            Switch($recordType)
            {
                'MX' { $dnsRecord = Format-MXRecord -Record $answer }
                'A' { $dnsRecord = Format-StandardRecord -Record $answer }
                'NS' { $dnsRecord = Format-StandardRecord -Record $answer }
                'TXT' { $dnsRecord = Format-StandardRecord -Record $answer }
                'CNAME' { $dnsRecord = Format-StandardRecord -Record $answer }
            }
        
            if ($dnsRecord -ne $null)
            {
                $dnsRecords += $dnsRecord
            }
        }
       
        return $dnsRecords
    }

    Function Get-RecordType
    {
        param
        (
            [Parameter(Mandatory=$true)]
            [System.String]
            $Record
        )
     
        $recordType = 'Unknown'
        $regex = '(?:\S+)(?:\s{1,3})(?:\d+)(?:\s{1}IN\s{1})(?<type>\w+)'
        $type = $Record -match $regex

        if ($type -eq $true)
        {
            $recordType = $Matches['type']
        }
    
        return $recordType
    }

    Function Format-MXRecord
    {
         param
         (
             [Parameter(Mandatory=$true)]
             [System.String]
             $Record
         )

        $dnsRecord = $null
        $regex = '(?<hostname>\S+)(?:\s{1,3})(?<ttl>\d+)(?:\s{1}IN\s{1})(?<type>\w+)(?:\s{1})(?<priority>\d+)(?:\s{1})(?<value>\S+)'
        $recordMatch = $Record -match $regex
    
        if ($recordMatch -eq $true)
        {
            $dnsRecord = New-DNSRecord -Hostname $Matches['hostname'] -TTL $Matches['ttl'] -RecordType $Matches['type'] -Priority $Matches['priority'] -Value $Matches['value']
        }

        return $dnsRecord
    }

    Function Format-StandardRecord
    {
         param
         (
             [Parameter(Mandatory=$true)]
             [System.String]
             $Record
         )

        $dnsRecord = $null
        $regex = '(?<hostname>\S+)(?:\s{1,3})(?<ttl>\d+)(?:\s{1}IN\s{1})(?<type>\w+)(?:\s{1})(?<value>[\s\S]+)'
        $recordMatch = $Record -match $regex
    
        if ($recordMatch -eq $true)
        {
            $dnsRecord = New-DNSRecord -Hostname $Matches['hostname'] -TTL $Matches['ttl'] -RecordType $Matches['type'] -Value $Matches['value']
        }

        return $dnsRecord
    }

    Function New-DNSRecord
    {
         param
         (
             [Parameter(Mandatory=$true)]
             [System.String]
             $Hostname,

             [Parameter(Mandatory=$true)]
             [System.Int32]
             $TTL,

             [Parameter(Mandatory=$true)]
             [System.String]
             $RecordType,

             [System.Int32]
             $Priority = 0,

             [Parameter(Mandatory=$true)]
             [System.String]
             $Value
         )
     
         $record = New-Object -TypeName PSCustomObject
     
         Add-Member -InputObject $record -MemberType NoteProperty -Name Hostname -Value $Hostname
         Add-Member -InputObject $record -MemberType NoteProperty -Name TTL -Value $TTL
         Add-Member -InputObject $record -MemberType NoteProperty -Name RecordType -Value $RecordType
         Add-Member -InputObject $record -MemberType NoteProperty -Name Priority -Value $Priority
         Add-Member -InputObject $record -MemberType NoteProperty -Name Value -Value $Value
     
         return $record
    }
} @args

