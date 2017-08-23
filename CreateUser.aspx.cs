using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using class_ADO;
using System.Data.SqlClient;

public partial class CreateUser : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            GetLocations();
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        Guid g;
        // Create and display the value of two GUIDs.
        g = Guid.NewGuid();
        Console.WriteLine(g);

        string username = userName.Text;

        string strSQL = null;
        strSQL = "Insert into aspnetdb.dbo.aspnet_Users (ApplicationId, UserId, UserName, LoweredUserName, MobileAlias, IsAnonymous, LastActivityDate) " +
                 "Values ('47019AC9-8D6F-460E-BB2D-6EF86AD222C0', '" + g + "', '" + username + "', '" + username.ToLower() + "', NULL, 0, getdate())";

        clsADO insertUser = new clsADO();
        insertUser.updateOrInsert(strSQL, false);

        strSQL = "Insert into aspnetdb.dbo.aspnet_Membership (ApplicationId, UserId, Password, PasswordFormat, PasswordSalt, MobilePin, Email, LoweredEmail, IsApproved, IsLockedOut, CreateDate, LastLoginDate, LastPasswordChangedDate, LastLockoutDate, FailedPasswordAttemptCount, FailedPasswordAttemptWindowStart, FailedPasswordAnswerAttemptCount, FailedPasswordAnswerAttemptWindowStart) " +
                 "Values ('47019AC9-8D6F-460E-BB2D-6EF86AD222C0', '" + g + "', 'HOLD', 1, 'HOLD', NULL, '" + email.Text + "', '" + email.Text.ToLower() + "', 1, 0, getDate(), getDate(), getDate(), getDate(), 0, getDate(), 0, getDate())";

        insertUser.updateOrInsert(strSQL, false);

        Int16 I;

        for (I = 0; I <= ListBox1.Items.Count - 1; I++)
        {
            strSQL = "Insert into dbIntranet.dbo.UserLoginLocations (UserId, Location, LocationId, IsPrimary) " +
                 "Values ('" + g + "', '000', " + DropDownList1.Items[I].Value + ", NULL)";

            insertUser.updateOrInsert(strSQL, false);
        }
        
    }

    protected void GetLocations()
    {
        Int16 I;

        string strSQL = null;
        strSQL = "Select * from LocationDetails";

        clsADO thisADO = new clsADO();
        List<clsADO.sql2DObject> thisList;
        thisList = thisADO.return2DListLocal(strSQL);
        
        for (I = 0; I <= thisList.Count - 1; I++)
        {
            ListItem test = new ListItem { Text = thisList[I].two.ToString(), Value = thisList[I].one.ToString() };
            DropDownList1.Items.Add(test);
        }
    }

    protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        ListItem test = new ListItem { Text = DropDownList1.SelectedItem.ToString(), Value = DropDownList1.SelectedItem.Value };
        ListBox1.Items.Add(test);
    }
}