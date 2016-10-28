using System;
using System.Web;
using System.Web.UI;
using System.Security.Principal;
using System.DirectoryServices;
using System.Collections;

public partial class Portal2 : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //uncomment for production or security testing

        //if ((string)(Session["IMIN"]) != "true")
        //{
        //    Response.Redirect("http://www.thefastpark.com");
        //} 

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
                Guid objectGuid = new Guid(userDe.NativeGuid);

                //userGuid.Text = Convert.ToString(objectGuid);
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
        groupList = groupList.Replace("\\", "\\\\");
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

    public void BoothLink_Click(object sender, EventArgs e)
    {
        Session["IMINBOOTH"] = "true";
        Response.Redirect("Booth/BoothSearch.aspx");
    }

    private void getUserLocation(string groupList)
    {
        var first = true;
        var thisLocation = "";
        var thisGroups = groupList.Split(',');
        foreach (string locGroup in thisGroups)
        {
            if (locGroup.IndexOf("\\loc") > -1)
            {
                Console.WriteLine(locGroup);
                if (first == true)
                {
                    thisLocation = locGroup.Substring(locGroup.Length - 1, 1);
                    first = false;
                }
                else
                {
                    thisLocation = thisLocation + "," + locGroup.Substring(locGroup.Length - 1, 1);
                }
               
            }
        }
        userLocation.Text = thisLocation;
    }
}
