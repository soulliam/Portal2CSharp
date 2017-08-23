using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ReservationMaintenance : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Guid g;
        // Create and display the value of two GUIDs.
        g = Guid.NewGuid();
        Console.WriteLine(g);
        Console.WriteLine(Guid.NewGuid());
    }
}