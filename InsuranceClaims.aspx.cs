using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using class_ADO;

public partial class InsuranceClaims : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        clsADO thisADO = new clsADO();

        string SQL = "Select CredUserName, CredPassword from InsurancePCA.dbo.Cred";

        List<clsADO.sql2DObject> thisPassInfo = new List<clsADO.sql2DObject>();
        thisPassInfo = thisADO.return2DListLocal(SQL, false);

        //clsCrypt c = new clsCrypt();

        //string encrypt = clsCrypt.Encrypt("toencrypt");

        string deCryptPassword = clsCrypt.Decrypt(thisPassInfo[0].two.ToString());

        string deCryptUserName = clsCrypt.Decrypt(thisPassInfo[0].one.ToString());

        Console.Write(deCryptPassword + " " + deCryptUserName);
    }
}