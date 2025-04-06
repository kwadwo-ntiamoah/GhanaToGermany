
using Api.Application.Abstraction.Persistence;
using Api.Application.Common.Abstraction.Persistence;
using Api.Application.Common.Errors;
using Api.Domain;
using ErrorOr;
using MediatR;

namespace Api.Application.Wiki.Commands
{
    public record AddCommentToWikiCmd(Guid WikiId, string CommentOwner, string Content): IRequest<ErrorOr<bool>>;

    public class AddCommentToWikiCmdHandler(IUnitOfWork _unitOfWork) : IRequestHandler<AddCommentToWikiCmd, ErrorOr<bool>>
    {
        public async Task<ErrorOr<bool>> Handle(AddCommentToWikiCmd request, CancellationToken cancellationToken)
        {
            // check if news exists
            var news = await _unitOfWork.Post.GetByIdAsync(request.WikiId);

            if (news == null) return new Error[] { Errors.Wiki.NotFound };

            // if it does, create comment with
            var comment = Comment.Create(request.WikiId, request.CommentOwner, request.Content);
            await _unitOfWork.Comment.AddAsync(comment);

            return comment != null;
        }
    }
}