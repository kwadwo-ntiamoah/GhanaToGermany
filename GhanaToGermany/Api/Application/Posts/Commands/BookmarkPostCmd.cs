using Api.Application.Abstraction.Persistence;
using Api.Application.Common.Abstraction.Persistence;
using Api.Application.Common.Errors;
using Api.Domain;
using ErrorOr;
using MediatR;

namespace Api.Application.Posts.Commands
{
    public record BookmarkPostCmd(Guid PostId, string UserId): IRequest<ErrorOr<bool>>;

    public class BookmarkPostCmdHandler(IUnitOfWork unitOfWork) : IRequestHandler<BookmarkPostCmd, ErrorOr<bool>>
    {

        public async Task<ErrorOr<bool>> Handle(BookmarkPostCmd request, CancellationToken cancellationToken)
        {
            // check if post exists
            var post = await unitOfWork.Post.GetByIdAsync(request.PostId);

            if (post == null) return new Error[] { Errors.Post.NotFound };
            
            // check if there's already a bookmark for post and user
            var tempLike = await unitOfWork.Bookmark.FilterAsync([
                x => x.UserId == request.UserId && x.PostId == request.PostId
            ]);

            var enumerable = tempLike.ToList();
            if (enumerable.Count != 0)
            {
                // toggle like for post
                var bookmarkResponse = enumerable.First();
                bookmarkResponse.ToggleBookmark();
                
                unitOfWork.Bookmark.UpdateAsync(bookmarkResponse);
                await unitOfWork.CommitAsync();
                
                return true;
            };

            // if it does, create comment with
            var bookmark = Bookmark.Create(request.PostId, request.UserId);
            await unitOfWork.Bookmark.AddAsync(bookmark);

            return true;
        }
    }
}