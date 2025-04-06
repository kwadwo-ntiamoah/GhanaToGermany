using Api.Application.Translations.Command;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using Shared.Translation;

namespace Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class TranslateController(ISender mediatR) : ApiController
    {
        [HttpPost]
        public async Task<IActionResult> TranslateText(TranslateDto model) {
            var command = new TranslateTextCmd(model.PostId);
            var res = await mediatR.Send(command);

            return res.Match(Ok, Problem);
        }
    }
}