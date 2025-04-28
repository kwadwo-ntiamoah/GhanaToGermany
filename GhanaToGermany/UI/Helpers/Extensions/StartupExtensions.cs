using Microsoft.AspNetCore.Components.Authorization;

namespace UI.Helpers.Extensions;

public static class StartupExtensions
{
    public static IServiceCollection AddCustomAuthentication(this IServiceCollection services)
    {
        // services.AddSingleton<AuthenticationStateProvider>(provider => provider.GetRequiredService<CookieAuthStateProvider>());
        // services.AddSingleton<CookieAuthStateProvider>();
        services.AddAuthorizationCore();

        services.AddScoped<CookieAuthStateProvider>();
        services.AddScoped<AuthenticationStateProvider>(sp => sp.GetRequiredService<CookieAuthStateProvider>());

        return services;
    }

    public static IServiceCollection AddBaseHttpClient(this IServiceCollection services, string baseAddress)
    {
        // Register the default HttpClient for Blazor WebAssembly
        services.AddScoped(sp => new HttpClient
        {
            BaseAddress = new Uri(baseAddress),
            Timeout = TimeSpan.FromMinutes(10)
        });

        // Register ICustomHttpClient
        services.AddScoped<ICustomHttpClient, CustomHttpClient>();

        return services;
    }
}