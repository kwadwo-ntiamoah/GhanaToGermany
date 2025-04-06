using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Api.Domain
{
    public class Translation
    {
       public Guid Id {get; private set;}
        public Guid PostId {get; private set;}
        public Post? Post {get; private set;}
        public string Text {get; private set;} = string.Empty;
        public string TranslatedText {get; set;} = string.Empty;
        public DateTime DateCreated {get; private set;} = DateTime.Now;

        public static Translation Create(Guid postId, string text, string translation) {
            return new Translation {
                Id = Guid.NewGuid(),
                PostId = postId,
                Text = text,
                TranslatedText = translation,
            };
        }
    }
}