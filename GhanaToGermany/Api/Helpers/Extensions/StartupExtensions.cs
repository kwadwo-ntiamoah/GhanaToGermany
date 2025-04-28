using System.Reflection;
using System.Text;
using Api.Application.Abstraction.Persistence;
using Api.Application.Common.Abstraction.Persistence;
using Api.Application.Common.Abstraction.Services;
using Api.Domain;
using Api.Helpers.Utilities;
using Api.Infrastructure.Persistence;
using Api.Infrastructure.Persistence.Repositories;
using Api.Infrastructure.Services;
using FluentValidation;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using RabbitMQ.Client;

namespace Api.Helpers.Extensions
{
    public static class StartupExtensions
    {
        public static IServiceCollection AddDatabaseContext(this IServiceCollection services, IConfiguration config) {
            services.AddDbContext<AppDbContext>(options => options.UseNpgsql(config.GetConnectionString("DbConnection")));

            return services;
        }
        
        public static IServiceCollection AddJwtAuthentication(this IServiceCollection services, IConfiguration configuration)
        {
            services.AddAuthentication("bearer")
                .AddJwtBearer("bearer", options =>
                {
                    options.TokenValidationParameters = new TokenValidationParameters
                    {
                        ValidateIssuer = true,
                        ValidateAudience = true,
                        ValidateLifetime = true,
                        ValidateIssuerSigningKey = true,

                        ValidIssuer = configuration.GetValue<string>("JWT:Issuer"),
                        ValidAudience = configuration.GetValue<string>("JWT:Audience"),
                        IssuerSigningKey = new SymmetricSecurityKey(Encoding.ASCII.GetBytes(configuration.GetValue<string>("JWT:Key")!)),

                    };
                });

            services.AddControllers();
            services.AddAuthorization();
            services.AddScoped<IJwtService, JwtService>();

            return services;
        }
        
        public static IServiceCollection AddCookieAuthentication(this IServiceCollection services, IConfiguration config)
        {
            services.AddAuthentication(options =>
                {
                    options.DefaultScheme = IdentityConstants.ApplicationScheme;
                    options.DefaultSignInScheme = IdentityConstants.ExternalScheme;
                })
                .AddIdentityCookies();


            services.ConfigureApplicationCookie(options =>
            {   
                options.Cookie.Name = "Asp.Net.Cookie.GhanaToGermany";
                options.Cookie.HttpOnly = true;
                options.Cookie.SameSite = SameSiteMode.None;
                options.Cookie.SecurePolicy = CookieSecurePolicy.Always;
                options.SlidingExpiration = true;
                options.ExpireTimeSpan = TimeSpan.FromMinutes(5);
                options.LoginPath = "/";
                options.AccessDeniedPath = "/";
                options.Events.OnRedirectToLogin = context =>
                {
                    context.Response.Headers.Location = context.RedirectUri;
                    context.Response.StatusCode = 401;
                    return Task.CompletedTask;
                };
            });

            services.Configure<SecurityStampValidatorOptions>(options =>
            {
                options.ValidationInterval = TimeSpan.FromSeconds(5);
            });


            return services;
        }

        public static IServiceCollection AddCustomIdentity(this IServiceCollection services)
        {
            services.AddIdentityCore<ApplicationUser>()
                .AddRoles<IdentityRole>()
                .AddSignInManager()
                .AddEntityFrameworkStores<AppDbContext>()
                .AddDefaultTokenProviders();

            services.Configure<DataProtectionTokenProviderOptions>(options =>
                options.TokenLifespan = TimeSpan.FromDays(7));

            services.Configure<IdentityOptions>(options =>
            {
                // User settings
                options.User.RequireUniqueEmail = false;

                options.Password.RequireDigit = true;
                options.Password.RequireLowercase = true;
                //options.Password.RequireNonAlphanumeric = false;
                options.Password.RequireNonAlphanumeric = true;
                options.Password.RequireUppercase = true;
                options.Password.RequiredLength = 8;
                //options.Password.RequiredUniqueChars = 1;
                //options.SignIn.RequireConfirmedEmail = true;

                options.Lockout.AllowedForNewUsers = true;
                options.Lockout.DefaultLockoutTimeSpan = TimeSpan.FromMinutes(15);
            });

            services.AddScoped<IUserClaimsPrincipalFactory<ApplicationUser>, CustomUserClaimsPrincipalFactory>();

            return services;
        }

        public static IServiceCollection AddThirdPartyLibs(this IServiceCollection services, IConfiguration config) {
            services.AddMediatR(options => options.RegisterServicesFromAssembly(typeof(Program).Assembly));
            services.AddValidatorsFromAssembly(Assembly.GetExecutingAssembly());

            return services;
        }

        public static IServiceCollection AddPersistence(this IServiceCollection services, IConfiguration config) {
            services.AddScoped<IUnitOfWork, UnitOfWork>();
            services.AddScoped<IBookmarkRepository, BookmarkRepository>();
            services.AddScoped<ICommentRepository, CommentRepository>();
            services.AddScoped<ILikeRepository, LikeRepository>();
            services.AddScoped<IPostRepository, PostRepository>();
            
            return services;
        }

        public static IServiceCollection AddCustomServices(this IServiceCollection services) {
            services.AddScoped<TranslationService>();

            return services;
        }
    }
}