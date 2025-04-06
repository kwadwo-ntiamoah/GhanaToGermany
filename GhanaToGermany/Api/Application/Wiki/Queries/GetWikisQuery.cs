using Api.Application.Abstraction.Persistence;
using Api.Application.Common.Abstraction.Persistence;
using Api.Domain;
using MediatR;
using ErrorOr;
using Shared.Post;
using Shared.Wiki;
using System.Linq.Expressions;

namespace Api.Application.Wiki.Queries;

public record GetWikisQuery(string Requester, bool? GetOnlyUserPosts = false): IRequest<ErrorOr<List<PostModel>>>;

public class GetWikisQueryHandler(IUnitOfWork unitOfWork): IRequestHandler<GetWikisQuery, ErrorOr<List<PostModel>>> {
    public async Task<ErrorOr<List<PostModel>>> Handle(GetWikisQuery request, CancellationToken cancellationToken)
    {
        var likedPosts = new List<Guid>();

        // get user liked posts
        var likedResults = await unitOfWork.Like
            .FilterAsync([ x => x.UserId == request.Requester && x.IsLiked ]);

        var enumerable = likedResults as Like[] ?? likedResults.ToArray();
        if (enumerable.Length != 0)
        {
            likedPosts = enumerable.Select(x => x.PostId).ToList();
        }

        var posts = await unitOfWork.Post.GetWikisAsync();

        if (posts is { Count: 0 }) return new List<PostModel>();
            
        var updatedPosts = posts!.Select(post =>
        {
            if (likedPosts.Contains(post.Id)) post.IsLiked = true;
            return post;
        });

        if (request.GetOnlyUserPosts == true) {
            return updatedPosts.Where(x => x.Owner == request.Requester).ToList();
        }
        
        return updatedPosts.ToList();
    }
}