using ErrorOr;

namespace Api.Application.Common.Errors
{
    public static partial class Errors
    {
        public static class Auth
        {
            public static Error InvalidCredentials => Error.Unauthorized(code: "Auth.InvalidCredentials", description: "Invalid login credentials");
        }
        public static class News {
            public static Error NotFound => Error.NotFound(code: "News.NotFound", description: "News not found");
        }

        public static class Wiki {
            public static Error NotFound => Error.NotFound(code: "Wiki.NotFound", description: "Wiki not found");
        }

        public static class Post {
            public static Error NotFound => Error.NotFound(code: "Post.NotFound", description: "Post not found");
        }
    }
}