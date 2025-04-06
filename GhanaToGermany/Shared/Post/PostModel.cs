namespace Shared.Post;

public class PostModel
{
    public Guid Id {get; init;}
    public string Title {get; set;} = null!;
    public string Content {get; set;} = null!;
    public string? Thumbnail {get; set;}
    public string Type { get; set; } = string.Empty;
    public bool IsLiked { get; set; } = false;
    public string Owner {get; set;} = null!;
    public DateTime DateCreated {get; set;} = DateTime.Now;
    public int LikeCount { get; set; }
    public int BookmarkCount { get; set; }
    public int CommentCount { get; set; }
}

public class TagsModel {
    public string Name {get; set;} = string.Empty;
}