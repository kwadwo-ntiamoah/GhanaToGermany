using Api.Application.Abstraction.Persistence;
using Api.Application.Common.Abstraction.Persistence;
using Api.Application.Common.Errors;
using Api.Domain;
using ErrorOr;
using MediatR;
using Shared.Post;

namespace Api.Application.Posts.Commands
{
    public record ToggleLikePostCmd(Guid PostId, string UserId) : IRequest<ErrorOr<PostModel>>;

    public class LikePostCmdHandler(IUnitOfWork unitOfWork) : IRequestHandler<ToggleLikePostCmd, ErrorOr<PostModel>>
    {
        public async Task<ErrorOr<PostModel>> Handle(ToggleLikePostCmd request, CancellationToken cancellationToken)
        {
            // check if Post exists
            var post = await unitOfWork.Post.GetByIdAsync(request.PostId);

            if (post == null) return new Error[] { Errors.Post.NotFound };

            // check if there's already a like for post and user
            var tempLike = await unitOfWork.Like.FilterAsync([
                x => x.UserId == request.UserId && x.PostId == request.PostId
            ]);

            var enumerable = tempLike.ToList();
            if (enumerable.Count != 0)
            {
                // toggle like for post
                var likeResponse = enumerable.First();
                likeResponse.ToggleLike();

                unitOfWork.Like.UpdateAsync(likeResponse);
                await unitOfWork.CommitAsync();

                var oldPost = await unitOfWork.Post.GetPostAsync(request.PostId);
                return oldPost!;
            };

            // if it does, create like with
            var like = Like.Create(request.PostId, request.UserId);
            await unitOfWork.Like.AddAsync(like);
            await unitOfWork.CommitAsync();

            var newPost = await unitOfWork.Post.GetPostAsync(request.PostId);
            return newPost!;
        }
    }
}