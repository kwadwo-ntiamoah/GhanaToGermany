using Microsoft.AspNetCore.SignalR.Client;
using Shared.Post;

namespace PlayGround;

public class Program
{
    public static async Task Main(string[] args)
    {
        var connection = new HubConnectionBuilder()
            .WithUrl("http://localhost:5118/postHub") // Replace with your URL
            .Build();

        connection.On<PostModel>("ReceiveNewPost", post =>
        {
            Console.WriteLine("New post received:");
            Console.WriteLine($"ID: {post.Id}, Title: {post.Title}, Content: {post.Content}");
        });

        await connection.StartAsync();
        Console.WriteLine("Connected to SignalR hub");

        Console.ReadLine(); // Keep the console open
    }
}