using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.DirectoryServices.AccountManagement;
using System.Security.Principal;
using System.DirectoryServices;
using System.Collections;
using System.Net;
using System.IO;
using System.Text;
using System.Web.Security;

public partial class Portal2Booth : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if ((string)(Session["IMINBOOTH"]) != "true"  || (string)(Session["IMIN"]) != "true")
        {
            Response.Redirect("http://www.thefastpark.com");
        }

        logOutLabel.Attributes.Add("onclick", "return logout();");

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

        //Get member Guid and place in hidden textbox
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
                tempUserGuid.Text = myGuid;

                Session["GUID"] = userGuid.Text;
            }
        }

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

        Session["groupList"] = groupList;

        getUserLocation(groupList);
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

    private void getUserLocation(string groupList)
    {
        var first = true;
        var locationList = "";
        string[] thisLocation;
        var thisGroups = groupList.Split(',');
        foreach (string locGroup in thisGroups)
        {
            if (locGroup.IndexOf("\\Loc_") > -1)
            {
                Console.WriteLine(locGroup);
                if (first == true)
                {
                    thisLocation = locGroup.Split('_');
                    locationList = thisLocation[2];
                    first = false;
                }
                else
                {
                    thisLocation = locGroup.Split('_');
                    locationList = locationList + "," + thisLocation[2];
                }

            }
        }
        userLocation.Text = locationList;
    }

}
