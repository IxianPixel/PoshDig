# PoshDig
A wrapper for the command line tool - dig.

### Requirements
This module is dependent on dig for Windows. Dig can be downloaded for free from
the [ISC](https://www.isc.org/downloads/). Under the Bind section you can download
the latest stable version of Bind for Windows. In the zip file there will be a dig.exe

### Dig Path
This module requires the path to your dig executable. This can be achieved in one of 2 ways.

The first way is to modify PoshDig.psm1. On line 7 there is a DigPath variable which should be the path to your dig executable.

The second way is to provide the path when you run the `Import-Module` command. For example you could run `Import-Module PoshDig -ArgumentList 'C:\dig\dig.exe'`.

### Cmdlet
There is only one cmdlet exported on this module and it's `Get-DNSRecord`. Only one of it's parameters is required which is the hostname. The other parameters allow you to specify which record types to return. By default it will return all of them. You can also specify a specific DNS server, otherwise it will use the one on the local adapter.
