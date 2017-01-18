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


        ////uncomment for production or security testing

        //if ((string)(Session["IMINBOOTH"]) == "true")
        //{
        //    Response.Redirect("./Booth/BoothSearch.aspx");
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

        Boolean beenToDefault = false;

        if ((string)(Session["IMINBOOTH"]) == "true")
        {
            beenToDefault = true;
        }

        if ((string)(Session["IMIN"]) == "true")
        {
            beenToDefault = true;
        }

        if (beenToDefault == false)
        {
            Response.Redirect("./Default.aspx");
        }


        // if you are a booth person send you to booth, if you don't have groups then you should not be hear
        if (groupList.IndexOf("\\BoothOnly") > -1)
        {
            Response.Redirect("./Booth/BoothSearch.aspx");
        }

        if (groupList == "")
        {
            Response.Redirect("http://www.thefastpark.com");
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

    public void BoothLink_Click(object sender, EventArgs e)
    {
        Session["IMINBOOTH"] = "true";
        Response.Redirect("Booth/BoothSearch.aspx");
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