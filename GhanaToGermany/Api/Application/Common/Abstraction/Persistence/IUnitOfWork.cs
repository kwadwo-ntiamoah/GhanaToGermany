using Api.Application.Abstraction.Persistence;

namespace Api.Application.Common.Abstraction.Persistence
{
    public interface IUnitOfWork
    {
        public IBookmarkRepository Bookmark {get;}
        public ICommentRepository Comment {get;}
        public ILikeRepository Like {get;}
        public IPostRepository Post {get;}
        public ITagsRepository Tag {get;}
        public ITranslationRepository Translation {get;}
        public Task CommitAsync();
    }
}
