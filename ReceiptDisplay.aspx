<%@ Page Title="" Language="C#" MasterPageFile="Portal2Empty.master" AutoEventWireup="true" CodeFile="ReceiptDisplay.aspx.cs" Inherits="ReceiptDisplay" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <link rel="stylesheet" href="/jqwidgets/styles/jqx.base.css" type="text/css" />

    <script type="text/javascript" src="jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="jqwidgets/globalization/globalize.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxbuttons.js"></script>


    <script type="text/javascript">

        $(document).ready(function () {

            $("#email").jqxButton({ width: 180, height: 25 });

            var thisMemberId = getUrlParameter('MemberId');
            var thisLocationId = getUrlParameter('LocationId');
            var thisParkingTransactionNumber = getUrlParameter('ParkingTransactionNumber');
            var thisToAddress = getUrlParameter('EmailAddress');

            getReceiptData(thisMemberId, thisLocationId, thisParkingTransactionNumber);

            $("#email").on("click", function (event) {
                html2canvas($("#receipt"), {
                    onrendered: function (canvas) {
                        theCanvas = canvas;
                        //document.body.appendChild(canvas);

                        var image = canvas.toDataURL("image/png");

                        image = image.replace('data:image/png;base64,', '');

                        PageMethods.sendReceipt(image, thisParkingTransactionNumber, thisToAddress, DisplayPageMethodResults);
                        function onSucess(result) {
                            alert(result);
                        }
                        function onError(result) {
                            alert('Error Submitting Receipt: ' + result);
                        }
                    }
                });
            });
        })

        function getUrlParameter(name) {
            name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
            var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
            var results = regex.exec(location.search);
            return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
        };

        function getReceiptData(thisMemberId, thisLocationId, thisParkingTransactionNumber)
        {

            var url = $("#apiDomain").val() + "members/" + thisMemberId + "/print-receipt";

            $.ajax({
                headers: {
                    "Accept": "application/json",
                    "Content-Type": "application/json",
                    "AccessToken": $("#userGuid").val(),
                    "ApplicationKey": $("#AK").val()
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
                    alert(error + " - " + request.responseJSON.message);
                }
            })
        }
    </script>

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
						<div id="receiptDateInfo" style="text-align:center;font-weight:bold;"></div>
					</td>
				</tr>
				<tr>
					<td colspan='2'>
						<div id="locationInfo"style="text-align:center;font-weight:bold;"></div>
					</td>
				</tr>
				<tr>
					<td colspan='2'>
						<br/><div id="addressInfo"style="text-align:center;font-weight:bold;"></div>
					</td>
				</tr>
				<tr>
					<td colspan='2'>
						<div id="cityZipInfo"style="text-align:center;font-weight:bold;"></div>
					</td>
				</tr>
				<tr>
					<td colspan='2'>
						<div id="telephoneInfo"style="text-align:center;font-weight:bold;"></div>
					</td>
				</tr>
				<tr>
					<td colspan='2'>
						<br/>Account Status:
					</td>
				</tr>
				<tr>
					<td colspan='2'>
						<div id="accountStatusInfo"></div><br/>
					</td>
				</tr>
				<tr>
					<td colspan='2'>
						<div id="entryDateInfo"></div>
					</td>
				</tr>
				<tr>
					<td colspan='2'>
						<div id="exitDateInfo"></div>
					</td>
				</tr>
				<tr>
					<td><br/>
						Period:
					</td>
					<td>
						<br/><div id="periodInfo"></div>
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
						<div id="amountDueInfo"></div>
					</td>
				</tr>
				<tr>
					<td>
						Credits/Discounts:
					</td>
					<td>
						<div id="creditsInfo"></div>
					</td>
				</tr>
				<tr>
					<td>
						<br/>Net Due:
					</td>
					<td>
						<br/><div id="netInfo"></div>
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
						<div id="paymentInfoAmtInfo"></div>
					</td>
				</tr>
				<tr>
					<td colspan='2'>
						<div id="receiptDateInfo2"></div>
					</td>
				</tr>
                <tr>
					<td colspan='2'>
						<div style="margin-top:10px;">* Gross Amount Includes all applicable taxes and airport fees</div>
					</td>
				</tr>
			</table>
		</div>
    </div>
    <div style="margin-top:15px;"><input id="email" value="Send" /></div>
    <div id="img-out" style="display:none"></div>
</asp:Content>

