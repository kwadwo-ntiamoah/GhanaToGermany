using Api.Application.Abstraction.Persistence;
using Api.Application.Common.Abstraction.Persistence;
using Api.Domain;
using Api.Infrastructure.Services.Hubs;
using ErrorOr;
using FluentValidation;
using MediatR;
using Microsoft.AspNetCore.SignalR;
using Shared.Post;

namespace Api.Application.News.Commands
{
    // title, content, thumbnail, owner => admin
    public record AddNewsCmd(string Title, string Content, string Owner, string? Thumbnail = null, string? Tag = null): IRequest<ErrorOr<Post>>;

    public class AddNewsCmdValidator: AbstractValidator<AddNewsCmd> {
        public AddNewsCmdValidator()
        {
            
            RuleFor(x => x.Title).NotEmpty().WithMessage("Title is required");
            RuleFor(x => x.Content).NotEmpty().WithMessage("Content is required");
            RuleFor(x => x.Thumbnail).NotEmpty().WithMessage("Thumbnail is required");
        }
    }

    public class AddNewsCmdHandler(IUnitOfWork unitOfWork, IHubContext<PostHub> hubContext) : IRequestHandler<AddNewsCmd, ErrorOr<Post>>
    {
        public async Task<ErrorOr<Post>> Handle(AddNewsCmd request, CancellationToken cancellationToken)
        {
            var news = Post.Create(request.Title, request.Content, request.Owner, "news", request.Thumbnail, request.Tag);
            await unitOfWork.Post.AddAsync(news);
            
            var newsModel = new PostModel
            {
                Id = news.Id,
                Title = news.Title,
                Content = news.Content,
                Thumbnail = news.Thumbnail,
                Type = news.Type,
                IsLiked = false,
                Owner = news.Owner,
                DateCreated = news.DateCreated,
                LikeCount = 0,
                BookmarkCount = 0,
                CommentCount = 0
            };
            
            await hubContext.Clients.All.SendAsync(PostHub.ReceiveNewNewsEvent, newsModel, cancellationToken: cancellationToken);
            
            return news;
        }
    }
}