using Api.Application.Abstraction.Persistence;
using Api.Domain;

namespace Api.Infrastructure.Persistence.Repositories
{
    public class BookmarkRepository(AppDbContext context): GenericRepository<Bookmark>(context), IBookmarkRepository
    {
        
    }
}