using Api.Application.News.Commands;
using Api.Application.Wiki.Commands;
using Api.Application.Wiki.Queries;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using Shared.Invoices;
using Shared.Wiki;

namespace Api.Controllers
{
    [Route("api/[controller]")]
    public class WikiController(ISender _mediatR) : ApiController
    {
        [HttpGet]
        public async Task<IActionResult> GetWikissAsync()
        {
            var query = new GetWikisQuery(Requester: GetUser!);
            var res = await _mediatR.Send(query);

            return res.Match(Ok, Problem);
        }

        [HttpGet("me")]
        public async Task<IActionResult> GetMyWikisAsync()
        {
            var query = new GetWikisQuery(Requester: GetUser!, GetOnlyUserPosts: true);
            var res = await _mediatR.Send(query);

            return res.Match(Ok, Problem);
        }

        [HttpPost]
        public async Task<IActionResult> AddWikiAsync(AddPostDto request)
        {
            var me = GetUser;
            var command = new AddWikiCmd(request.Title, request.Content, me!, request.Thumbnail, request.Tag);
            var res = await _mediatR.Send(command);

            return res.Match(Ok, Problem);
        }

        [HttpPost("comment")]
        public async Task<IActionResult> PostCommentAsync([FromQuery] Guid WikiId, [FromBody] AddWikiCommentDto model) {
            var user = GetUser;
            var command = new AddCommentToWikiCmd(WikiId, user!, model.Content);
            var res = await _mediatR.Send(command);

            return res.Match(
                res => Ok(true),
                errors => Problem()
            );
        }

        [HttpPost("like")]
        public async Task<IActionResult> LikeNewsAsync([FromQuery] Guid NewsId) {
            var user = GetUser;
            var command = new LikeNewsCmd(NewsId, user!);
            var res = await _mediatR.Send(command);

            return res.Match(
                res => Ok(true),
                errors => Problem()
            );
        }

        [HttpPost("bookmark")]
        public async Task<IActionResult> BookmarkNewsAsync([FromQuery] Guid WikiId) {
            var user = GetUser;
            var command = new BookmarkWikiCmd(WikiId, user!);
            var res = await _mediatR.Send(command);

            return res.Match(
                res => Ok(true),
                errors => Problem()
            );
        }
    }
}