using System.Linq.Expressions;
using Api.Application.Abstraction.Persistence;
using LinqKit;
using Microsoft.EntityFrameworkCore;

namespace Api.Infrastructure.Persistence.Repositories
{
    public class GenericRepository<T>(AppDbContext context) : IGenericRepository<T> where T : class
    {
        public async Task AddAsync(T entity)
        {
            await context.Set<T>().AddAsync(entity);
        }

        public async Task AddRangeAsync(IEnumerable<T> entities)
        {
            await context.Set<T>().AddRangeAsync(entities);
        }

        public async Task<IEnumerable<T>> FilterAsync(List<Expression<Func<T, bool>>> tempPredicates, Expression<Func<T, object>>[]? includes)
        {
            IQueryable<T> query = context.Set<T>();

            var predicate = PredicateBuilder.New<T>(true);

            foreach (var pred in tempPredicates)
            {
                predicate = predicate.Or(pred);
            }

            if (includes != null || includes?.Length > 0)
            {
                foreach (var include in includes!)
                {
                    query = query.Include(include);
                }
            }

            return await query.Where(predicate).ToListAsync();
        }

        public async Task<IEnumerable<T>> GetAllAsync()
        {
            return await context.Set<T>().ToListAsync();
        }

        public async Task<T?> GetByIdAsync(Guid id)
        {
            return await context.Set<T>().FindAsync(id);
        }

        public void UpdateAsync(T entity)
        {
            context.Set<T>().Update(entity);
        }
    }
}
