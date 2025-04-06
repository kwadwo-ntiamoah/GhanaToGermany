using Microsoft.AspNetCore.Components.WebAssembly.Http;

namespace UI.Helpers.Extensions;

public class CookieAuthenticationHandler(CookieAuthStateProvider authStateProvider) : DelegatingHandler
{
    protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
    {
        request.SetBrowserRequestCredentials(BrowserRequestCredentials.Include);

        var result =  await base.SendAsync(request, cancellationToken);

        if (result.StatusCode == System.Net.HttpStatusCode.Unauthorized)
        {
            authStateProvider.LogOut();
        }

        return result;
    }
}