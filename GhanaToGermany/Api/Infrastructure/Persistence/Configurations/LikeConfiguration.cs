using Api.Domain;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Api.Infrastructure.Persistence.Configurations
{
    public class LikeConfiguration : IEntityTypeConfiguration<Like>
    {
        public void Configure(EntityTypeBuilder<Like> builder)
        {
            builder.ToTable("Likes");
            
            builder.HasKey(x => x.Id);
            builder.HasIndex(x => x.PostId);
            builder.HasIndex(x => x.UserId);
            builder.HasIndex(x => x.IsLiked);
        }
    }
}