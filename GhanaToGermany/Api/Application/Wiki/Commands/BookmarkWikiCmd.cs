using Api.Application.Abstraction.Persistence;
using Api.Application.Common.Abstraction.Persistence;
using Api.Application.Common.Errors;
using Api.Domain;
using ErrorOr;
using MediatR;

namespace Api.Application.Wiki.Commands
{
    public record BookmarkWikiCmd(Guid WikiId, string UserId): IRequest<ErrorOr<bool>>;

    public class BookmarkWikiCmdHandler(IUnitOfWork _unitOfWork) : IRequestHandler<BookmarkWikiCmd, ErrorOr<bool>>
    {

        public async Task<ErrorOr<bool>> Handle(BookmarkWikiCmd request, CancellationToken cancellationToken)
        {
            // check if news exists
            var wiki = await _unitOfWork.Post.GetByIdAsync(request.WikiId);

            if (wiki == null) return new Error[] { Errors.Wiki.NotFound };

            // if it does, create comment with
            var bookmark = Bookmark.Create(request.WikiId, request.UserId);
            await _unitOfWork.Bookmark.AddAsync(bookmark);

            return bookmark != null;
        }
    }
}