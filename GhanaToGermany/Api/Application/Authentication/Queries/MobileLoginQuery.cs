using Api.Application.Common.Abstraction.Services;
using Api.Application.Common.Errors;
using Api.Domain;
using ErrorOr;
using FluentValidation;
using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Shared.Auth;

namespace Api.Application.Authentication.Queries;

public record MobileLoginQuery(string Email, string Password): IRequest<ErrorOr<Token>>;

public class MobileLoginQueryValidator: AbstractValidator<MobileLoginQuery> {
    public MobileLoginQueryValidator()
    {
        RuleFor(x => x.Email).NotEmpty().NotNull().WithMessage("Email is required");
        RuleFor(x => x.Password).NotEmpty().NotNull().WithMessage("Password is required");
    }
}

public class MobileLoginQueryHandler(
    UserManager<ApplicationUser> userManager, 
    IJwtService jwtService) : IRequestHandler<MobileLoginQuery, ErrorOr<Token>>
{

    public async Task<ErrorOr<Token>> Handle(MobileLoginQuery request, CancellationToken cancellationToken)
    {
        var user = await userManager.Users
            .Include(x => x.Profile)
            .FirstOrDefaultAsync(x => x.Email == request.Email, cancellationToken: cancellationToken);
            
        if (user == null) return new Error[] { Errors.Auth.InvalidCredentials };

        if (!await userManager.CheckPasswordAsync(user, request.Password))
            return new Error[] { Errors.Auth.InvalidCredentials };
        
        // generate token
        var tokenKey = jwtService.GenerateToken(request.Email, []);
        var token = new Token
        {
            Key = tokenKey,
            ExpiryMinutes = 129600,
            PendingProfileUpdate = user.Profile == null,
            Email = user.Email
        };

        return token;
    }
}