using Api.Application.Abstraction.Persistence;
using Api.Application.Common.Abstraction.Persistence;
using Api.Domain;

namespace Api.Infrastructure.Persistence.Repositories
{
    public class LikeRepository(AppDbContext context): GenericRepository<Like>(context), ILikeRepository
    {
        
    }
}