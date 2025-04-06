using Api.Application.Abstraction.Persistence;
using Api.Application.Common.Abstraction.Persistence;
using Api.Application.Common.Errors;
using Api.Domain;
using ErrorOr;
using MediatR;

namespace Api.Application.News.Commands
{
    public record BookmarkNewsCmd(Guid NewsId, string UserId): IRequest<ErrorOr<bool>>;

    public class BookmarkNewsCmdHandler(IUnitOfWork _unitOfWork) : IRequestHandler<BookmarkNewsCmd, ErrorOr<bool>>
    {

        public async Task<ErrorOr<bool>> Handle(BookmarkNewsCmd request, CancellationToken cancellationToken)
        {
            // check if news exists
            var news = await _unitOfWork.Post.GetByIdAsync(request.NewsId);

            if (news == null) return new Error[] { Errors.News.NotFound };

            // if it does, create comment with
            var bookmark = Bookmark.Create(request.NewsId, request.UserId);
            await _unitOfWork.Bookmark.AddAsync(bookmark);

            return bookmark != null;
        }
    }
}