using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components.WebAssembly.Hosting;
using UI;
using UI.Helpers.Extensions;
using Blazorise;
using Blazorise.Bootstrap5;
using FluentValidation;
using CurrieTechnologies.Razor.SweetAlert2;
using Blazorise.Icons.FontAwesome;
using UI.Services;



var builder = WebAssemblyHostBuilder.CreateDefault(args);

builder.Services
    .AddBlazorise()
    .AddBootstrap5Providers()
    .AddFontAwesomeIcons();

builder.Services.AddValidatorsFromAssembly(typeof(App).Assembly);
builder.Services.AddSweetAlert2();

builder.Services
    .AddBaseHttpClient(builder.HostEnvironment.BaseAddress)
    .AddCustomAuthentication();
builder.Services.AddScoped<IFlowbiteService, FlowbiteService>();

builder.RootComponents.Add<App>("#app");
builder.RootComponents.Add<HeadOutlet>("head::after");

await builder.Build().RunAsync();
