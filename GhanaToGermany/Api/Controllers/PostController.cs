using System.Text.Json;
using Api.Application.Posts.Commands;
using Api.Application.Posts.Queries;
using Api.Application.Wiki.Queries;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Shared.Invoices;
using Shared.Wiki;

namespace Api.Controllers
{
    [Route("api/[controller]")]
    public class PostController(ISender mediatR) : ApiController
    {
        [HttpGet]
        public async Task<IActionResult> GetPostsAsync()
        {
            var query = new GetPostsQuery(Requester: GetUser!);
            var res = await mediatR.Send(query);

            return res.Match(Ok, Problem);
        }

        [HttpGet("me")]
        public async Task<IActionResult> GetMyPostsAsync()
        {
            var query = new GetPostsQuery(Requester: GetUser!, GetOnlyUserPosts: true);
            var res = await mediatR.Send(query);

            return res.Match(Ok, Problem);
        }

        [HttpPost]
        public async Task<IActionResult> AddPostAsync(AddPostDto request)
        {
            var me = GetUser;
            var command = new AddPostCmd(request.Title, request.Content, me!, request.Thumbnail, request.Tag);
            var res = await mediatR.Send(command);

            return res.Match(Ok, Problem);
        }

        [HttpGet("comment")]
        public async Task<IActionResult> GetCommentsAsync([FromQuery] Guid postId) {
            var query = new GetCommentsQuery(postId);
            var res = await mediatR.Send(query);

            return res.Match(Ok, Problem);
        }

        [HttpPost("comment")]
        public async Task<IActionResult> PostCommentAsync([FromQuery] Guid postId, [FromBody] AddNewsCommentDto model) {
            var user = GetUser;
            var command = new AddCommentToPostCmd(postId, user!, model.Content);
            var res = await mediatR.Send(command);

            return res.Match(
                _ => Ok(true),
                errors => Problem()
            );
        }

        [HttpPost("toggleLike")]
        public async Task<IActionResult> LikePostAsync([FromQuery] Guid postId) {
            var user = GetUser;
            var command = new ToggleLikePostCmd(postId, user!);
            var res = await mediatR.Send(command);

            return res.Match(Ok, Problem);
        }

        [HttpPost("toggleBookmark")]
        public async Task<IActionResult> BookmarkPostAsync([FromQuery] Guid postId) {
            var user = GetUser;
            var command = new BookmarkPostCmd(postId, user!);
            var res = await mediatR.Send(command);

            return res.Match(
                _ => Ok(true),
                errors => Problem()
            );
        }
    }
}