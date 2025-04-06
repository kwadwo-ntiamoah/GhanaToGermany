using Api.Application.Abstraction.Persistence;
using Api.Domain;

namespace Api.Infrastructure.Persistence.Repositories
{
    public class CommentRepository(AppDbContext context): GenericRepository<Comment>(context), ICommentRepository
    {
        
    }
}