using Api.Application.Common.Abstraction.Services;
using Api.Application.Common.Errors;
using Api.Domain;
using ErrorOr;
using FluentValidation;
using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Shared.Auth;

namespace Api.Application.Authentication.Queries
{
    public record LocalLoginQuery(string Email, string Password): IRequest<ErrorOr<UserInfo>>;

    public class LocalLoginQueryValidator: AbstractValidator<LocalLoginQuery> {
        public LocalLoginQueryValidator()
        {
            RuleFor(x => x.Email).NotEmpty().NotNull().WithMessage("Username is required");
            RuleFor(x => x.Password).NotEmpty().NotNull().WithMessage("Password is required");
        }
    }

    public class LocalLoginQueryHandler(
        UserManager<ApplicationUser> userManager, 
        SignInManager<ApplicationUser> signInManager) : IRequestHandler<LocalLoginQuery, ErrorOr<UserInfo>>
    {
        public async Task<ErrorOr<UserInfo>> Handle(LocalLoginQuery request, CancellationToken cancellationToken)
        {
            var user = await userManager.Users
                .Include(x => x.Profile)
                .FirstOrDefaultAsync(x => x.Email == request.Email, cancellationToken: cancellationToken);
            
            if (user == null) return new Error[] { Errors.Auth.InvalidCredentials };

            if (!await userManager.CheckPasswordAsync(user, request.Password))
                return new Error[] { Errors.Auth.InvalidCredentials };
            
            await signInManager.SignInAsync(user, false);
            
            var userInfo = new UserInfo
            {
                Email = user.Email!
            };

            return userInfo;

        }
    }
}