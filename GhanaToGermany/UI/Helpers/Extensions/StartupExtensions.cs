using Microsoft.AspNetCore.Components.Authorization;

namespace UI.Helpers.Extensions;

public static class StartupExtensions
{
    public static IServiceCollection AddCustomAuthentication(this IServiceCollection services)
    {
        services.AddSingleton<AuthenticationStateProvider>(provider => provider.GetRequiredService<CookieAuthStateProvider>());
        services.AddSingleton<CookieAuthStateProvider>();
        services.AddAuthorizationCore();

        return services;
    }

    public static IServiceCollection AddBaseHttpClient(this IServiceCollection services, string baseAddress)
    {
        services.AddScoped(provider => new CookieAuthenticationHandler(provider.GetRequiredService<CookieAuthStateProvider>()));             

        services.AddHttpClient("GhanaToGermany.Server", client => 
        { 
            client.BaseAddress = new Uri(baseAddress);
            client.Timeout = TimeSpan.FromMinutes(10);
        }).AddHttpMessageHandler<CookieAuthenticationHandler>();

        services.AddScoped(sp => sp.GetRequiredService<IHttpClientFactory>().CreateClient("GhanaToGermany.Server"));

        return services;
    }
}