using Api.Application.Common.Abstraction.Persistence;
using Api.Domain;
using Microsoft.EntityFrameworkCore;
using Shared.Post;
using Shared.Wiki;

namespace Api.Infrastructure.Persistence.Repositories
{
    public class PostRepository(AppDbContext context): GenericRepository<Post>(context: context), IPostRepository
    {
        private readonly AppDbContext _context = context;

        public async Task<List<PostModel>?> GetNewsAsync()
        {
            return await GetPosts("news");
        }

        public async Task<PostModel?> GetPostAsync(Guid postId)
        {
            return await GetPost(postId);
        }

        public async Task<List<PostModel>?> GetPostsAsync()
        {
            return await GetPosts("post");
        }

        public async Task<List<PostModel>?> GetWikisAsync()
        {
            return await GetPosts("wiki");
        }

        private async Task<List<PostModel>> GetPosts(string type)
        {
            var results = await _context.Posts
                .Where(x => x.Type == type)
                .OrderBy(x => x.DateCreated)
                .Select(post => new PostModel()
                {
                    Id = post.Id,
                    Title = post.Title,
                    Content = post.Content,
                    Thumbnail = post.Thumbnail,
                    Type = post.Type,
                    IsLiked = post.IsLiked,
                    Owner = post.Owner,
                    DateCreated = post.DateCreated,
                    LikeCount = _context.Likes.Count(lk => lk.PostId == post.Id),
                    BookmarkCount = _context.Bookmarks.Count(bk => bk.PostId == post.Id),
                    CommentCount = _context.Comments.Count(cm => cm.PostId == post.Id)
                })
                .OrderByDescending(p => p.DateCreated)
                .Take(50)
                .ToListAsync();

            return results;
        }

        private async Task<PostModel?> GetPost(Guid id)
        {
            var results = await _context.Posts
                .Where(x => x.Id == id)
                .OrderBy(x => x.DateCreated)
                .Select(post => new PostModel()
                {
                    Id = post.Id,
                    Title = post.Title,
                    Content = post.Content,
                    Thumbnail = post.Thumbnail,
                    Type = post.Type,
                    IsLiked = post.IsLiked,
                    Owner = post.Owner,
                    DateCreated = post.DateCreated,
                    LikeCount = _context.Likes.Count(lk => lk.PostId == post.Id),
                    BookmarkCount = _context.Bookmarks.Count(bk => bk.PostId == post.Id),
                    CommentCount = _context.Comments.Count(cm => cm.PostId == post.Id)
                }).FirstOrDefaultAsync();

            return results;
        }
    }
}