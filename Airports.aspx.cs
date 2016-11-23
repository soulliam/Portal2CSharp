using System;
using System.Collections.Generic;
using System.DirectoryServices;
using System.DirectoryServices.ActiveDirectory;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Airports : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ////TEST to find custom user properties from AD
        //DirectoryContext domainContext = new DirectoryContext(DirectoryContextType.Domain, "pca");

        //var domain = System.DirectoryServices.ActiveDirectory.Domain.GetDomain(domainContext);
        //var controller = domain.FindDomainController();

        //DirectoryEntry directoryEntry = new DirectoryEntry("LDAP://" + controller);

        //string username = Page.User.Identity.Name;

        //username = username.Replace("PCA\\", "");

        ////Create a searcher on your DirectoryEntry
        //DirectorySearcher adSearch = new DirectorySearcher(directoryEntry);
        //adSearch.SearchScope = SearchScope.Subtree;    //Look into all subtree during the search
        //adSearch.Filter = "(&(ObjectClass=user)(sAMAccountName=" + username + "))";    //Filter information, here i'm looking at a user with given username
        //SearchResult sResult = adSearch.FindOne();       //username is unique, so I want to find only one

        //if (sResult.Properties.Contains("displayname"))     //Let's say I want the company name (any property here)
        //{
        //    string companyName = sResult.Properties["displayname"][0].ToString();    //Get the property info
        //}


    }
}