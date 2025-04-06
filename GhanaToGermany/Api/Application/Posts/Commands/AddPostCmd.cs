using Api.Application.Abstraction.Persistence;
using Api.Application.Common.Abstraction.Persistence;
using Api.Application.Common.Abstraction.Services;
using Api.Domain;
using Api.Infrastructure.Services.Hubs;
using ErrorOr;
using FluentValidation;
using MediatR;
using Microsoft.AspNetCore.SignalR;
using Shared.Post;
using Shared.Wiki;

namespace Api.Application.Posts.Commands
{
    // title, content, thumbnail, owner => admin
    public record AddPostCmd(string Title, string Content, string Owner, string? Thumbnail = null, string? Tag =  null): IRequest<ErrorOr<Post>>;

    public class AddPostCmdValidator: AbstractValidator<AddPostCmd> {
        public AddPostCmdValidator()
        {
            RuleFor(x => x.Title).NotEmpty().WithMessage("Title is required");
            RuleFor(x => x.Content).NotEmpty().WithMessage("Content is required");
        }
    }

    public class AddPostCmdHandler(IUnitOfWork unitOfWork, IHubContext<PostHub> hubContext) : IRequestHandler<AddPostCmd, ErrorOr<Post>>
    {
        public async Task<ErrorOr<Post>> Handle(AddPostCmd request, CancellationToken cancellationToken)
        {
            var post = Post.Create(request.Title, request.Content, request.Owner, "post", request.Thumbnail, request.Tag);
            await unitOfWork.Post.AddAsync(post);
            await unitOfWork.CommitAsync();

            var postModel = new PostModel
            {
                Id = post.Id,
                Title = post.Title,
                Content = post.Content,
                Thumbnail = post.Thumbnail,
                Type = post.Type,
                IsLiked = false,
                Owner = post.Owner,
                DateCreated = post.DateCreated,
                LikeCount = 0,
                BookmarkCount = 0,
                CommentCount = 0
            };
            
            await hubContext.Clients.All.SendAsync(PostHub.ReceiveNewPostEvent, postModel, cancellationToken: cancellationToken);
            
            return post;
        }
    }
}