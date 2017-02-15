using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MemberCompanyUpdate : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [System.Web.Services.WebMethod]
    public static string UpdateMemberCompanyID(string MemberIDs, int CompanyId, string thisUser)
    {
        try
        {

            var thisMemberIds = MemberIDs.Split(',');
            class_Logging.clsLogging batchLog = new class_Logging.clsLogging();
            var thisBatch = batchLog.getBatch();

            for (int i = 0; i <= thisMemberIds.Length - 1; i++ )
            {
                class_ADO.clsADO thisADO = new class_ADO.clsADO();

                var strSQL = "Update MemberInformationMain set CompanyId = " + CompanyId + ", DateUpdated = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff") + "',  UpdateDatetime = '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff") + "' where MemberId = " + thisMemberIds[i];

                thisADO.updateOrInsert(strSQL, true);

                class_Logging.clsLogging thisLog = new class_Logging.clsLogging();
                thisLog.logChange(thisUser, thisMemberIds[i], "",Convert.ToString(CompanyId), "MemberInformationMain", "Multi-CompanyId Update", thisBatch);
            }
            return "Success";
        }
        catch (Exception ex)
        {
            return (Convert.ToString(ex));
        }
    }
}