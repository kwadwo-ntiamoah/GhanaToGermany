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
    public record GetProfileQuery(string UserId) : IRequest<ErrorOr<ProfileResponse>>;

    public class GetProfileQueryHandler(AppDbContext context, IHttpContextAccessor httpContextAccessor, UserManager<ApplicationUser> userManager) : IRequestHandler<GetProfileQuery, ErrorOr<ProfileResponse>>
    {
        public async Task<ErrorOr<ProfileResponse>> Handle(GetProfileQuery request, CancellationToken cancellationToken)
        {
            var user = await userManager.FindByEmailAsync(request.UserId);
            if (user == null) return new Error[] { Error.Unauthorized(description: "User not logged in") };

            var profile = await context.Profiles.Where(x => x.ApplicationUserId == user.Id).FirstOrDefaultAsync(cancellationToken: cancellationToken);
            if (profile == null) return new Error[] { Error.NotFound(description: "Profile not found") };

            return new ProfileResponse(
                Email: user.Email ?? "N/A",
                Nickname: profile.Nickname,
                FullName:profile.GetName,
                ProfilePhoto: profile.ProfilePhoto,
                Photos: profile.Photos
            );
        }
    }
}