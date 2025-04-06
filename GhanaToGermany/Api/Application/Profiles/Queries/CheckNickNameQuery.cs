using Api.Domain;
using ErrorOr;
using FluentValidation;
using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Shared.Auth;

namespace Api.Application.Profiles.Queries
{
    public record CheckNickNameQuery(string NickName) : IRequest<ErrorOr<CheckUsernameResult>>;

    public class CheckNickNameQueryValidator : AbstractValidator<CheckNickNameQuery>
    {
        public CheckNickNameQueryValidator()
        {
            RuleFor(x => x.NickName)
                .NotEmpty().WithMessage("Nickname is required")
                .MinimumLength(4).WithMessage("Nickname must be at least 4 characters long")
                .Matches("^[a-zA-Z0-9._-]+$").WithMessage("Nicknames can only contain letters, numbers, dots, underscores and hyphens");
        }
    }

    public class CheckNickNameQueryHandler(UserManager<ApplicationUser> userManager) : IRequestHandler<CheckNickNameQuery, ErrorOr<CheckUsernameResult>>
    {

        public async Task<ErrorOr<CheckUsernameResult>> Handle(CheckNickNameQuery request, CancellationToken cancellationToken)
        {
            // Check if nickname exists
            var existingUser = await userManager.Users.Include(x => x.Profile)
                .FirstOrDefaultAsync(x => x.Profile.Nickname == request.NickName,
                    cancellationToken: cancellationToken);

            if (existingUser == null)
            {
                return new CheckUsernameResult
                {
                    IsAvailable = true
                };
            }

            // Generate username suggestions
            var suggestedUsername = await GenerateUsernameAlternative(request.NickName, cancellationToken);

            return new CheckUsernameResult
            {
                IsAvailable = false,
                SuggestedUsername = suggestedUsername
            };
        }

        private async Task<string> GenerateUsernameAlternative(string originalUsername, CancellationToken cancellationToken)
        {
            // Try adding random numbers until we find an available username
            var random = new Random();
            string suggestedUsername;

            do
            {
                var suffix = random.Next(1, 9999).ToString("D4");
                suggestedUsername = $"{originalUsername}{suffix}";
            }
            while (await userManager.Users.AnyAsync(x =>
                x.UserName.ToLower() == suggestedUsername.ToLower(),
                cancellationToken: cancellationToken));

            return suggestedUsername;
        }
    }
}