using Api.Domain;
using Microsoft.AspNetCore.Identity;

namespace Api.Infrastructure.Persistence;

public static class IdentitySeeder
    {
        public static async Task CreateDefaultUsers(UserManager<ApplicationUser> userManager, RoleManager<IdentityRole> roleManager, IConfiguration config)
        {
            var roles = new List<string>()
            {
                "Admin",
                "Teller",
                "Branch Authorizer",
                "Branch Operations"
            };

            foreach (var identityRole in roles.Select(role => new IdentityRole
                     {
                         Name = role
                     }))
            {
                // Create the role if it doesn't already exist
                if (identityRole.Name != null && await roleManager.RoleExistsAsync(roleName: identityRole.Name)) continue;
                var result = await roleManager.CreateAsync(identityRole);

                if (!result.Succeeded)
                    throw new Exception(string.Join(".", result.Errors.Select(x => x.Description)));
            }

            var defaultUsers = new List<SeedUser>();
            config.GetSection("SeedUsers").Bind(defaultUsers);

            foreach (var user in defaultUsers)
            {
                if (await userManager.FindByNameAsync(user.UserName) != null) continue;
                ApplicationUser defaultUser = new()
                {
                    UserName = user.Email,
                    Email = user.Email,
                    IsActive = true,
                    Roles = user.Roles ?? []
                };

                IdentityResult result;

                if (string.IsNullOrEmpty(user.Password))
                    result = await userManager.CreateAsync(defaultUser);
                else
                    result = await userManager.CreateAsync(defaultUser, user.Password);

                if (!result.Succeeded)
                    throw new Exception(string.Join(".", result.Errors.Select(x => x.Description)));

                if (!(user.Roles?.Count > 0)) continue;
                {
                    result = await userManager.AddToRolesAsync(defaultUser, user.Roles);

                    if (!result.Succeeded)
                        throw new Exception(string.Join(".", result.Errors.Select(x => x.Description)));
                }
            }
        }
    }

    public class SeedUser
    {
        public string UserName { get; set; } = string.Empty;

        public string Email { get; set; } = string.Empty;

        public string Password { get; set; } = string.Empty;

        public List<string> Roles { get; set; } = [];
    }