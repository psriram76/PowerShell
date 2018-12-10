# https://blogs.technet.microsoft.com/canitpro/2016/05/18/powershell-basics-restoring-a-deleted-powershell-user/

function Restore-MDADUser {
  [CmdletBinding()]
  param (
    # The samAccountName of the deleted user
    [Parameter(Mandatory = $true)]
    [string]
    $sAMAccountName
  )

  begin {
    $deletedObjectContainer = (get-addomain).DeletedObjectsContainer
  }
  
  process {
    $distinguishedName = (Get-ADObject -SearchBase $deletedObjectContainer -IncludeDeletedObjects -filter "sAMAccountName -eq '$sAMAccountName'").distinguishedname
    if ($null -eq $distinguishedName) {
      Write-Error "sAMAccountName $sAMAccountName is not found in the Active directory recyle bin." -ErrorAction Stop
    }
    else {
      try {
        Restore-ADObject -Identity $distinguishedName -ErrorAction Stop
      }
      catch {
        Write-Error -Message "Unable to restore $sAMAccount to Active Directory"
      }
    }

    $message = "User $sAMAccountName has been restored: `n"
    $message += (Get-ADUser -Identity $sAMAccountName).DistinguishedName
    Return $message
  } # end process
  
  end {
    Remove-Variable deletedObjectContainer
  }
}

