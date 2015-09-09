#--------------------------------------------------------------------------------- 

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [String]
        $StartPage,

        [String]
        $SecondaryStartPages
    )
    
    $IEMainReg = 'HKLM:\Software\Microsoft\Internet Explorer\Main' 

    Write-Verbose "Detecting the start page of Internet Explorer."
    $StartPageReg = (Get-ItemProperty -Path $IEMainReg).'Start Page'

    Write-Verbose "Detecting the secondary start pages of Internet Explorer."
    $SecondaryStartPagesReg = (Get-ItemProperty -Path $IEMainReg).'Secondary Start Pages'


    $returnValue = @{
                        #Verify that the value exists, if it does not exist, the value of output is "NULL".
                        StartPage = $(If($StartPageReg){$StartPageReg}Else{"NULL"})
                        SecondaryStartPages = $(If($SecondaryStartPagesReg){$SecondaryStartPagesReg}Else{"NULL"})
                    }

    If($SecondaryStartPages)
    {
        If($($StartPage -eq $StartPageReg) -and $($SecondaryStartPages -eq $SecondaryStartPagesReg))
        {
            $returnValue.Ensure = "Present"
        }
        Else
        {
            $returnValue.Ensure = "Absent"
        }
    }
    Else
    {
        If($StartPage -eq $StartPageReg)
        {
            $returnValue.Ensure = "Present"
        }
        Else
        {
            $returnValue.Ensure = "Absent"
        }
    }

    $returnValue
}


function Set-TargetResource
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    param
    (
        [parameter(Mandatory = $true)]
        [String]
        $StartPage,

        [String]
        $SecondaryStartPages,

        [ValidateSet("Present","Absent")]
        [String]
        $Ensure = 'Present'
    )

    $IEMainReg = 'HKLM:\Software\Microsoft\Internet Explorer\Main' 

    Switch($Ensure)
    {
        #Set the home page of IE
        'Present'
        {
            If($SecondaryStartPages)
            {
                If($PSCmdlet.ShouldProcess("Internet Explorer","Set the start page and secondary start page"))
                {
                    Try
                    {
                        Write-Verbose "Setting the start page of Internet Explorer."
                        Set-ItemProperty -Path $IEMainReg -Name "Start Page" -Value "$StartPage" -ErrorAction Stop
                    
                        Write-Verbose "Setting the secondary start page of Internete Explorer."
                        Set-ItemProperty -Path $IEMainReg -Name "Secondary Start Pages" -Value "$SecondaryStartPages" -ErrorAction Stop
                    }
                    Catch
                    {
                        $ErrorMsg = $_.Exception.Message
                    }
                }
            }
            Else
            {
                If($PSCmdlet.ShouldProcess("Internet Explorer","Set the start page"))
                {
                    Try
                    {
                        Write-Verbose "Setting the start page of Internet Explorer."
                        Set-ItemProperty -Path $IEMainReg -Name "Start Page" -Value "$StartPage" -ErrorAction Stop
                 
                    }
                    Catch
                    {
                        $ErrorMsg = $_.Exception.Message
                    } 
                }
            }
        }

        #Remove the home page of IE
        'Absent'
        {
            If($SecondaryStartPages)
            {
                If($PSCmdlet.ShouldProcess("Internet Explorer","Remove the start page and secondary start page"))
                {
                    Try
                    {
                        Write-Verbose "Removing the start page of Internete Explorer."
                        Set-ItemProperty -Path $IEMainReg -Name "Start Page" -Value "" -ErrorAction Stop

                        Write-Verbose "Removing the secondary start page of Internete Explorer."
                        Set-ItemProperty -Path $IEMainReg -Name "Secondary Start pages" -Value "" -ErrorAction Stop
                    }
                    Catch
                    {
                        $ErrorMsg = $_.Exception.Message
                    }
                }
            }
            Else
            {
                If($PSCmdlet.ShouldProcess("Internet Explorer","Remove the start page"))
                {
                    Try
                    {
                        Write-Verbose "Removing the start page of Internete Explorer."
                        Set-ItemProperty -Path $IEMainReg -Name "Start Page" -Value "" -ErrorAction Stop
                    }
                    Catch
                    {
                        $ErrorMsg = $_.Exception.Message
                    }
                }
            }
        }
    }
}


function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [String]
        $StartPage,

        [String]
        $SecondaryStartPages,

        [ValidateSet("Present","Absent")]
        [String]
        $Ensure = 'Present'
    )


    #Output the result of Get-TargetResource function.
    $Get = Get-TargetResource -StartPage $StartPage -SecondaryStartPages $SecondaryStartPages

    Switch($Ensure)
    {
        'Present'
        {
            If($SecondaryStartPages)
            {
                If($StartPage -eq $Get.StartPage -and $SecondaryStartPages -eq $Get.SecondaryStartPages)
                {
                    return $true
                }
                Else
                {
                    return $false
                }
            }
            Else
            {
                If($StartPage -eq $Get.StartPage -and $SecondaryStartPages -eq $Get.SecondaryStartPages)
                {
                    return $true
                }
                Else
                {
                    return $false
                }
            }
        }

        'Absent'
        {
           If($SecondaryStartPages)
           {
                If($Get.StartPage -eq "NULL" -and $Get.SecondaryStartPages -eq "NULL")
                {
                    return $true
                }
                Else
                {
                    return $false
                }
           }
           Else
           {
                If($Get.StartPage -eq "NULL")
                {
                    return $true
                }
                Else
                {
                    return $false
                }             
           }
        }
    }
}

Export-ModuleMember -Function *-TargetResource


