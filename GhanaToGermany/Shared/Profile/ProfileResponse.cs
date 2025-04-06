using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Shared.Profile
{
    public record ProfileResponse(
    String Email, 
    string Nickname,
    string FullName,
    string ProfilePhoto,
    string Photos
);

}