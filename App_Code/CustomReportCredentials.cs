﻿using System;
using System.Data;
using System.Configuration;
using System.Net;
using System.Security.Principal;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

using Microsoft.Reporting.WebForms;

/// 
/// Summary description for CustomReportCredentials
/// 
public class CustomReportCredentials :
Microsoft.Reporting.WebForms.IReportServerCredentials
{

    // local variable for network credential.
    private string _UserName;
    private string _PassWord;
    private string _DomainName;
    public CustomReportCredentials(string UserName, string PassWord,
string DomainName)
    {
        _UserName = UserName;
        _PassWord = PassWord;
        _DomainName = DomainName;
    }
    public WindowsIdentity ImpersonationUser
    {
        get
        {
            return null;  // not use ImpersonationUser
        }
    }
    public ICredentials NetworkCredentials
    {
        get
        {

            // use NetworkCredentials
            return new NetworkCredential(_UserName,
_PassWord, _DomainName);
        }
    }
    public bool GetFormsCredentials(out Cookie authCookie,
out string user, out string password, out string authority)
    {

        // not use FormsCredentials unless you have implements a custom autentication.
        authCookie = null;
        user = password = authority = null;
        return false;
    }
}