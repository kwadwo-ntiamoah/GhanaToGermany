using Api.Application.Abstraction.Persistence;
using Api.Application.Common.Abstraction.Persistence;
using Api.Application.Common.Errors;
using Api.Domain;
using ErrorOr;
using MediatR;

namespace Api.Application.News.Commands
{
    public record LikeNewsCmd(Guid NewsId, string UserId): IRequest<ErrorOr<bool>>;

    public class LikeNewsCmdHandler(IUnitOfWork unitOfWork) : IRequestHandler<LikeNewsCmd, ErrorOr<bool>>
    {
        public async Task<ErrorOr<bool>> Handle(LikeNewsCmd request, CancellationToken cancellationToken)
        {
            // check if news exists
            var news = await unitOfWork.Post.GetByIdAsync(request.NewsId);

            if (news == null) return new Error[] { Errors.News.NotFound };

            // if it does, create comment with
            var like = Like.Create(request.NewsId, request.UserId);
            await unitOfWork.Like.AddAsync(like);

            return true;
        }
    }
}