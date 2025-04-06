using MediatR;
using ErrorOr;
using Shared.Auth;
using Microsoft.AspNetCore.Identity;
using Api.Domain;
using Api.Application.Common.Abstraction.Services;

namespace Api.Application.Authentication.Commands
{
    public record SocialLoginCmd(SocialRegisterDto Payload) : IRequest<ErrorOr<Token>>;

    public class SocialLoginCmdHandler(UserManager<ApplicationUser> userManager, IJwtService jwtService) : IRequestHandler<SocialLoginCmd, ErrorOr<Token>>
    {
        public async Task<ErrorOr<Token>> Handle(SocialLoginCmd request, CancellationToken cancellationToken)
        {
            // check if email already exists
            var user = await userManager.FindByEmailAsync(request.Payload.Email);

            if (user != null)
            {
                // generate token
                var tokenKey = jwtService.GenerateToken(request.Payload.Email, []);
                var token = new Token
                {
                    Key = tokenKey,
                    ExpiryMinutes = 262800,
                    PendingProfileUpdate = user.Profile == null,
                    Email = request.Payload.Email
                };

                return token;
            }
            else
            {
                // create user
                var newUser = new ApplicationUser
                {
                    Email = request.Payload.Email,
                    UserName = request.Payload.Email
                };

                var createUserResponse = await userManager.CreateAsync(newUser);

                if (createUserResponse.Succeeded)
                {
                    // generate token
                    var tokenKey = jwtService.GenerateToken(request.Payload.Email, []);
                    var token = new Token
                    {
                        Key = tokenKey,
                        ExpiryMinutes = 262800,
                        PendingProfileUpdate = newUser.Profile == null,
                        Email = newUser.Email
                    };

                    return token;
                }
                else
                {
                    return new Error[] { Error.Failure(description: createUserResponse.Errors.First().Description) };
                }
            }
        }
    }
}