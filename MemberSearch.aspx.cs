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
using class_Logging;
using class_ADO;

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
    public static string SubmitReceipt1(DateTime entryDate, string Receipt, string Column, string SubmittedBy, Int64 LocationId, Int64 MemberId, string thisGuid)
    {
        try
        {
            class_ADO.clsADO thisADO = new class_ADO.clsADO();

            SqlConnection cn = new SqlConnection(thisADO.getMaxConnectionString());

            cn.Open();
            SqlCommand cmd = new SqlCommand("dbo.GetCreditForReceiptPCA");
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Connection = cn;

            SqlParameter thisEntryDate = cmd.Parameters.Add(new SqlParameter("@iEntryDate", SqlDbType.Date));
            SqlParameter thisReceiptNumber = cmd.Parameters.Add(new SqlParameter("@iReceiptNumber", SqlDbType.NVarChar, 20));
            SqlParameter thisColumnNumber = cmd.Parameters.Add(new SqlParameter("@iColumnNumber", SqlDbType.NVarChar, 20));
            SqlParameter thisShortTermNumber = cmd.Parameters.Add(new SqlParameter("@iShortTermNumber", SqlDbType.NVarChar, 20));
            SqlParameter thisLocationId = cmd.Parameters.Add(new SqlParameter("@iLocationId", SqlDbType.Int));
            SqlParameter thisMemberId = cmd.Parameters.Add(new SqlParameter("@iMemberId", SqlDbType.BigInt));
            SqlParameter thisUserId = cmd.Parameters.Add(new SqlParameter("@iUserId", SqlDbType.NVarChar, 100));
            
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
            thisLocationId.Value = LocationId;
            thisMemberId.Value = MemberId;
            thisUserId.Value = SubmittedBy;

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
    public static string SubmitReceipt2(Int64 MemberId, DateTime entryDate, DateTime exitDate, string AmountPaid, Int64 LocationId, string SubmittedBy, string thisGuid)
    {
        try
        {

            class_ADO.clsADO thisADO = new class_ADO.clsADO();

            SqlConnection cn = new SqlConnection(thisADO.getMaxConnectionString());

            cn.Open();
            SqlCommand cmd = new SqlCommand("dbo.GetReceiptCreditPCA");
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Connection = cn;

            SqlParameter thisMemberId = cmd.Parameters.Add(new SqlParameter("@iMemberId", SqlDbType.BigInt));
            SqlParameter thisEntryDate = cmd.Parameters.Add(new SqlParameter("@iEntryDate", SqlDbType.DateTime));
            SqlParameter thisExitDate = cmd.Parameters.Add(new SqlParameter("@iExitDate", SqlDbType.DateTime));
            SqlParameter thisAmountPaid = cmd.Parameters.Add(new SqlParameter("@iAmountPaid", SqlDbType.Float));
            SqlParameter thisLocationId = cmd.Parameters.Add(new SqlParameter("@iLocationId", SqlDbType.Int));
            SqlParameter thisUserId = cmd.Parameters.Add(new SqlParameter("@iUserId", SqlDbType.NVarChar, 100));

            thisMemberId.Value = MemberId;
            thisEntryDate.Value = entryDate;
            thisExitDate.Value = exitDate;
            thisAmountPaid.Value = AmountPaid;
            thisLocationId.Value = LocationId;
            thisUserId.Value = SubmittedBy;

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
    public static string combineCards(string sourceCard, string targetCard, string submittedBy)
    {
        try
        {

            class_ADO.clsADO thisADO = new class_ADO.clsADO();

            SqlConnection cn = new SqlConnection(thisADO.getLocalConnectionString());

            cn.Open();
            SqlCommand cmd = new SqlCommand("dbo.CombineCards");
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Connection = cn;

            SqlParameter thisSourceCard = cmd.Parameters.Add(new SqlParameter("@sourceCard", SqlDbType.NVarChar));
            SqlParameter thisTargetCard = cmd.Parameters.Add(new SqlParameter("@targetCard", SqlDbType.NVarChar));
            SqlParameter thisSubmittedBy = cmd.Parameters.Add(new SqlParameter("@submittedBy", SqlDbType.NVarChar));

            thisSourceCard.Value = sourceCard;
            thisTargetCard.Value = targetCard;
            thisSubmittedBy.Value = submittedBy;

            using (SqlDataReader sdr = cmd.ExecuteReader())
            {
                while (sdr.Read())
                {
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
    public static string LogMemberUpdate(string thisUserName, string thisMemberId, string thisOld, string thisNew)
    {
        try
        {
            clsLogging LogMemberUpdate = new clsLogging();

            LogMemberUpdate.logChange(thisUserName, thisMemberId, thisOld, thisNew, "MemberInformation", "Member Information Updated", -1);
            return "Request Made";
        }
        catch (Exception ex)
        {
            return Convert.ToString(ex);
        }
    }

    [System.Web.Services.WebMethod]
    public static string logCertificate(string thisUserName, string thisMemberId, string NumberOfRedemption, string RedemptionTypeID)
    {
        try
        {
            clsADO getRedemptionType = new clsADO();

            string strRedemptionType = Convert.ToString(getRedemptionType.returnSingleValue("select RedemptionTypeName from RedemptionTypes where RedemptionTypeId =  " + RedemptionTypeID, true));

            clsLogging logSearch = new clsLogging();

            logSearch.logChange(thisUserName, thisMemberId, NumberOfRedemption, strRedemptionType, "", "Portal Certificate", logSearch.getBatch());

            return "";
        }
        catch (Exception ex)
        {
            return Convert.ToString(ex);
        }
    }

    [System.Web.Services.WebMethod]
    public static string logRedemptionReturnstring (string thisUserName, string thisRedemptionId, string thisCertificateId, string thisMemberId)
    {
        try
        {

            clsLogging logSearch = new clsLogging();

            logSearch.logChange(thisUserName, thisMemberId, thisRedemptionId, thisCertificateId, "", "Redemption Return", logSearch.getBatch());

            return "Sucsses";
        }
        catch (Exception ex)
        {
            return Convert.ToString(ex);
        }
    }
}