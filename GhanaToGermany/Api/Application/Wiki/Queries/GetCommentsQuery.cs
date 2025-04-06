using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Api.Application.Common.Abstraction.Persistence;
using Api.Domain;
using ErrorOr;
using MediatR;

namespace Api.Application.Wiki.Queries
{
    public record GetCommentsQuery(Guid PostId): IRequest<ErrorOr<List<Comment>>>;

    public class GetCommentsQueryHandler(IUnitOfWork unitOfWork) : IRequestHandler<GetCommentsQuery, ErrorOr<List<Comment>>>
    {
        public async Task<ErrorOr<List<Comment>>> Handle(GetCommentsQuery request, CancellationToken cancellationToken)
        {
            var comments = await unitOfWork.Comment.FilterAsync([x => x.PostId == request.PostId]);
            return comments.ToList();
        }
    }
}