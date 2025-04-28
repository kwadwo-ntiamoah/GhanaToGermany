using System.Net.Http.Json;
using System.Security.Claims;
using Microsoft.AspNetCore.Components.Authorization;
using Shared.Auth;
using Shared.Profile;

namespace UI.Helpers;

public class CookieAuthStateProvider(HttpClient client) : AuthenticationStateProvider
    {
        private ClaimsPrincipal _claimsPrincipal = new(new ClaimsIdentity());

        public override async Task<AuthenticationState> GetAuthenticationStateAsync()
        {
            try
            {
                var response = await client.GetAsync("api/auth/profile");

                if (response.IsSuccessStatusCode)
                {
                    // assign content of profile to claims
                    var jsonObj = await response.Content.ReadFromJsonAsync<ProfileResponse>();
                    if (jsonObj == null) return new AuthenticationState(_claimsPrincipal);

                    var claims = new List<Claim>
                    {
                        new(ClaimTypes.Name, jsonObj.FullName),
                        new(ClaimTypes.Email, jsonObj.Email),
                        new("Nickname", jsonObj.Nickname),
                        new("ProfilePhoto", jsonObj.ProfilePhoto),
                    };

                    var identity = new ClaimsIdentity(claims, "AuthCookie");
                    _claimsPrincipal = new ClaimsPrincipal(identity);

                    NotifyAuthenticationStateChanged(Task.FromResult(new AuthenticationState(_claimsPrincipal)));
                }

                return new AuthenticationState(_claimsPrincipal);
            }
            catch (Exception)
            {
                return new AuthenticationState(_claimsPrincipal);
            }
        }

        public void Login(ProfileResponse user)
        {
            var claims = new List<Claim>
            {
                new(ClaimTypes.Name, user.FullName),
                new(ClaimTypes.Email, user.Email),
                new("Nickname", user.Nickname),
                new("ProfilePhoto", user.ProfilePhoto),
            };

            var identity = new ClaimsIdentity(claims, "AuthCookie");
            _claimsPrincipal = new ClaimsPrincipal(identity);

            NotifyAuthenticationStateChanged(Task.FromResult(new AuthenticationState(_claimsPrincipal)));
        }

        public async Task Logout()
        {
            await client.PostAsync("api/auth/logout", null);

            _claimsPrincipal = new ClaimsPrincipal(new ClaimsIdentity());
            NotifyAuthenticationStateChanged(Task.FromResult(new AuthenticationState(_claimsPrincipal)));
        }
    }