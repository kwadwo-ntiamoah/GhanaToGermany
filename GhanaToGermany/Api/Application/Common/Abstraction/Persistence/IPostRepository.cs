using Api.Application.Abstraction.Persistence;
using Api.Domain;
using Shared.Post;
using Shared.Wiki;

namespace Api.Application.Common.Abstraction.Persistence
{
    public interface IPostRepository: IGenericRepository<Post>
    {
        public Task<List<PostModel>?> GetPostsAsync();
        public Task<PostModel?> GetPostAsync(Guid postId);
        public Task<List<PostModel>?> GetWikisAsync();
        public Task<List<PostModel>?> GetNewsAsync();
    }
}