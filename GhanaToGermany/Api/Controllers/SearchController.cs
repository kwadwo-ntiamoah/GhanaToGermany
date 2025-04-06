using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Api.Application.Search.Queries;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class SearchController(ISender mediatR) : ApiController
    {
        [HttpGet]
        public async Task<IActionResult> SearchAsync([FromQuery] string query) {
            var queryModel = new SearchQuery(query);
            var result = await mediatR.Send(queryModel);

            return result.Match(Ok, Problem);
        }
    }
}