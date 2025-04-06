using Api.Application.Profiles.Commands;
using Api.Application.Profiles.Queries;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using Shared.Profile;

namespace Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProfileController(ISender mediatR) : ApiController
    {
        [HttpGet]
        public async Task<IActionResult> GetProfileAsync() {
            var query = new GetProfileQuery();
            var result = await mediatR.Send(query);

            return result.Match(Ok, Problem);
        }

        [HttpGet("find")]
        public async Task<IActionResult> CheckUsernameAsync([FromQuery] string nickname) {
            var query = new CheckNickNameQuery(nickname);
            var result = await mediatR.Send(query);

            return result.Match(Ok, Problem);
        }

        [HttpPost("complete")]
        public async Task<IActionResult> CompleteProfileAsync(CompleteProfileDto model) {
            var command = new CompleteProfileCommand(model.Nickname, model.Firstname, model.Lastname, model.PhotoUrl, string.Empty);
            var result = await mediatR.Send(command);

            return result.Match(Ok, Problem);
        }
    }
}