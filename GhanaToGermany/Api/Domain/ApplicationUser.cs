using Microsoft.AspNetCore.Identity;

namespace Api.Domain
{
    public class ApplicationUser : IdentityUser
    {
        public bool IsActive { get; set; }

        public List<string> Roles { get; set; } = [];

        public Profile Profile { get; set; } = null!;
    }

    public class Profile
    {
        public Guid Id { get; private set; } = Guid.NewGuid();
        public string Nickname { get; set; } = string.Empty;
        public string Firstname { get; set; } = string.Empty;
        public string Lastname { get; set; } = string.Empty;
        public string ProfilePhoto { get; set; } = string.Empty;
        public string Photos { get; set; } = string.Empty;
        public string ApplicationUserId { get; set; } = string.Empty;
        public ApplicationUser ApplicationUser { get; set; } = null!;

        public string GetName
        {
            get => Firstname + " " + Lastname;
        }
    }
}