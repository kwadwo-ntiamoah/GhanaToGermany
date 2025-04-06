using Api.Domain;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Api.Infrastructure.Persistence.Configurations
{
    public class BookmarkConfiguration : IEntityTypeConfiguration<Bookmark>
    {
        public void Configure(EntityTypeBuilder<Bookmark> builder)
        {
            builder.ToTable("Bookmarks");
            
            builder.HasKey(x => x.Id);
            builder.HasIndex(x => x.PostId);
            builder.HasIndex(x => x.UserId);
            builder.HasIndex(x => x.IsBookmarked);
        }
    }
}