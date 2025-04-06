using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Api.Application.Common.Abstraction.Persistence;
using Api.Domain;

namespace Api.Infrastructure.Persistence.Repositories
{
    public class TagsRepository(AppDbContext context): GenericRepository<Tag>(context), ITagsRepository
    {
        
    }
}