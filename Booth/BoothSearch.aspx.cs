using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using class_Logging;
using class_ADO;

public partial class Booth_BoothSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [System.Web.Services.WebMethod]
    public static string LogEmailChange(string thisUserName, string thisMemberId, string thisOld, string thisNew)
    {
        try
        {
            clsLogging logEmailRequest = new clsLogging();

            logEmailRequest.logChange(thisUserName, thisMemberId, thisOld, thisNew, "MemberInformation", "Cashier Booth Email Change", logEmailRequest.getBatch());
            return "Request Made";
        }
        catch (Exception ex)
        {
            return Convert.ToString(ex);
        }
    }

    [System.Web.Services.WebMethod]
    public static string logSearch(string thisUserName, string thisMemberId, string thisOld, string thisNew)
    {
        try
        {
            clsLogging logSearch = new clsLogging();

            logSearch.logChange(thisUserName, thisMemberId, thisOld, thisNew, "", "Booth Search", logSearch.getBatch());

            return "";
        }
        catch (Exception ex)
        {
            return Convert.ToString(ex);
        }
    }


    [System.Web.Services.WebMethod]
    public static string submitReceipt(string thisReceiptNumber, DateTime thisdate, Int32 thisMemberId, Int32 thisLocationId, string thisUser)
    {
        string strSQL = null;
        clsADO thisADO = new clsADO();

        try
        {
            strSQL = "Insert Into PendingReceipts (MemberId, LocationId, ReceiptNumber, SubmittedDate, ExplanationId, SubmittedByUserId, EntryDate, Processed) " +
                     "Values\t(" + thisMemberId + ", " + thisLocationId + ", '" + thisReceiptNumber + "', '" + DateTime.Now + "', " + "49, '" + thisUser + "', '" + thisdate + "', 0)";

            thisADO.updateOrInsert(strSQL, false);

            return "Receipt has been submitted.";

        }
        catch (Exception ex)
        {
            return Convert.ToString(ex);
        }

    }

}