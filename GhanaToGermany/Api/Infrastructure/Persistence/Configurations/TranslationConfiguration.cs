using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Api.Domain;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Api.Infrastructure.Persistence.Configurations
{
    public class TranslationConfiguration : IEntityTypeConfiguration<Translation>
    {
        public void Configure(EntityTypeBuilder<Translation> builder)
        {
            builder.ToTable("Translations");

            builder.HasKey(x => x.Id);
            builder.HasIndex(x => x.PostId);
            builder.HasOne(x => x.Post)
                .WithOne()
                .HasForeignKey<Translation>(t => t.PostId);
        }
    }
}