using Api.Application.Abstraction.Persistence;
using Api.Application.Common.Abstraction.Persistence;
using Api.Application.Common.Errors;
using Api.Domain;
using ErrorOr;
using MediatR;

namespace Api.Application.Wiki.Commands
{
    public record LikeWikiCmd(Guid WikiId, string UserId): IRequest<ErrorOr<bool>>;

    public class LikeWikiCmdHandler(IUnitOfWork _unitOfWork) : IRequestHandler<LikeWikiCmd, ErrorOr<bool>>
    {
        public async Task<ErrorOr<bool>> Handle(LikeWikiCmd request, CancellationToken cancellationToken)
        {
            // check if Wiki exists
            var wiki = await _unitOfWork.Post.GetByIdAsync(request.WikiId);

            if (wiki == null) return new Error[] { Errors.Wiki.NotFound };

            // if it does, create comment with
            var like = Like.Create(request.WikiId, request.UserId);
            await _unitOfWork.Like.AddAsync(like);

            return like != null;
        }
    }
}