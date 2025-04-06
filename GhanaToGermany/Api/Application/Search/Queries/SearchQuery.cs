using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Api.Domain;
using Api.Infrastructure.Persistence;
using ErrorOr;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Shared.Post;

namespace Api.Application.Search.Queries
{
    public record SearchQuery(string QueryText) : IRequest<ErrorOr<List<Post>>>;

    public class SearchQueryHandler(AppDbContext context) : IRequestHandler<SearchQuery, ErrorOr<List<Post>>>
    {
        public async Task<ErrorOr<List<Post>>> Handle(SearchQuery request, CancellationToken cancellationToken)
        {
            try
            {
                string tsQuery = request.QueryText.Replace(" ", " & ");
                Console.WriteLine(tsQuery);
                
                var posts = await context.Posts
                    .FromSqlRaw(@"
                        SELECT *, ts_rank(search_vector, to_tsquery('english', {0})) AS rank
                        FROM ""Posts""
                        WHERE search_vector @@ to_tsquery('english', {0})
                        ORDER BY rank DESC", tsQuery)
                    .ToListAsync(cancellationToken: cancellationToken);

                return posts.ToList();

            }
            catch (Exception)
            {
                return new List<Post> { };
            }
        }
    }
}