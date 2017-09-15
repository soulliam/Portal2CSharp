using System;
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
        for (I = 0; I <= ListBox1.Items.Count - 1; I++)
        {
            if (I == 0)
            {
                strSQL = "Insert into dbIntranet.dbo.UserLoginHomeLocation (UserId, LocationId) " +
                 "Values ('" + g + "', " + ListBox1.Items[I].Value + ")";

                insertUser.updateOrInsert(strSQL, false);
            }

            strSQL = "Insert into dbIntranet.dbo.UserLoginLocations (UserId, Location, LocationId, IsPrimary) " +
                 "Values ('" + g + "', '000', " + ListBox1.Items[I].Value + ", NULL)";

            insertUser.updateOrInsert(strSQL, false);
        }

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
        DropDownList1.Items.Add("Pick a Location");

        //add locations to the dropdown list
        for (I = 0; I <= thisList.Count - 1; I++)
        {
            ListItem test = new ListItem { Text = thisList[I].two.ToString(), Value = thisList[I].one.ToString() };
            DropDownList1.Items.Add(test);
        }
    }

    protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        //add login location to list and select first one so validator knows something is in list
        ListItem test = new ListItem { Text = DropDownList1.SelectedItem.ToString(), Value = DropDownList1.SelectedItem.Value };
        ListBox1.Items.Add(test);
        ListBox1.SelectedIndex = 0;
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
        ListBox1.Items.Clear();
        DropDownList1.SelectedIndex = 0;
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
}