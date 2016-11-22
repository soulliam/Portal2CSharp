using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Web.Script.Services;
using System.Web.Script.Serialization;
using System.Text;
using System.Data;

public partial class MemberSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [System.Web.Services.WebMethod]
    public static string SendEmail(string ToAddress, string From, string Subject, string Body, bool IsHtml)
    {
        try
        {
            clsCommon thisEmail = new clsCommon();

            thisEmail.SendEmail(ToAddress, From, Subject, Body, IsHtml);

            return "Email Sent!";
        }
        catch (Exception ex)
        {
            return (Convert.ToString(ex));
        }
    }

    [System.Web.Services.WebMethod]
    public static string SubmitReceipt1(DateTime entryDate, string Receipt, string Column, string SubmittedBy, Int64 LocationId, Int64 MemberId)
    {
        try
        {
            class_ADO.clsADO thisADO = new class_ADO.clsADO();

            SqlConnection cn = new SqlConnection(thisADO.getMaxConnectionString());

            cn.Open();
            SqlCommand cmd = new SqlCommand("dbo.GetManagerCreditForReceipt");
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Connection = cn;

            SqlParameter thisEntryDate = cmd.Parameters.Add(new SqlParameter("@iEntryDate", SqlDbType.Date));
            SqlParameter thisReceiptNumber = cmd.Parameters.Add(new SqlParameter("@iReceiptNumber", SqlDbType.NVarChar, 20));
            SqlParameter thisColumnNumber = cmd.Parameters.Add(new SqlParameter("@iColumnNumber", SqlDbType.NVarChar, 20));
            SqlParameter thisShortTermNumber = cmd.Parameters.Add(new SqlParameter("@iShortTermNumber", SqlDbType.NVarChar, 20));
            SqlParameter thisUserId = cmd.Parameters.Add(new SqlParameter("@iUserId", SqlDbType.UniqueIdentifier));
            SqlParameter thisLocationId = cmd.Parameters.Add(new SqlParameter("@iLocationId", SqlDbType.Int));
            SqlParameter thisMemberId = cmd.Parameters.Add(new SqlParameter("@iMemberId", SqlDbType.BigInt));

            if (Column == "")
            {
                Column = null;
            }
            else
            {
                Receipt = null;
            }

            thisEntryDate.Value = entryDate;
            thisReceiptNumber.Value = Receipt;
            thisColumnNumber.Value = Column;
            thisShortTermNumber.Value = null;
            thisUserId.Value = Guid.Parse("BA1B0B96-30D3-45AB-815D-3527F72B6442");
            thisLocationId.Value = LocationId;
            thisMemberId.Value = MemberId;

            using (SqlDataReader sdr = cmd.ExecuteReader())
            {
                while (sdr.Read())
                {
                    Console.WriteLine(sdr["ErrorMessage"]);
                    return Convert.ToString(sdr["ErrorMessage"]);
                }
            }
            cn.Close();

            return "Error";
        }
        catch (Exception ex)
        {
            return ex.ToString();
        }

    }

    [System.Web.Services.WebMethod]
    public static string SubmitReceipt2(Int64 MemberId, DateTime entryDate, DateTime exitDate, string AmountPaid, Int64 LocationId, string SubmittedBy)
    {
        try
        {

            class_ADO.clsADO thisADO = new class_ADO.clsADO();

            SqlConnection cn = new SqlConnection(thisADO.getMaxConnectionString());

            cn.Open();
            SqlCommand cmd = new SqlCommand("dbo.GetReceiptCredit");
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Connection = cn;

            SqlParameter thisMemberId = cmd.Parameters.Add(new SqlParameter("@iMemberId", SqlDbType.BigInt));
            SqlParameter thisEntryDate = cmd.Parameters.Add(new SqlParameter("@iEntryDate", SqlDbType.DateTime));
            SqlParameter thisExitDate = cmd.Parameters.Add(new SqlParameter("@iExitDate", SqlDbType.DateTime));
            SqlParameter thisAmountPaid = cmd.Parameters.Add(new SqlParameter("@iAmountPaid", SqlDbType.Float));
            SqlParameter thisLocationId = cmd.Parameters.Add(new SqlParameter("@iLocationId", SqlDbType.Int));
            SqlParameter thisUserId = cmd.Parameters.Add(new SqlParameter("@iUserId", SqlDbType.UniqueIdentifier));

            thisMemberId.Value = MemberId;
            thisEntryDate.Value = entryDate;
            thisExitDate.Value = exitDate;
            thisAmountPaid.Value = AmountPaid;
            thisLocationId.Value = LocationId;
            thisUserId.Value = Guid.Parse("BA1B0B96-30D3-45AB-815D-3527F72B6442");

            using (SqlDataReader sdr = cmd.ExecuteReader())
            {
                while (sdr.Read())
                {
                    Console.WriteLine(sdr["ErrorMessage"]);
                    return Convert.ToString(sdr["ErrorMessage"]);
                }
            }

            cn.Close();

            return "Error";
        }
        catch (Exception ex)
        {
            return ex.ToString();
        }


    }



}