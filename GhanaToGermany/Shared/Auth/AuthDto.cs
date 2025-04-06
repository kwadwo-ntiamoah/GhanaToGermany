namespace Shared.Auth
{
    public class LocalLoginDto {
        public string Email { get; set; } = null!;
        public string Password {get; set; } = null!;
    }

    public class LocalRegisterDto {
        public string Email { get; set; } = null!;
        public string Password {get; set;} = null!;
    }

    public class SocialRegisterDto {
        public string Email {get; set;} = null!;
        public string FullName {get; set;} = null!;
    }
}