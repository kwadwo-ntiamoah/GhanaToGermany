using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components.WebAssembly.Hosting;
using UI;
using UI.Helpers.Extensions;
using Blazorise;
using Blazorise.Tailwind;
using Blazorise.Icons.FontAwesome;



var builder = WebAssemblyHostBuilder.CreateDefault(args);

builder.Services
    .AddBlazorise()
    .AddTailwindProviders()
    .AddFontAwesomeIcons();

builder.Services
    .AddBaseHttpClient(builder.HostEnvironment.BaseAddress)
    .AddCustomAuthentication();

builder.RootComponents.Add<App>("#app");
builder.RootComponents.Add<HeadOutlet>("head::after");

await builder.Build().RunAsync();
