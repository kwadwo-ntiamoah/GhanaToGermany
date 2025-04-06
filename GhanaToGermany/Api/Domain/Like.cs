namespace Api.Domain
{
    public class Like
    {
        public Guid Id {get; private set;}
        public Guid PostId {get; private set;}
        public string UserId {get; private set;} = null!;
        public bool IsLiked {get; private set;} = false;
        public DateTime DateCreated {get; private set;} = DateTime.Now;
        public DateTime DateModified {get; private set;}

        public static Like Create(Guid postId, string userId) {
            return new Like {
                Id = Guid.NewGuid(),
                PostId = postId,
                UserId = userId,
                IsLiked = true
            };
        }

        public void ToggleLike() {
            IsLiked = !IsLiked;
            DateModified = DateTime.Now;
        }
    }
}