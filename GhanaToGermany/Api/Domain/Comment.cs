namespace Api.Domain
{
    public class Comment
    {
        public Guid Id {get; private set;}
        public Guid PostId {get; private set;}
        public Post? Post {get; private set;} // shadow property
        public string Owner {get; private set;} = null!;
        public string Content {get; private set;} = null!;
        public bool IsDeleted {get; private set;} = false;
        public DateTime DateCreated {get; private set;} = DateTime.Now;
        public DateTime DateModified {get; private set;}

        public static Comment Create(Guid postId, string owner, string Content) {
            return new Comment {
                Id = Guid.NewGuid(),
                PostId = postId,
                Owner = owner,
                Content = Content
            };
        }

        public void RemoveComment() {
            IsDeleted = true;
            DateModified = DateTime.Now;
        }
    }
}