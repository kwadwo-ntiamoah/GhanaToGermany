using Api.Domain;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Api.Infrastructure.Persistence.Configurations
{
    public class PostConfiguration : IEntityTypeConfiguration<Post>
    {
        public void Configure(EntityTypeBuilder<Post> builder)
        {
            builder.ToTable("Posts");
            
            builder.HasKey(x => x.Id);
            builder.HasIndex(x => x.Title);
            builder.HasIndex(x => x.IsDeleted);

            builder.HasMany(x => x.Comments)
                .WithOne(c => c.Post)
                .HasForeignKey(c => c.PostId);
        }
    }
}