
using Api.Application.Abstraction.Persistence;
using Api.Application.Common.Abstraction.Persistence;
using Api.Application.Common.Errors;
using Api.Domain;
using ErrorOr;
using MediatR;

namespace Api.Application.News.Commands
{
    public record AddCommentToNewsCmd(Guid NewsId, string CommentOwner, string Content): IRequest<ErrorOr<bool>>;

    public class AddCommentToNewsCmdHandler(IUnitOfWork _unitOfWork) : IRequestHandler<AddCommentToNewsCmd, ErrorOr<bool>>
    {
        public async Task<ErrorOr<bool>> Handle(AddCommentToNewsCmd request, CancellationToken cancellationToken)
        {
            // check if news exists
            var news = await _unitOfWork.Post.GetByIdAsync(request.NewsId);

            if (news == null) return new Error[] { Errors.News.NotFound };

            // if it does, create comment with
            var comment = Comment.Create(request.NewsId, request.CommentOwner, request.Content);
            await _unitOfWork.Comment.AddAsync(comment);

            return true;
        }
    }
}