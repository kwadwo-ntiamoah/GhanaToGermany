using System.Security.Claims;
using Api.Domain;
using Api.Infrastructure.Persistence;
using ErrorOr;
using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Shared.Profile;

namespace Api.Application.Profiles.Queries
{
    public record GetProfileQuery : IRequest<ErrorOr<ProfileResponse>>;

    public class GetProfileQueryHandler(AppDbContext context, IHttpContextAccessor httpContextAccessor, UserManager<ApplicationUser> userManager) : IRequestHandler<GetProfileQuery, ErrorOr<ProfileResponse>>
    {
        public async Task<ErrorOr<ProfileResponse>> Handle(GetProfileQuery request, CancellationToken cancellationToken)
        {
            // Get current user
            var email = httpContextAccessor.HttpContext?.User.FindFirstValue(ClaimTypes.Email);

            // get user by email
            var user = await userManager.FindByEmailAsync(email);
            if (user == null) return new Error[] { Error.NotFound(description: "User not found") };

            var profile = await context.Profiles.Where(x => x.ApplicationUserId == user.Id).FirstOrDefaultAsync(cancellationToken: cancellationToken);
            if (profile == null) return new Error[] { Error.NotFound(description: "Profile not found") };

            return new ProfileResponse(
                Email: email,
                Nickname: profile.Nickname,
                FullName:profile.GetName,
                ProfilePhoto: profile.ProfilePhoto,
                Photos: profile.Photos
            );
        }
    }
}