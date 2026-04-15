$users = Get-Content "../users.json" | ConvertFrom-Json

foreach ($user in $users) {

    # Check if user exists
    $existing = Get-ADUser -Filter "SamAccountName -eq '$($user.SamAccountName)'" -ErrorAction SilentlyContinue

    if (-not $existing) {
        Write-Host "Creating user: $($user.SamAccountName)"

        New-ADUser `
            -Name $user.Name `
            -SamAccountName $user.SamAccountName `
            -UserPrincipalName $user.UserPrincipalName `
            -Enabled $true `
            -AccountPassword (ConvertTo-SecureString "TempP@ss123!" -AsPlainText -Force)
    }

    # Add to groups
    foreach ($group in $user.Groups) {
        Add-ADGroupMember -Identity $group -Members $user.SamAccountName -ErrorAction SilentlyContinue
    }
}
