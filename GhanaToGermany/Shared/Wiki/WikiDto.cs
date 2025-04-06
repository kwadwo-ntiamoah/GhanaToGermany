namespace Shared.Wiki
{
    public class GetWikiDto {
        public Guid? WikiId {get; set;}
    }

    public class AddWikiDto
    {
        public string Title { get; set; } = string.Empty;
        public string Content { get; set; } = string.Empty;
        public string Thumbnail { get; set; } = string.Empty;
    }

    public class AddWikiCommentDto {
        public string Content {get; set;} = null!;
    }
}