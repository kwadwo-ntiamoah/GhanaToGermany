namespace Shared.Wiki
{
    public class GetPostDto {
        public Guid? PostId {get; set;}
    }

    public class AddPostDto
    {
        public string Title { get; set; } = string.Empty;
        public string Content { get; set; } = string.Empty;
        public string? Thumbnail { get; set; }
        public string? Tag {get; set;}
    }

    public class AddPostCommentDto {
        public string Content {get; set;} = null!;
    }
}