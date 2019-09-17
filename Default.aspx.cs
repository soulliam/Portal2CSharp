using System;
using System.Collections;
using System.Security.Principal;
using System.Web.UI;

public partial class _Default : System.Web.UI.Page
{


    protected void Page_Load(object sender, EventArgs e)
    {
        var user = Page.User.Identity.Name;
        
        //Create session variable with members groups
        string groupList = "";
        Boolean first = true;

        ArrayList groups = new ArrayList();

        groups = Groups();

        foreach (string group in groups)
        {
            if (first == true)
            {
                groupList = groupList + group;
                first = false;
            }
            else
            {
                groupList = groupList + ',' + group;
            }
        }

        if (groupList.IndexOf("PCA\\Portal") < 0)
        {
            Response.Redirect("http://www.thefastpark.com");
        }

        //++++++++++++++++++++test for aspnet user++++++++++++++++++++++++++++++
        var userTest = user;
        userTest = userTest.Substring(4, userTest.Length - 4);

        var thisADO = new class_ADO.clsADO();

        //userTest = "rfart";

        var userSQL = "Select UserId from aspnetdb.dbo.aspnet_Users where username = '" + userTest + "'";

        var isUser = thisADO.returnSingleValue(userSQL, false);


        if (isUser == null && !IsPostBack)
        {
            Response.Write("<script>alert('User has not been added to aspnet_users.  The application will continue, but please contact IT about this issue.');</script>");
            ClientScript.RegisterStartupScript(typeof(Page), "autoPostback", ClientScript.GetPostBackEventReference(this, String.Empty), true);
            return;
        }
        //++++++++++++++++++++test for aspnet user++++++++++++++++++++++++++++++

        Session["UserName"] = user;

        Session["groupList"] = groupList;

        if (groupList.IndexOf("\\BoothOnly") > -1)
        {
            Session["IMINBOOTH"] = "true";
            class_Logging.clsLogging newLogin = new class_Logging.clsLogging();
            newLogin.logChange(user, "", "", "", "", "New Booth Login", newLogin.getBatch());
            Response.Redirect("./Booth/BoothSearch.aspx");
        }
        else
        {
            if (groupList.IndexOf("\\Booth") > -1)
            {
                Session["IMINBOOTH"] = "true";
            }
            Session["IMIN"] = "true";
            class_Logging.clsLogging newLogin = new class_Logging.clsLogging();
            newLogin.logChange(user, "", "", "", "", "New Login", newLogin.getBatch());
            Response.Redirect("./MemberSearch.aspx");
        }
    }

    public ArrayList Groups()
    {
        ArrayList groups = new ArrayList();

        foreach (IdentityReference group in System.Web.HttpContext.Current.Request.LogonUserIdentity.Groups)
        {
            groups.Add(group.Translate(typeof(NTAccount)).ToString());
        }

        return groups;
    }
}
