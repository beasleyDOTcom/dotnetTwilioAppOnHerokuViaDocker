using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace dotnetTwilioAppOnHerokuViaDocker
{
    public class Room
    {
        public string roomCode { get; set; }
        public string host { get; set; }
        public List<Performer> participants { get; set; }
    }
}
