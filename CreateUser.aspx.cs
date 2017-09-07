using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using class_ADO;
using System.Data.SqlClient;
using System.Web;

public partial class CreateUser : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            GetLocations();
        }

        AddRoles();
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        //Create new Guid
        Guid g;
        
        g = Guid.NewGuid();
        Console.WriteLine(g);

        //Pass username, guid, email and password to Create user stored procedure on aspnetdb 
        string strSQL = null;
        strSQL = "EXECUTE aspnetdb.dbo.CreateUser '" + userName.Text + "', '" + txtPassword.Text + "', '" + email.Text + "', '" + g + "'";

        clsADO insertUser = new clsADO();
        insertUser.updateOrInsert(strSQL, false);

        Int16 I;

        //Add User Login Locations using GUID and selected locations 
        for (I = 0; I <= ListBox1.Items.Count - 1; I++)
        {
            strSQL = "Insert into dbIntranet.dbo.UserLoginLocations (UserId, Location, LocationId, IsPrimary) " +
                 "Values ('" + g + "', '000', " + ListBox1.Items[I].Value + ", NULL)";

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

        DropDownList1.Items.Add("Pick a Location");

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
        var textBoxList = (Page.Master.FindControl("MainContent") as ContentPlaceHolder).Controls.OfType<TextBox>();

        foreach (TextBox tb in textBoxList)
        {
            tb.Text = "";
        }


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

        ListBox1.Items.Clear();
        DropDownList1.SelectedIndex = 0;
    }

    protected void AddRoles()
    {
        string strSQL = null;
        strSQL = "Select RoleName, RoleId from aspnetdb.dbo.aspnet_roles";

        clsADO thisADO = new clsADO();
        List<clsADO.sql2DObject> thisList;
        thisList = thisADO.return2DListLocal(strSQL);

        int I;
        int Y;
        int rowCount = 5;

        int Max = thisList.Count;

        for (Y = 0; Y <= 100; Y++)
        {
            TableRow row = new TableRow();

            if (rowCount < Max)
            {
                for (I = rowCount - 5; I <= rowCount - 1; I++)
                {
                    CheckBox chk = new CheckBox();
                    TableCell cell1 = new TableCell();
                    Label lbl = new Label();

                    chk.ID = thisList[I].two.ToString();
                    chk.AutoPostBack = true;
                    //chk.Text = thisList[I].one.ToString();
                    lbl.Text = thisList[I].one.ToString();
                    chk.Width = 50;
                    cell1.Controls.Add(lbl);
                    cell1.Controls.Add(chk);
                    cell1.CssClass = "centerText";
                    row.Cells.Add(cell1);

                }
            }
            else if (rowCount > Max)
            {
                for (I = rowCount - 5; I <= Max - 1; I++)
                {
                    CheckBox chk = new CheckBox();
                    TableCell cell1 = new TableCell();
                    Label lbl = new Label();

                    chk.ID = thisList[I].two.ToString();
                    chk.AutoPostBack = true;
                    //chk.Text = thisList[I].one.ToString();
                    lbl.Text = thisList[I].one.ToString();
                    chk.Width = 50;
                    cell1.Controls.Add(lbl);
                    cell1.Controls.Add(chk);
                    cell1.CssClass = "centerText";
                    row.Cells.Add(cell1);
                }
            }
            
            rowCount = rowCount + 5;

            Table1.Rows.Add(row);
        }
    }
}