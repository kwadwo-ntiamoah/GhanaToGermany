
using Api.Application.Abstraction.Persistence;
using Api.Application.Common.Abstraction.Persistence;
using Api.Application.Common.Errors;
using Api.Domain;
using ErrorOr;
using MediatR;

namespace Api.Application.Posts.Commands
{
    public record AddCommentToPostCmd(Guid PostId, string CommentOwner, string Content): IRequest<ErrorOr<bool>>;

    public class AddCommentToPostCmdHandler(IUnitOfWork _unitOfWork) : IRequestHandler<AddCommentToPostCmd, ErrorOr<bool>>
    {
        public async Task<ErrorOr<bool>> Handle(AddCommentToPostCmd request, CancellationToken cancellationToken)
        {
            // check if news exists
            var news = await _unitOfWork.Post.GetByIdAsync(request.PostId);

            if (news == null) return new Error[] { Errors.Wiki.NotFound };

            // if it does, create comment with
            var comment = Comment.Create(request.PostId, request.CommentOwner, request.Content);
            await _unitOfWork.Comment.AddAsync(comment);

            await _unitOfWork.CommitAsync();
            return comment != null;
        }
    }
}