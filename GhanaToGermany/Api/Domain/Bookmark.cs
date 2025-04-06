namespace Api.Domain
{
    public class Bookmark
    {
        public Guid Id {get; private set;}
        public Guid PostId {get; private set;}
        public string UserId {get; private set;} = null!;
        public bool IsBookmarked {get; private set;} = false;
        public DateTime DateCreated {get; private set;} = DateTime.Now;
        public DateTime DateModified {get; private set;}

        public static Bookmark Create(Guid postId, string userId) {
            return new Bookmark {
                Id = Guid.NewGuid(),
                PostId = postId,
                UserId = userId,
                IsBookmarked = true
            };
        }

        public void ToggleBookmark() {
            IsBookmarked = !IsBookmarked;
            DateModified = DateTime.Now;
        }
    }
}