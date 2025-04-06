using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Api.Application.Common.Abstraction.Services;
using Microsoft.IdentityModel.Tokens;

namespace Api.Infrastructure.Services;

public class JwtService(IConfiguration config): IJwtService
{
    public string GenerateToken(string email, List<string> roles)
    {
        var key = Encoding.UTF8.GetBytes(config["JWT:Key"]!);
        var issuer = config["Jwt:Issuer"];
        var audience = config["Jwt:Audience"];

        var claims = roles.Select(x => new Claim(ClaimTypes.Role, x)).ToList();

        claims.Add(new Claim(JwtRegisteredClaimNames.Sub, email));
        claims.Add(new Claim(JwtRegisteredClaimNames.Sid, Guid.NewGuid().ToString()));
        claims.Add(new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()));
        claims.Add(new Claim(JwtRegisteredClaimNames.Email, email));

        var tokenKey = new SymmetricSecurityKey(key);
        var credentials = new SigningCredentials(tokenKey, SecurityAlgorithms.HmacSha256);

        var token = new JwtSecurityToken(
            issuer: issuer,
            audience: audience,
            claims: claims,
            expires: DateTime.UtcNow.AddDays(1),
            signingCredentials: credentials
        );

        var tokenString = new JwtSecurityTokenHandler().WriteToken(token);
        return tokenString;
    }
}