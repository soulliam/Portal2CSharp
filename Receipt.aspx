<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="Receipt.aspx.cs" Inherits="Receipt" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

		    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
		    <script type="text/javascript">
			    $( document ).ready(function() {
			      $('#receiptDate').text($('#receiptDateInfo').val());
			    });
		
			    $(function() {
				    $('#receiptDate').keyup(function() {
					    $('#receiptDateInfo').text($(this).val());
					    $('#receiptDateInfo2').text($(this).val());
				    });
			    });
			    $(function() {
				    $('#location').keyup(function() {
					    $('#locationInfo').text($(this).val());
				    });
			    });
			    $(function() {
				    $('#address').keyup(function() {
					    $('#addressInfo').text($(this).val());
				    });
			    });
			    $(function() {
				    $('#cityZip').keyup(function() {
					    $('#cityZipInfo').text($(this).val());
				    });
			    });
			    $(function() {
				    $('#telephone').keyup(function() {
					    $('#telephoneInfo').text($(this).val());
				    });
			    });
			    $(function() {
				    $('#accountStatus').keyup(function() {
					    $('#accountStatusInfo').text($(this).val());
				    });
			    });
			    $(function() {
				    $('#entryDate').keyup(function() {
					    $('#entryDateInfo').text($(this).val());
				    });
			    });
			    $(function() {
				    $('#exitDate').keyup(function() {
					    $('#exitDateInfo').text($(this).val());
				    });
			    });
			    $(function() {
				    $('#period').keyup(function() {
					    $('#periodInfo').text($(this).val());
				    });
			    });
			    $(function() {
				    $('#amountDue').keyup(function() {
					    $('#amountDueInfo').text($(this).val());
				    });
			    });
			    $(function() {
				    $('#credits').keyup(function() {
					    $('#creditsInfo').text($(this).val());
				    });
			    });
			    $(function() {
				    $('#net').keyup(function() {
					    $('#netInfo').text($(this).val());
				    });
			    });
			    $(function() {
				    $('#paymentInformation').keyup(function() {
					    $('#paymentInfo').text($(this).val());
				    });
			    });
			    $(function() {
				    $('#paymentInfoAmt').keyup(function() {
					    $('#paymentInfoAmtInfo').text($(this).val());
				    });
			    });

			    function printDiv() {
			        var printContents = document.getElementById("receipt").innerHTML;
			        var originalContents = document.body.innerHTML;
			        document.body.innerHTML = printContents;
			        window.print();
			        document.body.innerHTML = originalContents;
			    }


		        //$.post($("#localApiDomain").val() + "Emails/SendEmail",
		        //    { 'ToEmailAddress': 'mgoode@pca-star.com', 'FromEmailAddress': 'mgoode@pca-star.com', 'Body': 'Hello', 'Subject': 'GoodBye' },
		        //    function (data, status) {
		        //        switch (status) {
		        //            case 'success':
		        //                alert('Email Sent Successfully!');
		        //                break;
		        //            default:
		        //                alert('An Error occurred: ' + status + "\n Data:" + data);
		        //                break;
		        //        }
		        //    }
		        //);
		    </script>

		    <table>
			    <tr>
                    <td>
				        <br />
					    <input id="receiptDate"> Receipt Date <br />
					    <input id="location"> Location <br />
					    <input id="address"> Address <br />
					    <input id="cityZip"> City and Zip <br />
					    <input id="telephone"> Telephone <br />
					    <input id="accountStatus"> Account Status <br />
					    <input id="entryDate"> Entry Date <br />
					    <input id="exitDate"> Exit Date <br />
					    <input id="period"> Period <br />
					    <input id="amountDue"> Amount Due <br />
					    <input id="credits"> Credits <br />
					    <input id="net"> Net Due <br />
					    <input id="paymentInformation"> Payment Information <br />
					    <input id="paymentInfoAmt"> Payment Information Amount<br />
                        <br />
					    <input type='button' value='Print Receipt' onclick='printDiv();'/>
					    <br />
					    <br />
					    <br />
				    </td>

                    <td>
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
									        <div id="paymentInfo">VISA payment</div>
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
				    </td>
               
			    </tr>
		    </table>

</asp:Content>

