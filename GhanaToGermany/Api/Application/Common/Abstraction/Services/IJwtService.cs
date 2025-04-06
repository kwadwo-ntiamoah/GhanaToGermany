namespace Api.Application.Common.Abstraction.Services;

public interface IJwtService
{
    public string GenerateToken(string email, List<string> roles);
}