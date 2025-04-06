
using System.Linq.Expressions;

namespace Api.Application.Abstraction.Persistence
{
    public interface IGenericRepository<T> where T : class
    {
        public Task<T?> GetByIdAsync(Guid id);
        public Task<IEnumerable<T>> GetAllAsync();
        public Task<IEnumerable<T>> FilterAsync(List<Expression<Func<T, bool>>> predicate, Expression<Func<T, object>>[]? includes = null);
        public Task AddAsync(T entity);
        public Task AddRangeAsync(IEnumerable<T> entities);
        public void UpdateAsync(T entity);
    }
}
