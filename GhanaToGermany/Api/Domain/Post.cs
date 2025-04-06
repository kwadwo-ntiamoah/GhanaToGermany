using System.ComponentModel.DataAnnotations;
using Shared.Post;

namespace Api.Domain
{
    public class Post
    {
        private readonly List<Comment> _comments = [];
        public Guid Id {get; private set;}

        [MaxLength(100)] public string Title { get; private set; } = string.Empty;

        [MaxLength(5000)] public string Content { get; private set; } = string.Empty;
        
        [MaxLength(500)]
        public string? Thumbnail {get; private set;}
        public bool IsDeleted {get; private set;}
        public bool IsLiked { get; private set; }

        [AllowedValues("wiki", "post", "news")]
        [MaxLength(50)]
        public string Type { get; private set; } = string.Empty;

        [MaxLength(255)]
        public string? Tag {get; private set;} 
        [MaxLength(50)] public string Owner { get; private set; } = string.Empty;
        public DateTime DateCreated {get; private set;} = DateTime.Now;
        public DateTime DateModified {get; private set;}

        public List<Comment> Comments => _comments.ToList();

        public static Post Create(string title, string content, string owner, string type, string? thumbnail, string? tag)
        {
            return new Post
            {
                Id = Guid.NewGuid(),
                Title = title,
                Content = content,
                Owner = owner,
                Type = type,
                Tag = tag,
                Thumbnail = thumbnail
            };
        }

        public void UpdateTitle(string newTitle) {
            Title = newTitle;
            DateModified = DateTime.Now;
        }

        public void UpdateContent(string newContent) {
            Content = newContent;
            DateModified = DateTime.Now;
        }

        public void DeletePost() {
            IsDeleted = true;
            DateModified = DateTime.Now;
        }

        public void AddComment(Comment comment)
        {
            _comments.Add(comment);
        }

        public void LikePost()
        {
            IsLiked = true;
        }
    }
}