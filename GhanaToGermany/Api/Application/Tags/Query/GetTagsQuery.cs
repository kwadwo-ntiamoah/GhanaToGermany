using Api.Application.Common.Abstraction.Persistence;
using ErrorOr;
using MediatR;
using Shared.Post;

namespace Api.Application.Tags.Query
{
    public record GetTagsQuery(): IRequest<ErrorOr<List<TagsModel>>>;

public class GetPostsQueryHandler(IUnitOfWork unitOfWork): IRequestHandler<GetTagsQuery, ErrorOr<List<TagsModel>>> {
    public async Task<ErrorOr<List<TagsModel>>> Handle(GetTagsQuery request, CancellationToken cancellationToken)
    {
        var tags = await unitOfWork.Tag.FilterAsync([x => x.IsActive]);
        
        return tags.Select(x => new TagsModel {
            Name = x.Name
        }).ToList();
    }
}
}