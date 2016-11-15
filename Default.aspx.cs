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

        if (groupList.IndexOf("\\BoothOnly,") > -1)
        {
            Session["IMINBOOTH"] = "true";
            class_Logging.clsLogging newLogin = new class_Logging.clsLogging();
            newLogin.logChange(user, "", "", "", "", "New Booth Login", newLogin.getBatch());
            Response.Redirect("./Booth/BoothSearch.aspx");
        }
        else
        {
            if (groupList.IndexOf("\\Booth,") > -1)
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
