using Api.Application.Common.Abstraction.Services;
using Api.Application.Common.Errors;
using Api.Domain;
using ErrorOr;
using FluentValidation;
using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Shared.Auth;
using Shared.Profile;

namespace Api.Application.Authentication.Queries
{
    public record LocalLoginQuery(string Email, string Password) : IRequest<ErrorOr<ProfileResponse>>;

    public class LocalLoginQueryValidator : AbstractValidator<LocalLoginQuery>
    {
        public LocalLoginQueryValidator()
        {
            RuleFor(x => x.Email).NotEmpty().NotNull().WithMessage("Username is required");
            RuleFor(x => x.Password).NotEmpty().NotNull().WithMessage("Password is required");
        }
    }

    public class LocalLoginQueryHandler(
        UserManager<ApplicationUser> userManager,
        SignInManager<ApplicationUser> signInManager) : IRequestHandler<LocalLoginQuery, ErrorOr<ProfileResponse>>
    {
        public async Task<ErrorOr<ProfileResponse>> Handle(LocalLoginQuery request, CancellationToken cancellationToken)
        {
            try {
var user = await userManager.Users
                .Include(x => x.Profile)
                .FirstOrDefaultAsync(x => x.Email == request.Email, cancellationToken: cancellationToken);

            if (user == null) return new Error[] { Errors.Auth.InvalidCredentials };

            if (!await userManager.CheckPasswordAsync(user, request.Password))
                return new Error[] { Errors.Auth.InvalidCredentials };

            await signInManager.SignInAsync(user, false);

            if (user.Profile == null && user.Email == "admin@admin.com")
            {
                return new ProfileResponse(
                Email: user.Email ?? "N/A",
                Nickname: "Admin",
                FullName: "Admin",
                ProfilePhoto: "https://cdn.pixabay.com/photo/2015/10/05/22/37/admin-980600_1280.png",
                Photos: ""
                );
            }

            return new ProfileResponse(
                Email: user.Email ?? "N/A",
                Nickname: user.Profile.Nickname,
                FullName: user.Profile.GetName,
                ProfilePhoto: user.Profile.ProfilePhoto,
                Photos: user.Profile.Photos
            );

            } catch(Exception ex) {
                return new Error[] { Error.Failure(description: ex.Message)};
            }
        }
    }
}