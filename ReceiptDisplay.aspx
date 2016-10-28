<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ReceiptDisplay.aspx.cs" Inherits="ReceiptDisplay" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="scripts/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="scripts/bootstrap.min.js"></script>
    <script type="text/javascript" src="scripts/common.js"></script>

    <link rel="stylesheet" href="scripts/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="style.css" />

    <script type="text/javascript">
        $(document).ready(function () {
            getReceiptData(84, 3, "201412251146427200227867", "3FB37D989F114841AF79932D8FC0F0BE", "3E36B6D0-A79D-4A7D-B5F3-6C016DBF5580");
        })

        function getReceiptData(thisMemberId, thisLocationId, thisParkingTransactionNumber, AT, AK)
        {
            //var url = "http://api.stage.thefastpark.com:80/members/" + thisMemberId + "/print-receipt"
            var url = "http://api.stage.thefastpark.com:80/api/v1/members/84/print-receipt";

            $.ajax({
                headers: {
                    "Accept": "application/json",
                    "Content-Type": "application/json",
                    "AccessToken": AT,
                    "ApplicationKey": AK
                },
                type: "POST",
                url: url,
                data: JSON.stringify({
                    "LocationId": thisLocationId,
                    "ParkingTransactionNumber": thisParkingTransactionNumber
                }),
                dataType: "json",
                success: function (thisData) {
                    $("#receiptDateInfo").html(JsonDateTimeFormat(thisData.result.data.DateTimeOfExit));
                    $("#locationInfo").html(thisData.result.data.Brand);
                    $("#addressInfo").html(thisData.result.data.Address1);
                    $("#cityZipInfo").html(thisData.result.data.Address2);
                    $("#telephoneInfo").html(thisData.result.data.PhoneNumber);
                    $("#entryDateInfo").html(JsonDateTimeFormat(thisData.result.data.DateTimeOfEntry));
                    $("#exitDateInfo").html(JsonDateTimeFormat(thisData.result.data.DateTimeOfExit));
                    $("#periodInfo").html(thisData.result.data.Days + ' ' + thisData.result.data.hours + ' ' + thisData.result.data.Minutes);
                    var AmtDue = Number(thisData.result.data.GrossPay).toFixed(2);
                    $("#amountDueInfo").html(AmtDue);
                    var AmtCredit = Number(thisData.result.data.TotalReduction).toFixed(2);
                    $("#creditsInfo").html(AmtCredit);
                    var AmtPaid = Number(thisData.result.data.AmountPaid).toFixed(2);
                    $("#paymentInfoAmtInfo").html(AmtPaid);
                    var AmtNet = AmtDue - AmtCredit;
                    $("#netInfo").html(AmtNet.toFixed(2));
                    $("#receiptDateInfo2").html(JsonDateTimeFormat(thisData.result.data.DateTimeOfExit));
                },
                error: function (request, status, error) {
                    alert(request.responseText);
                }
            })
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <div id="receipt" >
			<div style='border:solid 1px black;width:185px;padding:2px;'>
				<table style='font-family:Tahoma; font-size:8pt; background-color: white;width:180px;padding:7px;'>
					<tr>
						<td colspan='2'>
							<div style="text-align:center;font-weight:bold;">Transaction Statement</div>
						</td>
					</tr>
					<tr>
						<td colspan='2'>
							<div id="receiptDateInfo" style="text-align:center;font-weight:bold;">09/17/2015 11:51 PM</div>
						</td>
					</tr>
					<tr>
						<td colspan='2'>
							<div id="locationInfo"style="text-align:center;font-weight:bold;">Austin FastPark</div>
						</td>
					</tr>
					<tr>
						<td colspan='2'>
							<br/><div id="addressInfo"style="text-align:center;font-weight:bold;">2300 Spirit of Texas Drive</div>
						</td>
					</tr>
					<tr>
						<td colspan='2'>
							<div id="cityZipInfo"style="text-align:center;font-weight:bold;">Austin, TX</div>
						</td>
					</tr>
					<tr>
						<td colspan='2'>
							<div id="telephoneInfo"style="text-align:center;font-weight:bold;">512-385-8877</div>
						</td>
					</tr>
					<tr>
						<td colspan='2'>
							<br/>Account Status:
						</td>
					</tr>
					<tr>
						<td colspan='2'>
							<div id="accountStatusInfo">Short Term Ticket</div><br/>
						</td>
					</tr>
					<tr>
						<td colspan='2'>
							<div id="entryDateInfo">09/16/2015 09:03 AM</div>
						</td>
					</tr>
					<tr>
						<td colspan='2'>
							<div id="exitDateInfo">09/17/2015 11:51 PM</div>
						</td>
					</tr>
					<tr>
						<td><br/>
							Period:
						</td>
						<td>
							<br/><div id="periodInfo">1d 14' 48"</div>
						</td>
					</tr>
					<tr>
						<td colspan='2'>
							Transaction Summary:
						</td>
					</tr>
					<tr>
						<td>
							Amount Due:
						</td>
						<td>
							<div id="amountDueInfo">$21.00</div>
						</td>
					</tr>
					<tr>
						<td>
							Credits/Discounts:
						</td>
						<td>
							<div id="creditsInfo">$0.00</div>
						</td>
					</tr>
					<tr>
						<td>
							<br/>Net Due:
						</td>
						<td>
							<br/><div id="netInfo">$21.00</div>
						</td>
					</tr>		   
					<tr>
						<td colspan='2'>
							Payment Information:
						</td>
					</tr>
					<tr>
						<td>
							<div id="paymentInfo">Payment</div>
						</td>
						<td>
							<div id="paymentInfoAmtInfo">$21.00</div>
						</td>
					</tr>
					<tr>
						<td colspan='2'>
							<div id="receiptDateInfo2">09/17/2015 11:51 PM</div>
						</td>
					</tr>
				</table>
			</div>
        </div>
    </div>
    </form>
</body>
</html>
