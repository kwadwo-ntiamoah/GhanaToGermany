using Api.Application.Abstraction.Persistence;
using Api.Application.Common.Abstraction.Persistence;

namespace Api.Infrastructure.Persistence.Repositories
{
    public class UnitOfWork : IUnitOfWork
    {
        private readonly AppDbContext _context;

        public IBookmarkRepository Bookmark { get; private set; }
        public ICommentRepository Comment {get; private set;} 
        public ILikeRepository Like {get; private set;}
        public IPostRepository Post {get; private set;} 
        public ITagsRepository Tag {get; private set;}
        public ITranslationRepository Translation {get; private set;}

        public UnitOfWork(AppDbContext context)
        {
            _context = context;

            Bookmark = new BookmarkRepository(_context);
            Comment = new CommentRepository(_context);
            Like = new LikeRepository(_context);
            Post = new PostRepository(_context);
            Tag = new TagsRepository(_context);
            Translation = new TranslationRepository(_context);
        }

        public async Task CommitAsync()
        {
            await _context.SaveChangesAsync();
        }
    }
}
