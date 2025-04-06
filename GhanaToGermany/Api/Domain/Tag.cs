using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace Api.Domain
{
    public class Tag
    {
        public Guid Id {get;set;}

        [MaxLength(255)]
        [Required]
        public string Name {get; set;} = string.Empty;
        public DateTime CreatedDate {get; set;} = DateTime.Now;
        public bool IsActive {get; set;} = true;

        public static Tag Create(string name) {
            return new Tag {
                Name = name
            };
        }
    }
}