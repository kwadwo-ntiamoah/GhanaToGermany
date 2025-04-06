using System.Net.Http.Json;
using System.Security.Claims;
using Microsoft.AspNetCore.Components.Authorization;

namespace UI.Helpers;

public class CookieAuthStateProvider(IHttpClientFactory httpClientFactory) : AuthenticationStateProvider
{
        private static readonly AuthenticationState NotAuthenticatedState = new AuthenticationState(new ClaimsPrincipal());

        private ClaimsPrincipal _claimsPrincipal = new ClaimsPrincipal(new ClaimsIdentity());
        private string? _userInfo;

        private AuthenticationState GetState()
        {
            return _userInfo != null ? new AuthenticationState(_claimsPrincipal) : NotAuthenticatedState;
        }


        public void Login(string fullName)
        {
            _userInfo = fullName;

            //var principal = JwtSerialize.Deserialize(jwt);
            var claims = new List<Claim> {
                        new Claim(ClaimTypes.NameIdentifier, _userInfo)};
                        // new Claim(ClaimTypes.Name, _userInfo.UserName),
                        // new Claim("UserId", _userInfo.Email),
                        // new Claim("FullName", _userInfo.FullName)};

            // if (_userInfo.Roles.Any())
            //     claims.AddRange(_userInfo.Roles.Select(role => new Claim(ClaimsIdentity.DefaultRoleClaimType, role)));

            var identity = new ClaimsIdentity(claims, "AuthCookie");

            _claimsPrincipal = new ClaimsPrincipal(identity);

            NotifyAuthenticationStateChanged(Task.FromResult(GetState()));
        }





        public override async Task<AuthenticationState> GetAuthenticationStateAsync()
        {
            if (_userInfo != null) return new AuthenticationState(_claimsPrincipal);
            
            var client = httpClientFactory.CreateClient("GhanaToGermany.Server");
            var response = await client.GetAsync("/api/Auth/profile");

            if (!response.IsSuccessStatusCode) return new AuthenticationState(_claimsPrincipal);
            
            _userInfo = await response.Content.ReadFromJsonAsync<string>();

            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, _userInfo!)
            };
                // new Claim(ClaimTypes.Name, _userInfo.UserName),
                // new Claim("UserId", _userInfo.Email),
                // new Claim("FullName", _userInfo.FullName)};

            // if (_userInfo.Roles.Any())
            //     claims.AddRange(_userInfo.Roles.Select(role => new Claim(ClaimsIdentity.DefaultRoleClaimType, role)));

            var identity = new ClaimsIdentity(claims, "AuthCookie");

            _claimsPrincipal = new ClaimsPrincipal(identity);

            NotifyAuthenticationStateChanged(Task.FromResult(GetState()));
            return new AuthenticationState(_claimsPrincipal);
        }

        public void LogOut()
        {
            _userInfo = null;
            _claimsPrincipal = new ClaimsPrincipal(new ClaimsIdentity());
            NotifyAuthenticationStateChanged(Task.FromResult(GetState()));
        }
    }