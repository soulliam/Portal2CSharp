using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Drawing;
using QRCoder;
using class_ADO;
using System.Data.SqlClient;

public partial class ReturnedRedemptions : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        AddRedemptions();
    }

    protected void AddRedemptions()
    {
        //Get the returned redemptions to display
        string strSQL = null;
        strSQL = "Select mc.FPNumber, mi.FirstName, mi.Lastname, r.QrCodeString, r.RedemptionId, " +
                 "Case when l.locationId in (1, 11) then dateadd(hour, dbo.GetUTCOffSet(r.CancellationRequestProcessedDatetime, -7), r.CancellationRequestProcessedDatetime) " +
                 "when l.LocationId in (2, 15, 16, 20) then dateadd(hour, dbo.GetUTCOffSet(r.CancellationRequestProcessedDatetime, -6), r.CancellationRequestProcessedDatetime) " +
                 "else dateadd(hour, dbo.GetUTCOffSet(r.CancellationRequestProcessedDatetime, -5), r.CancellationRequestProcessedDatetime) end as ReturnDate " +
                 "from Redemptions r " +
                 "Left Outer JOIN ValidationTransactions vt ON 'RFR\' + r.CertificateID = vt.KeySerialNumber " +
                 "Left Outer Join MemberCard mc on r.MemberId = mc.MemberId " +
                 "Left Outer Join MemberInformationMain mi on r.MemberId = mi.MemberId " +
                 "Left Outer Join MemberHasLocation mhl on mi.MemberId = mhl.MemberId " +
                 "Left Outer Join LocationDetails l on mhl.LocationId = l.LocationId " +
                 "where Convert(nvarchar, CancellationRequestProcessedDatetime, 101) = '12/12/2017' " +
                 "And mc.IsPrimary = 1 " +
                 "And mhl.UpdateDatetime is null";

        clsADO thisADO = new clsADO();

        string conn = thisADO.getMaxConnectionString();

        using (SqlConnection con = new SqlConnection(conn))
        {
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = strSQL;
                cmd.Connection = con;
                con.Open();
                using (SqlDataReader sdr = cmd.ExecuteReader())
                {
                    TableRow HeaderRow = new TableRow();

                    TableCell HeaderCell0 = new TableCell();
                    HeaderCell0.Text = "FPNumber";
                    HeaderCell0.CssClass = "centerText";
                    HeaderRow.Cells.Add(HeaderCell0);
                    TableCell HeaderCell1 = new TableCell();
                    HeaderCell1.Text = "First Name";
                    HeaderCell1.CssClass = "centerText";
                    HeaderRow.Cells.Add(HeaderCell1);
                    TableCell HeaderCell2 = new TableCell();
                    HeaderCell2.Text = "Last Name";
                    HeaderCell2.CssClass = "centerText";
                    HeaderRow.Cells.Add(HeaderCell2);
                    TableCell HeaderCell3 = new TableCell();
                    HeaderCell3.Text = "QR Code String";
                    HeaderCell3.CssClass = "centerText";
                    HeaderRow.Cells.Add(HeaderCell3);
                    TableCell HeaderCell4 = new TableCell();
                    HeaderCell4.Text = "Redemption ID";
                    HeaderCell4.CssClass = "centerText";
                    HeaderRow.Cells.Add(HeaderCell4);
                    TableCell HeaderCell5 = new TableCell();
                    HeaderCell5.Text = "Date Returned";
                    HeaderCell5.CssClass = "centerText";
                    HeaderRow.Cells.Add(HeaderCell5);
                    TableCell HeaderCell6 = new TableCell();
                    HeaderCell6.Text = "QR";
                    HeaderCell6.CssClass = "centerText";
                    HeaderRow.Cells.Add(HeaderCell6);

                    Table1.Rows.Add(HeaderRow);

                    if (sdr.HasRows != false)
                    {
                        while (sdr.Read())
                        {
                            TableRow row = new TableRow();

                            TableCell cell1 = new TableCell();
                            Label lbl1 = new Label();

                            lbl1.Text = sdr[0].ToString();
                            cell1.Controls.Add(lbl1);
                            cell1.CssClass = "centerText";
                            row.Cells.Add(cell1);

                            TableCell cell2 = new TableCell();
                            Label lbl2 = new Label();

                            lbl2.Text = sdr[1].ToString();
                            cell2.Controls.Add(lbl2);
                            cell2.CssClass = "centerText";
                            row.Cells.Add(cell2);

                            TableCell cell3 = new TableCell();
                            Label lbl3 = new Label();

                            lbl3.Text = sdr[2].ToString();
                            cell3.Controls.Add(lbl3);
                            cell3.CssClass = "centerText";
                            row.Cells.Add(cell3);

                            TableCell cell4 = new TableCell();
                            Label lbl4 = new Label();

                            lbl4.Text = sdr[3].ToString();
                            cell4.Controls.Add(lbl4);
                            cell4.CssClass = "centerText";
                            row.Cells.Add(cell4);

                            TableCell cell5 = new TableCell();
                            Label lbl5 = new Label();

                            lbl5.Text = sdr[4].ToString();
                            cell5.Controls.Add(lbl5);
                            cell5.CssClass = "centerText";
                            row.Cells.Add(cell5);

                            TableCell cell6 = new TableCell();
                            Label lbl6 = new Label();

                            lbl6.Text = sdr[5].ToString();
                            cell6.Controls.Add(lbl6);
                            cell6.CssClass = "centerText";
                            row.Cells.Add(cell6);

                            TableCell cell7 = new TableCell();
                            PlaceHolder plHlder = new PlaceHolder();

                            QRCodeGenerator qrGenerator = new QRCodeGenerator();
                            QRCodeData qrCodeData = qrGenerator.CreateQrCode(sdr[3].ToString(), QRCodeGenerator.ECCLevel.Q);
                            QRCode qrCode = new QRCode(qrCodeData);

                            System.Web.UI.WebControls.Image imgBarCode = new System.Web.UI.WebControls.Image();
                            imgBarCode.Height = 150;
                            imgBarCode.Width = 150;


                            using (Bitmap bitMap = qrCode.GetGraphic(20))
                            {
                                using (MemoryStream ms = new MemoryStream())
                                {
                                    bitMap.Save(ms, System.Drawing.Imaging.ImageFormat.Png);
                                    byte[] byteImage = ms.ToArray();
                                    imgBarCode.ImageUrl = "data:image/png;base64," + Convert.ToBase64String(byteImage);
                                }

                                plHlder.Controls.Add(imgBarCode);
                                
                            }

                            cell7.Controls.Add(plHlder);
                            cell7.CssClass = "centerText";
                            row.Cells.Add(cell7);

                            Table1.Rows.Add(row);
                        }
                    }
                }
            }
        }
    }
}