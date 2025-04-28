using System.Security.Claims;
using Api.Domain;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;

namespace Api.Helpers;

public class CustomUserClaimsPrincipalFactory(
    UserManager<ApplicationUser> userManager,
    RoleManager<IdentityRole> roleManager,
    IOptions<IdentityOptions> optionsAccessor)
    : UserClaimsPrincipalFactory<ApplicationUser, IdentityRole>(userManager, roleManager, optionsAccessor)
{
    protected override async Task<ClaimsIdentity> GenerateClaimsAsync(ApplicationUser user)
    {
        var identity = await base.GenerateClaimsAsync(user);

        var roles = await UserManager.GetRolesAsync(user);

        identity.AddClaim(new Claim(ClaimTypes.Email, user.Email!));      
        identity.AddClaim(new Claim(ClaimTypes.NameIdentifier, user.Id));

        foreach (var role in roles)
        {
            identity.AddClaim(new Claim(ClaimsIdentity.DefaultRoleClaimType, role));
        }

        return identity;
    }

}