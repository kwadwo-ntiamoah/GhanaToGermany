using Api.Application.Authentication.Commands;
using Api.Application.Authentication.Queries;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Shared.Auth;

namespace Api.Controllers
{
    [AllowAnonymous]
    [Route("api/[controller]")]
    public class AuthController(ISender mediatR) : ApiController
    {
        [HttpPost("local/login")]
        public async Task<IActionResult> PortalLoginAsync(LocalLoginDto model)
        {
            var query = new LocalLoginQuery(model.Email, model.Password);
            var result = await mediatR.Send(query);
            
            return result.Match(Ok, Problem);
        }
        
        [HttpPost("mobile/login")]
        public async Task<IActionResult> MobileLoginAsync(LocalLoginDto model)
        {
            var query = new MobileLoginQuery(model.Email, model.Password);
            var result = await mediatR.Send(query);
            
            return result.Match(Ok, Problem);
        }

        [HttpPost("mobile/register")]
        public async Task<IActionResult> MobileRegisterAsync(LocalRegisterDto model) {
            var command = new MobileRegistrationCmd(model);
            var result = await mediatR.Send(command);
            
            return result.Match(Ok, Problem);
        }
        
        [HttpPost("mobile/social")]
        public async Task<IActionResult> MobileSocialAsync(SocialRegisterDto model) {
            var command = new SocialLoginCmd(model);
            var result = await mediatR.Send(command);

            return result.Match(Ok, Problem);
        }
    }
}