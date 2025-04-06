namespace Shared.Invoices
{
    public class GetNewsDto {
        public Guid? NewsId {get; set;}
    }

    public class AddNewsCommentDto {
        public string Content {get; set;} = null!;
    }
}