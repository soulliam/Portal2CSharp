using System;
using System.Web;
using System.Web.UI;
using System.Security.Principal;
using System.DirectoryServices;
using System.Collections;

public partial class Portal2Report : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        loginLabel.Text = Page.User.Identity.Name;
        txtLoggedinUsername.Value = Page.User.Identity.Name;


        if (HttpContext.Current.User.Identity.IsAuthenticated)
        {
            Page.Title = "Portal for " + HttpContext.Current.User.Identity.Name;
        }
        else
        {
            Page.Title = "Portal for guest user.";
        }

        //Get member SID and place in hidden textbox
        IPrincipal userPrincipal = HttpContext.Current.User;
        WindowsIdentity windowsId = userPrincipal.Identity as WindowsIdentity;
        if (windowsId != null)
        {
            SecurityIdentifier sid = windowsId.User;


            using (DirectoryEntry userDe = new DirectoryEntry("LDAP://<SID=" + sid.Value + ">"))
            {
                //Guid objectGuid = new Guid(userDe.NativeGuid);

                string myGuid = Convert.ToString(userDe.Guid);
                myGuid = myGuid.Replace("{", "");
                myGuid = myGuid.Replace("}", "");

                //userGuid.Text = Convert.ToString(objectGuid);
                //userGuid.Text = myGuid;

                //this one is hear so we can save the user guid but, for now, send a common token to CoS
                tempUserGuid.Text = myGuid;

                Session["GUID"] = userGuid.Text;
            }
        }
    }
}
