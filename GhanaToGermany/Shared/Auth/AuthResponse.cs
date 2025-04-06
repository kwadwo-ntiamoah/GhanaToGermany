namespace Shared.Auth
{
    public class Token
    {
        public string? Key { get; set; }
        public int ExpiryMinutes { get; set; }
        public string Email { get; set; } = string.Empty;
        public bool PendingProfileUpdate { get; set; } = true;
    }

    public class UserInfo
    {
        public string Email { get; set; } = string.Empty;
    }

    public class CheckUsernameResult {
        public bool IsAvailable {get; set;}
        public string? SuggestedUsername {get; set;}
    }
}