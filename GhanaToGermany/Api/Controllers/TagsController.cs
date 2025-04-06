using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Api.Application.Tags.Query;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class TagsController(ISender mediatR) : ApiController
    {
        [HttpGet]
        public async Task<IActionResult> GetTagsAsync() {
            var query = new GetTagsQuery();
            var res = await mediatR.Send(query);

            return res.Match(Ok, Problem);
        }
    }
}