using System.IdentityModel.Tokens.Jwt;
using Api.Application.Common.Abstraction.Services;
using Api.Domain;
using ErrorOr;
using MediatR;
using Microsoft.AspNetCore.Identity;
using Shared.Auth;

namespace Api.Application.Authentication.Commands
{
    public record MobileRegistrationCmd(LocalRegisterDto Payload) : IRequest<ErrorOr<Token>>;

    public class MobileRegistrationCmdHandler(
        UserManager<ApplicationUser> userManager, IJwtService jwtService
    ) : IRequestHandler<MobileRegistrationCmd, ErrorOr<Token>>
    {
        public async Task<ErrorOr<Token>> Handle(MobileRegistrationCmd request, CancellationToken cancellationToken)
        {
            // check if user with username already exists
            var user = await userManager.FindByEmailAsync(request.Payload.Email);

            if (user != null) return new Error[] { Error.Conflict(description: "User already exists") };

            // create user with details
            var newUser = new ApplicationUser
            {
                Email = request.Payload.Email,
                UserName = request.Payload.Email,
            };

            var createUserResponse = await userManager.CreateAsync(newUser, request.Payload.Password);

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