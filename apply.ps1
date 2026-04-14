$users = Get-Content users.json | ConvertFrom-Json

foreach ($user in $users) {
    if ($user.Groups -contains "Domain Admins") {
        throw "❌ Direct Domain Admin assignment is запрещено (forbidden)"
    }
}
