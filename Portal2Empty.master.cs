using System;
using System.Collections.Generic;
using System.DirectoryServices;
using System.Linq;
using System.Security.Principal;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Portal2Empty : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
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

                Session["GUID"] = userGuid.Text;
            }
        }
    }
}
