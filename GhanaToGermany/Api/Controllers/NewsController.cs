using Api.Application.News.Commands;
using Api.Application.News.Queries;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using Shared.Invoices;
using Shared.Wiki;

namespace Api.Controllers
{
    [Route("api/[controller]")]
    public class NewsController(ISender mediatR) : ApiController
    {
        [HttpGet]
        public async Task<IActionResult> GetPostsAsync()
        {
            var query = new GetNewsQuery(Requester: GetUser!);
            var res = await mediatR.Send(query);

            return res.Match(Ok, Problem);
        }

        [HttpPost]
        public async Task<IActionResult> AddNewsAsync(AddPostDto request)
        {
            var me = GetUser;
            var command = new AddNewsCmd(request.Title, request.Content, me!, request.Thumbnail, request.Tag);
            var res = await mediatR.Send(command);

            return res.Match(Ok, Problem);
        }

        [HttpPost("comment")]
        public async Task<IActionResult> PostCommentAsync([FromQuery] Guid newsId, [FromBody] AddNewsCommentDto model) {
            var user = GetUser;
            var command = new AddCommentToNewsCmd(newsId, user!, model.Content);
            var res = await mediatR.Send(command);

            return res.Match(
                _ => Ok(true),
                _ => Problem()
            );
        }

        [HttpPost("like")]
        public async Task<IActionResult> LikeNewsAsync([FromQuery] Guid newsId) {
            var user = GetUser;
            var command = new LikeNewsCmd(newsId, user!);
            var res = await mediatR.Send(command);

            return res.Match(
                _ => Ok(true),
                _ => Problem()
            );
        }

        [HttpPost("bookmark")]
        public async Task<IActionResult> BookmarkNewsAsync([FromQuery] Guid newsId) {
            var user = GetUser;
            var command = new BookmarkNewsCmd(newsId, user!);
            var res = await mediatR.Send(command);

            return res.Match(
                _ => Ok(true),
                _ => Problem()
            );
        }
    }
}