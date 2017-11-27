using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using class_ADO;
using class_Logging;

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

    [System.Web.Services.WebMethod]
    public static string SendEmail(string ToAddress, string From, string Subject, string Body, int LocationId, bool IsHtml)
    {
        try
        {
            clsADO thisADO = new clsADO();

            string strSQL = "Select ManagerEmail from LocationDetails where LocationId = " + LocationId;

            string managerEmail = Convert.ToString(thisADO.returnSingleValue(strSQL, true));

            ToAddress = ToAddress + "," + managerEmail;

            clsCommon thisEmail = new clsCommon();

            thisEmail.SendEmail(ToAddress, From, Subject, Body, IsHtml);

            return "Email Sent!";
        }
        catch (Exception ex)
        {
            clsLogging logSearch = new clsLogging();
            logSearch.logChange("System", "0","0", "0", "Issue sending email.",  ex.ToString(), logSearch.getBatch());
            return (Convert.ToString(ex));
        }
    }
}