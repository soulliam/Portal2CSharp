﻿using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using class_ADO;
using System.Data.SqlClient;
using System.Security.Principal;

public partial class CreateUser : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            GetLocations();
            GetUsedRepIds();
            GetUsedRepMailerIds();
            GetVehicleLocations();

        }

        var ctrlName = Request.Params[Page.postEventSourceID];
        var args = Request.Params[Page.postEventArgumentID];

        if (args == "deleteLocation")
        {
            lbLoginLocations.Items.Remove(lbLoginLocations.Items[lbLoginLocations.SelectedIndex]);
        }

        if (args == "deleteVehicleLocation")
        {
            lbVehicleLocations.Items.Remove(lbVehicleLocations.Items[lbVehicleLocations.SelectedIndex]);
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

        if (groupList.IndexOf("PCA\\Portal_Superadmin") < 0)
        {
            Response.Redirect("http://www.thefastpark.com");
        }

        AddRoles();
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        if (createRepRecord.Checked == false && string.Compare(txtFirstName.Text, "") > 0)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showalert", "alert('You have entered Rep information.  Please check the Create Rep Record checkbox or clear the infromation from the Rep information boxes.');", true);
            return;
        }

        string test = getNewRegion();
        //Create new Guid
        Guid g = Guid.NewGuid();

        //Pass username, guid, email and password to Create user stored procedure on aspnetdb 
        string strSQL = null;
        strSQL = "EXECUTE aspnetdb.dbo.CreateUser '" + userName.Text + "', '" + txtPassword.Text + "', '" + email.Text + "', '" + g + "'";

        clsADO insertUser = new clsADO();
        insertUser.updateOrInsert(strSQL, false);

        Int16 I;

        //Add User Login Locations using GUID and selected locations 
        for (I = 0; I <= lbLoginLocations.Items.Count - 1; I++)
        {
            if (I == 0)
            {
                strSQL = "Insert into dbIntranet.dbo.UserLoginHomeLocation (UserLoginId, LocationId) " +
                 "Values ('" + g + "', " + lbLoginLocations.Items[I].Value + ")";

                insertUser.updateOrInsert(strSQL, false);
            }

            strSQL = "Insert into dbIntranet.dbo.UserLoginLocations (UserId, Location, LocationId, IsPrimary) " +
                 "Values ('" + g + "', '000', " + lbLoginLocations.Items[I].Value + ", NULL)";

            insertUser.updateOrInsert(strSQL, false);
        }

        //Add User Login Vehicle Locations using GUID and selected locations 
        for (I = 0; I <= lbVehicleLocations.Items.Count - 1; I++)
        {
            strSQL = "Insert into Vehicles.dbo.UserVehicleLocations (UserId, LocationId) " +
                 "Values ('" + g + "', " + lbVehicleLocations.Items[I].Value + ")";

            insertUser.updateOrInsert(strSQL, false);
        }

        //Add to managers reports
        if (AuditReport.Checked == true)
        {
            strSQL = "Insert into dbIntranet.dbo.UserLoginAuditInclusion (UserId) " +
                "Values ('" + g + "')";

            insertUser.updateOrInsert(strSQL, false);
        }


        //iterate through roles table and get checkboxes.  The checkboxes IDs are the roles ID.  Insert the roles for the user
        foreach (TableRow row in Table1.Rows)
        {
            foreach (TableCell cell in row.Cells)
            {
                foreach (CheckBox cb in cell.Controls.OfType<CheckBox>())
                {
                    if (cb.Checked == true)
                    {
                        strSQL = "Insert into aspnetdb.dbo.aspnet_UsersInRoles (UserId, RoleId) " +
                                                                       "Values ('" + g + "', '" + cb.ID + "')";
                        insertUser.updateOrInsert(strSQL, false);
                    }
                }
            }
        }

        //Create the Rep record if needed
        if (createRepRecord.Checked == true)
        {
            var thisFirstName = txtFirstName.Text;
            var thisLastName = txtLastName.Text;
            var thisHireDate = txtHireDate.Text;
            var thisTerritoryAbreviation = txtTerritory.Text;
            var thisRepId = txtRepId.Text;
            var thisMarketingCode1st4 = txtMarketingCode1st4.Text;
            var thisStreetAddress = txtStreetAddress.Text;
            var thisCity = txtCity.Text;
            var thisState = txtState.Text;
            var thisZip = txtZip.Text;
            var thisPhone = txtPhone.Text;
            var thisTitle = txtTitle.Text;
            var thisMailerId = txtMailerId.Text;
            var thisLastAssigned = txtPhotoURL.Text;
            var thisIsManager = 0;
            if (IsManager.Checked == true)
            {
                thisIsManager = 1;
            }
            var thisIsPrimary = 0;
            if (IsPrimary.Checked == true)
            {
                thisIsPrimary = 1;
            }
            var thisRegion = getNewRegion();


            strSQL = "INSERT INTO MarketingReps " +
                    "([LastName],[FirstName],[Location],[EmailAddress],[HireDate],[RehireDate],[TerminationDate1]" +
                    ",[TerminationDate2],[BIUserID],[RepID],[TerritoryAbbreviation],[UserId],[Manager],[RepMailerId]" +
                    ",[DefaultLocationId],[StreetAddress],[City],[State],[Zip],[RepPhone],[Title]" +
                    ",[RecordType],[Rep],[Region],[CarDayMonthlyGoal],[CarDayYearlyGoal],[SignupMonthlyGoal]" +
                    ",[SignupYearlyGoal],[RepPhotoURL],[LocationId],[IsPrimary],[Admin],[CreateDatetime]" +
                    ",[CreateUserId],[UpdateDatetime],[UpdateUserId],[IsDeleted],[CreateExternalUserData],[UpdateExternalUserData]) " +
                    "VALUES " +
                    "('" + thisLastName + "', '" + thisFirstName + "', '000', '" + email.Text + "', '" + thisHireDate + "', NULL, NULL, " +
                    "NULL, NULL, '" + thisRepId + "', '" + thisTerritoryAbreviation + "', '" + g + "', " + thisIsManager + ", '" + thisMailerId + "', " +
                    lbLoginLocations.Items[0].Value + ", '" + thisStreetAddress + "', '" + thisCity + "', '" + thisState + "', '" + thisZip + "', '" + thisPhone + "', '" + thisTitle + "', " +
                    "NULL, 1, '" + thisRegion + "', NULL, NULL, NULL, " +
                    "NULL, '" + thisLastAssigned + "', " + lbLoginLocations.Items[0].Value + ", " + thisIsPrimary + ", 0, '" + DateTime.Now + "', " +
                    "1, NULL, NULL, 0, NULL, NULL)";

            insertUser.updateOrInsert(strSQL, true);


            //Insert the Marketing Codes into the Marketing Code table, there are 4
            strSQL = "Insert into MarketingCode (MarketingCode, StartDate, Active, RepID, BIUserID, Notes, ShortNotes, CreateDateTime, CreateUserId, UpdateDateTime, UpdateUserId, IsDeleted, CreateExternalUserData, UpdateExternalUserData) " +
                                        "Values ('" + thisMarketingCode1st4 + "207', '" + thisHireDate + "', 1, '" + thisRepId + "', NULL, '" + thisLastName + "' + ' ' + '" + thisFirstName + "', '" + thisLastName + "' + ' ' + '" + thisFirstName + "', '" + DateTime.Now + "', 1, NULL, NULL, 0, NULL, NULL)";
            insertUser.updateOrInsert(strSQL, true);

            strSQL = "Insert into MarketingCode (MarketingCode, StartDate, Active, RepID, BIUserID, Notes, ShortNotes, CreateDateTime, CreateUserId, UpdateDateTime, UpdateUserId, IsDeleted, CreateExternalUserData, UpdateExternalUserData) " +
                                        "Values ('" + thisMarketingCode1st4 + "M00', '" + thisHireDate + "', 1, '" + thisRepId + "', NULL, '" + thisLastName + "' + ' ' + '" + thisFirstName + "', '" + thisLastName + "' + ' ' + '" + thisFirstName + "', '" + DateTime.Now + "', 1, NULL, NULL, 0, NULL, NULL)";
            insertUser.updateOrInsert(strSQL, true);

            strSQL = "Insert into MarketingCode (MarketingCode, StartDate, Active, RepID, BIUserID, Notes, ShortNotes, CreateDateTime, CreateUserId, UpdateDateTime, UpdateUserId, IsDeleted, CreateExternalUserData, UpdateExternalUserData) " +
                                        "Values ('" + thisMarketingCode1st4 + "A00', '" + thisHireDate + "', 1, '" + thisRepId + "', NULL, '" + thisLastName + "' + ' ' + '" + thisFirstName + "', '" + thisLastName + "' + ' ' + '" + thisFirstName + "', '" + DateTime.Now + "', 1, NULL, NULL, 0, NULL, NULL)";
            insertUser.updateOrInsert(strSQL, true);

            strSQL = "Insert into MarketingCode (MarketingCode, StartDate, Active, RepID, BIUserID, Notes, ShortNotes, CreateDateTime, CreateUserId, UpdateDateTime, UpdateUserId, IsDeleted, CreateExternalUserData, UpdateExternalUserData) " + 
                                        "Values ('" + thisMarketingCode1st4 + "D00', '" + thisHireDate + "', 1, '" + thisRepId + "', NULL, '" + thisLastName + "' + ' ' + '" + thisFirstName + "', '" + thisLastName + "' + ' ' + '" + thisFirstName + "', '" + DateTime.Now + "', 1, NULL, NULL, 0, NULL, NULL)";
            insertUser.updateOrInsert(strSQL, true);

            //Add viewable locations 
            for (I = 0; I <= lbLoginLocations.Items.Count - 1; I++)
            {
                strSQL = "Insert into MarketingRepViewableLocations (ID, Location, RepLocationTerritory, LocationId, CreateDatetime, CreateUserId, UpdateDatetime, UpdateUserId, IsDeleted, CreateExternalUserData, UpdateExternalUserData) " +
                     "Values ('" + thisRepId + "', '000', NULL, " + lbLoginLocations.Items[I].Value + ", '" + DateTime.Now + "', 1, NULL, NULL, 0, NULL, NULL)";

                insertUser.updateOrInsert(strSQL, true);
            }
        }

    }

    protected void GetLocations()
    {
        Int16 I;

        //Get all locations
        string strSQL = null;
        strSQL = "Select LocationId, ShortLocationName from LocationDetails";

        clsADO thisADO = new clsADO();
        List<clsADO.sql2DObject> thisList;
        thisList = thisADO.return2DListLocal(strSQL);

        //add first selection
        ddlLoginLocations.Items.Add("Pick a Location");

        //add locations to the dropdown list
        for (I = 0; I <= thisList.Count - 1; I++)
        {
            ListItem test = new ListItem { Text = thisList[I].two.ToString(), Value = thisList[I].one.ToString() };
            ddlLoginLocations.Items.Add(test);
        }
    }

    protected void GetVehicleLocations()
    {
        Int16 I;

        //Get all locations
        string strSQL = null;
        strSQL = "Select LocationId, NameOfLocation from Vehicles.dbo.Location order by NameOfLocation";

        clsADO thisADO = new clsADO();
        List<clsADO.sql2DObject> thisList;
        thisList = thisADO.return2DListLocal(strSQL);

        //add first selection
        ddlVehicleLocations.Items.Add("Pick a Location");

        //add locations to the dropdown list
        for (I = 0; I <= thisList.Count - 1; I++)
        {
            ListItem test = new ListItem { Text = thisList[I].two.ToString(), Value = thisList[I].one.ToString() };
            ddlVehicleLocations.Items.Add(test);
        }
    }

    protected void GetUsedRepIds()
    {
        Int16 I;

        //Get all locations
        string strSQL = null;
        strSQL = "Select RepID from MarketingReps order by RepId desc";

        clsADO thisADO = new clsADO();
        List<clsADO.sql2DObject> thisList;
        thisList = thisADO.return2DListLocal(strSQL, true);

        //add first selection
        UsedRepId.Items.Add("Used RepIds");

        //add locations to the dropdown list
        for (I = 0; I <= thisList.Count - 1; I++)
        {
            ListItem test = new ListItem { Text = thisList[I].one.ToString(), Value = thisList[I].two.ToString() };
            UsedRepId.Items.Add(test);
        }
    }

    protected void GetUsedRepMailerIds()
    {
        Int16 I;

        //Get all locations
        string strSQL = null;
        strSQL = "select RepMailerId from MarketingReps group by RepMailerId order by RepMailerId";

        clsADO thisADO = new clsADO();
        List<clsADO.sql2DObject> thisList;
        thisList = thisADO.return2DListLocal(strSQL, true);

        //add first selection
        ddlRepMailerId.Items.Add("Used RepMailerIds");

        //add locations to the dropdown list
        for (I = 0; I <= thisList.Count - 1; I++)
        {
            ListItem test = new ListItem { Text = thisList[I].one.ToString(), Value = thisList[I].two.ToString() };
            ddlRepMailerId.Items.Add(test);
        }
    }

    protected void ddlLoginLocations_SelectedIndexChanged(object sender, EventArgs e)
    {
        //add login location to list and select first one so validator knows something is in list
        ListItem test = new ListItem { Text = ddlLoginLocations.SelectedItem.ToString(), Value = ddlLoginLocations.SelectedItem.Value };
        lbLoginLocations.Items.Add(test);
        lbLoginLocations.SelectedIndex = 0;
    }

    protected void ddlVehicleLocations_SelectedIndexChanged(object sender, EventArgs e)
    {
        //add login location to list and select first one so validator knows something is in list
        ListItem test = new ListItem { Text = ddlVehicleLocations.SelectedItem.ToString(), Value = ddlVehicleLocations.SelectedItem.Value };
        lbVehicleLocations.Items.Add(test);
        lbVehicleLocations.SelectedIndex = 0;
    }

    



    protected void Reset_Click(object sender, EventArgs e)
    {
        //get all textboxes on page
        var textBoxList = (Page.Master.FindControl("MainContent") as ContentPlaceHolder).Controls.OfType<TextBox>();

        //clear each textbox
        foreach (TextBox tb in textBoxList)
        {
            tb.Text = "";
        }

        //iterate through tablw with role checkboxes and uncheck.
        foreach (TableRow row in Table1.Rows)
        {
            foreach (TableCell cell in row.Cells)
            {
                foreach (CheckBox cb in cell.Controls.OfType<CheckBox>())
                {
                    cb.Checked = false;
                }
            }
        }

        //Clear the location list box and set the drow down selection to "pick a location" which is index 0
        lbLoginLocations.Items.Clear();
        ddlLoginLocations.SelectedIndex = 0;

        //Clear the vehicle location list box and set the drow down selection to "pick a location" which is index 0
        lbVehicleLocations.Items.Clear();
        ddlVehicleLocations.SelectedIndex = 0;
    }

    protected void AddRoles()
    {
        //Get the roles we want to display checkboxes for
        string strSQL = null;
        strSQL = "Select RoleName, RoleId from aspnetdb.dbo.aspnet_roles";
        //strSQL = "Select RoleName, RoleId from aspnetdb.dbo.aspnet_roles where (RoleName like '%Vehicle%' or RoleName = 'Insurance' or RoleName = 'Uniforms')";

        clsADO thisADO = new clsADO();
        List<clsADO.sql2DObject> thisList;
        thisList = thisADO.return2DListLocal(strSQL);

        //We are going to populate a table with the checkboxes Y counts through rows and I through colums
        int I;
        int Y;
        //This sets how many columns we want
        int colCount = 5;

        //number of roles we got from the select
        int roleCount = thisList.Count;

        //Get the number of Rows we need for the roles table
        int numberOfRows = Convert.ToInt16(Math.Ceiling(Convert.ToDouble(roleCount) / Convert.ToDouble(colCount)));

        //Start counting rows
        for (Y = 0; Y <= numberOfRows; Y++)
        {
            TableRow row = new TableRow();

            //If the total number of columns (adding all columns in each row 2 rows 5 columns is 10) is less than the number of roles use the running column count
            //as the new for loop top end and the I counter as 5 minus the new top end
            if (colCount < roleCount)
            {
                for (I = colCount - 5; I <= colCount - 1; I++)
                {
                    CheckBox chk = new CheckBox();
                    TableCell cell1 = new TableCell();
                    Label lbl = new Label();

                    chk.ID = thisList[I].two.ToString();
                    chk.AutoPostBack = false;
                    //chk.Text = thisList[I].one.ToString();
                    lbl.Text = thisList[I].one.ToString();
                    chk.Width = 50;
                    cell1.Controls.Add(lbl);
                    cell1.Controls.Add(chk);
                    cell1.CssClass = "centerText";
                    row.Cells.Add(cell1);

                }
            }
            else if (colCount >= roleCount) // if colcount is more than or equal to the number of roles then we are done. subtract 5 from colucount to get the counter and set the top end to roleCount
            {
                for (I = colCount - 5; I <= roleCount - 1; I++)
                {
                    CheckBox chk = new CheckBox();
                    TableCell cell1 = new TableCell();
                    Label lbl = new Label();

                    chk.ID = thisList[I].two.ToString();
                    chk.AutoPostBack = false;
                    //chk.Text = thisList[I].one.ToString();
                    lbl.Text = thisList[I].one.ToString();
                    chk.Width = 50;
                    cell1.Controls.Add(lbl);
                    cell1.Controls.Add(chk);
                    cell1.CssClass = "centerText";
                    row.Cells.Add(cell1);
                }
            }

            //advance the total column count
            colCount = colCount + 5;
            //add new row to table
            Table1.Rows.Add(row);
        }
        CheckBoxChk();
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

    public string getNewRegion()
    {
        string NewRegion = "";
        string RegionCharacter = "";
        Boolean IsManager = false;
        Boolean IsMarketingManager = false;

        //iterate through tablw with role checkboxes and uncheck.
        foreach (TableRow row in Table1.Rows)
        {
            foreach (TableCell cell in row.Cells)
            {
                foreach (CheckBox cb in cell.Controls.OfType<CheckBox>())
                {
                    foreach (Label lb in cell.Controls.OfType<Label>())
                    {
                        if ((lb.Text == "Supervisor/AssistantManager" || lb.Text == "Manager") && cb.Checked == true)
                        {
                            IsManager = true;
                        }
                        if (lb.Text == "MarketingManagement" && cb.Checked == true)
                        {
                            IsMarketingManager = true;
                        }
                    }
                }
            }
        }

        if (IsManager == true | IsMarketingManager == true)
        {
            if (IsMarketingManager == true)
            {
                RegionCharacter = "C";
            }
            else
            {
                RegionCharacter = "M";
            }

            clsADO thisADO = new clsADO();
            int i = 1;

            while (i < 1000)
            {
                string CheckRegion = "Select ID from MarketingReps where Region = '" + RegionCharacter + i.ToString().PadLeft(2, '0') + "'";
                
                string conn = thisADO.getMaxConnectionString();

                using (SqlConnection con = new SqlConnection(conn))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = CheckRegion;
                        cmd.Connection = con;
                        con.Open();
                        using (SqlDataReader sdr = cmd.ExecuteReader())
                        {
                            if (sdr.HasRows == false)
                            { 
                                NewRegion = RegionCharacter + i.ToString().PadRight(2, '0');
                                return NewRegion;
                            }
                        }
                        i += 1;
                        con.Close();
                    }
                }
            }
        }
       
        return "";
    }

    private void CheckBoxChk()
    {
        string allTextBoxValues = "";
        foreach (Control c in Page.Controls)
        {
            foreach (Control childc in c.Controls)
            {
                if (childc is CheckBox)
                {
                    ((CheckBox)childc).Checked = true;
                }
            }
        }
        if (allTextBoxValues != "")
        {

        }
    }
}