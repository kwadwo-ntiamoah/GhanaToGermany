using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Api.Application.Abstraction.Persistence;
using Api.Domain;

namespace Api.Application.Common.Abstraction.Persistence
{
    public interface ITranslationRepository: IGenericRepository<Translation>
    {
        
    }
}