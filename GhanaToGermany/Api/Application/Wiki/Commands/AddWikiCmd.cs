using Api.Application.Abstraction.Persistence;
using Api.Application.Common.Abstraction.Persistence;
using Api.Domain;
using Api.Infrastructure.Services.Hubs;
using ErrorOr;
using FluentValidation;
using MediatR;
using Microsoft.AspNetCore.SignalR;
using Shared.Post;

namespace Api.Application.Wiki.Commands
{
    // title, content, thumbnail, owner => admin
    public record AddWikiCmd(string Title, string Content, string Owner, string? Thumbnail, string? Tag): IRequest<ErrorOr<Post>>;

    public class AddWikiCmdValidator: AbstractValidator<AddWikiCmd> {
        public AddWikiCmdValidator()
        {
            
            RuleFor(x => x.Title).NotEmpty().WithMessage("Title is required");
            RuleFor(x => x.Content).NotEmpty().WithMessage("Content is required");
            RuleFor(x => x.Thumbnail).NotEmpty().WithMessage("Thumbnail is required");
        }
    }

    public class AddWikiCmdHandler(IUnitOfWork unitOfWork, IHubContext<PostHub> hubContext) : IRequestHandler<AddWikiCmd, ErrorOr<Post>>
    {
        public async Task<ErrorOr<Post>> Handle(AddWikiCmd request, CancellationToken cancellationToken)
        {
            var wiki = Post.Create(request.Title, request.Content, request.Owner, "wiki", request.Thumbnail, request.Tag);
            await unitOfWork.Post.AddAsync(wiki);
            await unitOfWork.CommitAsync();
            
            var wikiModel = new PostModel
            {
                Id = wiki.Id,
                Title = wiki.Title,
                Content = wiki.Content,
                Thumbnail = wiki.Thumbnail,
                Type = wiki.Type,
                IsLiked = false,
                Owner = wiki.Owner,
                DateCreated = wiki.DateCreated,
                LikeCount = 0,
                BookmarkCount = 0,
                CommentCount = 0
            };
            
            await hubContext.Clients.All.SendAsync(PostHub.ReceiveNewWikiEvent, wikiModel, cancellationToken: cancellationToken);
            
            return wiki;
        }
    }
}