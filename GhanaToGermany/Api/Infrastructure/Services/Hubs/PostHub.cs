using Microsoft.AspNetCore.SignalR;
using Shared.Post;

namespace Api.Infrastructure.Services.Hubs;

public class PostHub: Hub
{
    public async Task SendPostAddedAsync(PostModel post)
    {
        await Clients.All.SendAsync(PostHub.ReceiveNewPostEvent, post);
    }

    public async Task SendNewsAddedAsync(PostModel post)
    {
        await Clients.All.SendAsync(PostHub.ReceiveNewNewsEvent, post);
    }

    public async Task SendWikiAddedAsync(PostModel post)
    {
        await Clients.All.SendAsync(PostHub.ReceiveNewWikiEvent, post);
    }

    public const string ReceiveNewPostEvent = "ReceiveNewPost";
    public const string ReceiveNewNewsEvent = "ReceiveNewNews";
    public const string ReceiveNewWikiEvent = "ReceiveNewWiki";
}