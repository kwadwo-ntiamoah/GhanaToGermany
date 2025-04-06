using ErrorOr;
using MediatR;
using FluentValidation;
using Shared.Profile;
using System.Text.Json;
using Api.Infrastructure.Persistence;
using Microsoft.AspNetCore.Identity;
using Api.Domain;
using System.Security.Claims;
using Microsoft.EntityFrameworkCore;

namespace Api.Application.Profiles.Commands
{
    public record CompleteProfileCommand(
    string Nickname,
    string Firstname,
    string Lastname,
    string ProfilePhoto,
    string Photos
) : IRequest<ErrorOr<ProfileResponse>>;


    public class CompleteProfileCommandValidator : AbstractValidator<CompleteProfileCommand>
    {
        public CompleteProfileCommandValidator()
        {
            RuleFor(x => x.Nickname)
                .NotEmpty().WithMessage("Nickname is required")
                .MinimumLength(3).WithMessage("Nickname must be at least 3 characters")
                .MaximumLength(50).WithMessage("Nickname must not exceed 50 characters");

            RuleFor(x => x.Firstname)
                .NotEmpty().WithMessage("First name is required")
                .MaximumLength(50).WithMessage("First name must not exceed 50 characters")
                .Matches("^[a-zA-Z ]*$").WithMessage("First name can only contain letters and spaces");

            RuleFor(x => x.Lastname)
                .NotEmpty().WithMessage("Last name is required")
                .MaximumLength(50).WithMessage("Last name must not exceed 50 characters")
                .Matches("^[a-zA-Z ]*$").WithMessage("Last name can only contain letters and spaces");

            RuleFor(x => x.ProfilePhoto)
                .Must(BeAValidUrl).When(x => !string.IsNullOrEmpty(x.ProfilePhoto))
                .WithMessage("Profile photo must be a valid URL");

            RuleFor(x => x.Photos)
                .Must(BeValidPhotosJson).When(x => !string.IsNullOrEmpty(x.Photos))
                .WithMessage("Photos must be a valid JSON array of URLs");
        }

        private bool BeAValidUrl(string? url)
        {
            if (string.IsNullOrEmpty(url)) return true;
            return Uri.TryCreate(url, UriKind.Absolute, out _);
        }

        private bool BeValidPhotosJson(string? photos)
        {
            if (string.IsNullOrEmpty(photos)) return true;
            try
            {
                var photoUrls = JsonSerializer.Deserialize<string[]>(photos);
                return photoUrls?.All(url => BeAValidUrl(url)) ?? false;
            }
            catch
            {
                return false;
            }
        }
    }

    public class CompleteProfileCommandHandler(AppDbContext context, IHttpContextAccessor httpContextAccessor, UserManager<ApplicationUser> userManager) : IRequestHandler<CompleteProfileCommand, ErrorOr<ProfileResponse>>
    {

        public async Task<ErrorOr<ProfileResponse>> Handle(CompleteProfileCommand command, CancellationToken cancellationToken)
        {
            // Get current user
            var email = httpContextAccessor.HttpContext?.User.FindFirstValue(ClaimTypes.Email);
            if (string.IsNullOrEmpty(email))
            {
                return Error.Unauthorized(description: "User not authenticated");
            }

            var user = await userManager.Users
                .Include(x => x.Profile)
                .FirstOrDefaultAsync(x => x.Email == email, cancellationToken);

            if (user == null)
            {
                return Error.NotFound(description: "User not found");
            }

            if (user.Profile != null) {
                return Error.Conflict(description: "Profile setup already completed for user. Login to update");
            }

            // Check if nickname is already taken
            var isNicknameTaken = await context.Set<Profile>()
                .AnyAsync(x => x.Nickname == command.Nickname, cancellationToken: cancellationToken);

            if (isNicknameTaken)
            {
                return Error.Conflict(description: "Nickname is already taken");
            }

            var profile = new Profile
            {
                ApplicationUserId = user.Id,
                Nickname = command.Nickname,
                Firstname = command.Firstname,
                Lastname = command.Lastname,
                ProfilePhoto = command.ProfilePhoto,
                Photos = string.Empty
            };

            await context.Set<Profile>().AddAsync(profile, cancellationToken);
            await context.SaveChangesAsync(cancellationToken);

            // Return response
            return new ProfileResponse(
                Email: user.Email,
                Nickname: user.Profile.Nickname,
                FullName: user.Profile.GetName,
                ProfilePhoto: user.Profile.ProfilePhoto,
                Photos: user.Profile.Photos
            );
        }
    }
}