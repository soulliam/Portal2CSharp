<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2Empty.master" AutoEventWireup="true" CodeFile="ReservationDisplay.aspx.cs" Inherits="ReservationDisplay" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <link rel="stylesheet" href="/jqwidgets/styles/jqx.base.css" type="text/css" />

    <script type="text/javascript" src="jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="jqwidgets/globalization/globalize.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxbuttons.js"></script>

    <script type="text/javascript">
        
        $(document).ready(function () {
            

            $("#email").jqxButton({ width: 415, height: 25 });

            $("#email").jqxButton({ width: 180, height: 25 });
            
            var thisCard = getUrlParameter('thisCard');
            var thisToAddress = getUrlParameter('thisEmailAddress');

            $("#emailAddress").val(thisToAddress);

            $("#email").on("click", function (event) {
                var body = $("#redemption").html();
                
                
                var resBody = body.replace(/"\.\/EmailImages\/.*Jpeg"/, "cid:MyPic");
                resBody = resBody.replace("&", "%26");

                $('#redemption').get(0).outerHTML;
                PageMethods.sendReceipt(resBody, thisCard, thisToAddress, DisplayPageMethodResults);
            });
        });



        function getUrlParameter(name) {
            name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
            var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
            var results = regex.exec(location.search);
            return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
        };
    </script>

    <div id="redemption">
        <table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
            <tbody><tr>
                <td align="center" valign="middle" bgcolor="#eeeeee">

                    <table border="0" cellpadding="0" cellspacing="0" width="700" align="center" class="m_4391485547386968897table-main-gmail" style="min-width:700px">

                        <tbody><tr>
                            <td align="center" bgcolor="#eeeeee" style="min-width:700px;padding:0px 0px 0px 0px;vertical-align:middle" class="m_4391485547386968897table-main-gmail">

                                <table border="0" cellpadding="0" cellspacing="0" width="100%" align="center" class="m_4391485547386968897table-main">
                                    <tbody><tr><td style="padding:32px 0px 0px 0px"></td></tr>
                                    <tr>
                                        <td align="center" valign="middle" bgcolor="#eee" style="border-radius:0px;border-top:1px solid #d8d8d8;border-left:1px solid #d8d8d8;border-right:1px solid #d8d8d8">

                                            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="m_4391485547386968897hide">
                                                <tbody>
                                                    <tr>
                                                        <td align="right" valign="top" style="padding:0px;width:375px;background:#fff"><img src="https://ci5.googleusercontent.com/proxy/SGWCWwEQYRxW8NqSRjbjtlJTatU5JOUHG_SVkrsBQufR1w8g9T6qY63DfYtdNwZTSUpZP1IVtcuj1LhyEL1trVELHVh7FrheNGhplWweJeeR6rCd=s0-d-e1-ft#https://www.thefastpark.com/images/EmailTemplates/header.jpg" alt="" width="375" style="width:375px;padding:0" class="CToWUd"></td>
                                                        <td align="right" valign="top" bgcolor="#ffffff"><a href="https://www.thefastpark.com" target="_blank" data-saferedirecturl="https://www.google.com/url?hl=en&amp;q=https://www.thefastpark.com&amp;source=gmail&amp;ust=1524337538964000&amp;usg=AFQjCNHsUbSFYSGpBj45FuzjHlbzFFLdfQ"><img src="https://ci4.googleusercontent.com/proxy/3Oc-zTMMs2KkGnAAF6bXim3_8EIczmTRcThEM5vqSsVTCvsStXE9aVnYZOMGI04rpJvbAnI3qcAmJhQyHMg891rbzO_bbGpVzJIhGdR5py3Ln5KbXBa4MqwyysiDqct3=s0-d-e1-ft#https://www.thefastpark.com/images/EmailTemplates/fastparkrelax-logo.png" width="319" height="111" alt="Fast Park" border="0" style="display:block" class="CToWUd"></a></td>
                                                    </tr>

                                                </tbody>
                                            </table>

                                            <%--<div class="m_4391485547386968897mobile-only" style="font-size:0;max-height:0;overflow:hidden;display:none">

                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tbody>
                                                        <tr>
                                                            <td align="right" valign="top" style="padding:0px;width:184px"><img src="https://ci5.googleusercontent.com/proxy/y2q7LNS4Vkg4hfNJs_rFfDS822nvk6ozl-eKKud1cQFNqxE8ayr9LyUgZ6Txbdgehcw_-LQroz8dhbOW5hZATJD7gx_WQHedNio14Lx_qlbbndXtUQ=s0-d-e1-ft#https://www.thefastpark.com/images/EmailTemplates/headerM.jpg" alt="" width="184" height="70" style="padding:0px" class="CToWUd"></td>
                                                            <td align="right" valign="top" bgcolor="#ffffff"><a href="https://www.thefastpark.com" target="_blank" data-saferedirecturl="https://www.google.com/url?hl=en&amp;q=https://www.thefastpark.com&amp;source=gmail&amp;ust=1524337538964000&amp;usg=AFQjCNHsUbSFYSGpBj45FuzjHlbzFFLdfQ"><img src="https://ci4.googleusercontent.com/proxy/aXpsnkF7BIXbWXRacJjy4O0Z-rnCFA4XBFE_C1lnBZ9hz3IxO39qpCDElwkGWetGi63HVWGQhgLiKVhg_7m9z6staCuc074ZgagXl8cQt1-C4uNpKzzmTncSU-xiLII7fxbvlJm6Bg=s0-d-e1-ft#https://www.thefastpark.com/images/EmailTemplates/Mobile/fastparkrelax-logo.png" width="176" height="70" alt="Fast Park" border="0" style="display:block;width:176px;height:70px" class="CToWUd"></a></td>
                                                        </tr>
                                                    </tbody>
                                                </table>

                                            </div>--%>
                                        
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" bgcolor="#ffffff" valign="middle" style="font-family:'Helvetica Neue',Helvetica,sans-serif,'Bitter';font-size:16px;line-height:24px;text-decoration:none;color:#4a4a4a;padding:32px 20px 0px 32px;border-left:1px solid #d8d8d8;border-right:1px solid #d8d8d8;text-align:left" class="m_4391485547386968897mob-hero-pad">
                                            <p>Thank you for making a parking reservation with us. The details of your reservation are included below. </p>

                                            <strong>When you arrive </strong>
                                            <p style="margin-top:5px">Please have your reservation printed or accessible on your smartphone to show our Cashier upon entry.</p>

                                            <p>Note: If you’re traveling during peak times, you may notice a “Closed” or “Relax for Rewards Members Only” sign at the entrance of our facility. Your reservation guarantees your admittance into the designated Fast Park facility, so please proceed to the Cashier Booth and show your reservation.</p>

										    <p>In the event the facility is full, Fast Park will valet your car at no additional fee and will move your vehicle to a parking space when one becomes available.</p>

                                            <strong>Plans changed?</strong>
                                            <p style="margin-top:5px">If you need to change or cancel your reservation, please log in to your Rewards Account at <span><a href="https://www.thefastpark.com" target="_blank" data-saferedirecturl="https://www.google.com/url?hl=en&amp;q=https://www.thefastpark.com&amp;source=gmail&amp;ust=1524337538964000&amp;usg=AFQjCNF8Oo4PkhHVm4iln2nA9uKaTmfVDA">www.thefastpark.com</a></span>. We ask that you make any changes at least 24 hours before your original check-in date and time. If your trip happens to extend beyond your anticipated check-out date, there is no need to alert us. Your car will be ready and waiting for you when you return.</p>
	
                                            <strong>Questions?</strong>
                                            <p style="margin-top:5px">Please review our Fast Park Reservation FAQs or contact your local facility for further assistance.</p>

                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" bgcolor="#ffffff" valign="middle" style="font-family:'Helvetica Neue',Helvetica,sans-serif,'Bitter';font-size:16px;line-height:24px;text-decoration:none;color:#4a4a4a;padding:10px 20px 0px 32px;border-left:1px solid #d8d8d8;border-right:1px solid #d8d8d8;text-align:left" class="m_4391485547386968897mob-hero-pad">
                                            <strong>Reservation Details</strong>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" bgcolor="#ffffff" valign="middle" style="font-family:'Helvetica Neue',Helvetica,sans-serif,'Roboto';font-size:16px;line-height:26px;text-decoration:none;color:#719932;padding:10px 0px 0px 32px;border-left:1px solid #d8d8d8;border-right:1px solid #d8d8d8" class="m_4391485547386968897mob-mc-pad1">

                                            <a runat="server" id="MemberName"><strong>akhty fritz</strong></a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" bgcolor="#ffffff" valign="middle" style="font-family:'Helvetica Neue',Helvetica,sans-serif,'Roboto';font-size:16px;line-height:26px;text-decoration:none;color:#4a4a4a;padding:0px 10px 0px 32px;border-left:1px solid #d8d8d8;border-right:1px solid #d8d8d8" class="m_4391485547386968897mob-mc-pad2">
										    <a runat="server" id="emailAddress" href="mailto:mikegoode@gmail.com" target="_blank">test@gmail.com</a>
									    </td>
                                    </tr>

                                    <tr>
                                        <td align="left" bgcolor="#ffffff" valign="middle" style="font-family:'Helvetica Neue',Helvetica,sans-serif,'Roboto';font-size:16px;line-height:26px;text-decoration:none;color:#719932;padding:15px 0px 0px 32px;border-left:1px solid #d8d8d8;border-right:1px solid #d8d8d8" class="m_4391485547386968897mob-mc-pad1">
                                            <a runat="server" id="location"><strong>MKE Milwaukee</strong></a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" bgcolor="#ffffff" valign="middle" style="font-family:'Helvetica Neue',Helvetica,sans-serif,'Roboto';font-size:16px;line-height:24px;text-decoration:none;color:#4a4a4a;padding:5px 32px 0px 32px;border-left:1px solid #d8d8d8;border-right:1px solid #d8d8d8" class="m_4391485547386968897mob-mc-pad2">
										    at <a runat="server" id="brand">Fast Park &amp; Relax</a>
									    </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tbody><tr>
                                                    <td align="left" bgcolor="#ffffff" valign="middle" style="font-family:'Helvetica Neue',Helvetica,sans-serif,'Roboto';font-size:16px;line-height:26px;text-decoration:none;color:#719932;padding:15px 0px 0px 32px;border-left:1px solid #d8d8d8;width:200px" class="m_4391485547386968897mob-mc-pad1 m_4391485547386968897half">
                                                        <strong>Check-In</strong>
                                                    </td>
                                                    <td align="left" bgcolor="#ffffff" valign="middle" style="font-family:'Helvetica Neue',Helvetica,sans-serif,'Roboto';font-size:16px;line-height:26px;text-decoration:none;color:#719932;padding:15px 0px 0px 0px;border-right:1px solid #d8d8d8" class="m_4391485547386968897mob-mc-pad1 m_4391485547386968897half">
                                                        <strong>Check-Out</strong>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left" bgcolor="#ffffff" valign="middle" style="font-family:'Helvetica Neue',Helvetica,sans-serif,'Roboto';font-size:16px;line-height:24px;text-decoration:none;color:#4a4a4a;padding:5px 0px 0px 32px;border-left:1px solid #d8d8d8;width:200px" class="m_4391485547386968897mob-mc-pad2 m_4391485547386968897half">
													    <a runat="server" id="startDate">3/27/2019 at 12:00 PM</a>
												    </td>
                                                    <td align="left" bgcolor="#ffffff" valign="middle" style="font-family:'Helvetica Neue',Helvetica,sans-serif,'Roboto';font-size:16px;line-height:24px;text-decoration:none;color:#4a4a4a;padding:5px 0px 0px 0px;border-right:1px solid #d8d8d8" class="m_4391485547386968897mob-mc-pad2 m_4391485547386968897half">
													    <a runat="server" id="endDate">3/29/2019 at 12:00 PM</a>
												    </td>
                                                </tr>
                                            </tbody></table>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td align="left" bgcolor="#ffffff" valign="middle" style="font-family:'Helvetica Neue',Helvetica,sans-serif,'Roboto';font-size:16px;line-height:26px;text-decoration:none;color:#719932;padding:15px 0px 0px 32px;border-left:1px solid #d8d8d8;border-right:1px solid #d8d8d8" class="m_4391485547386968897mob-mc-pad1">
                                            <strong>Reservation Number</strong>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" bgcolor="#ffffff" valign="middle" style="font-family:'Helvetica Neue',Helvetica,sans-serif,'Roboto';font-size:16px;line-height:24px;text-decoration:none;color:#4a4a4a;padding:5px 32px 0px 32px;border-left:1px solid #d8d8d8;border-right:1px solid #d8d8d8" class="m_4391485547386968897mob-mc-pad2">
										    <a runat="server" id="reservationNumber">0000000000</a>
									    </td>
                                    </tr>

                                    <tr>
                                        <td align="left" bgcolor="#ffffff" valign="middle" style="font-family:'Helvetica Neue',Helvetica,sans-serif,'Roboto';font-size:16px;line-height:26px;text-decoration:none;color:#719932;padding:15px 0px 0px 32px;border-left:1px solid #d8d8d8;border-right:1px solid #d8d8d8" class="m_4391485547386968897mob-mc-pad1">
                                            <strong>Estimated Total Due at Exit*</strong>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" bgcolor="#ffffff" valign="middle" style="font-family:'Helvetica Neue',Helvetica,sans-serif,'Roboto';font-size:16px;line-height:24px;text-decoration:none;color:#4a4a4a;padding:5px 32px 0px 32px;border-left:1px solid #d8d8d8;border-right:1px solid #d8d8d8" class="m_4391485547386968897mob-mc-pad2">
										    <a runat="server" runat="server" id="estCost">$16.01</a>
									    </td>
                                    </tr>
								    <tr>
                                        <td align="left" bgcolor="#ffffff" valign="middle" style="font-family:'Helvetica Neue',Helvetica,sans-serif,'Bitter';font-size:16px;line-height:24px;text-decoration:none;color:#4a4a4a;padding:5px 20px 0px 32px;border-left:1px solid #d8d8d8;border-right:1px solid #d8d8d8;text-align:left" class="m_4391485547386968897mob-hero-pad">
                                        
                                            <p style="margin-top:5px">* Final parking fees will be calculated based on your actual check-in and check-out date/time and current rates. Parking fees are subject to applicable local taxes and airport fees.</p>

                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" bgcolor="#ffffff" valign="middle" style="font-family:'Helvetica Neue',Helvetica,sans-serif,'Roboto';font-size:13px;font-weight:500;line-height:16px;text-decoration:none;color:#4a4a4a;padding:0px;border-left:1px solid #d8d8d8;border-right:1px solid #d8d8d8;width:200px" class="m_4391485547386968897mob-mc-pad4">

											    <asp:PlaceHolder ID="MemberBarHolder" runat="server" />
                                                <asp:Image ID="EmailQR" src=cid:MyPic runat="server" />
                                                

                                        </td>
                                    </tr>

                                    <tr>
                                        <td align="left" bgcolor="#ffffff" valign="middle" style="font-family:'Helvetica Neue',Helvetica,sans-serif,'Bitter';font-size:16px;line-height:24px;text-align:left;text-decoration:none;color:#4a4a4a;padding:0px 32px 0px 32px;border-left:1px solid #d8d8d8;border-right:1px solid #d8d8d8" class="m_4391485547386968897mob-hero-pad">
                                            <p>Thank you for using the Fast Park Reservation System! We look forward to seeing you very soon. </p>
                                            <p>Warm Regards,<br>
                                            <i><asp:Label ID="txtManager" runat="server" Text="Label"></asp:Label></i>
                                            <br><asp:Label ID="txtManagerBrand" runat="server" Text="Label"></asp:Label>
                                            <br><asp:Label ID="txtManagerAddress" runat="server" Text="Label"></asp:Label>
                                            <br><asp:Label ID="txtManagerCity" runat="server" Text="Label"></asp:Label>,&nbsp;<asp:Label ID="txtManagerState" runat="server" Text="Label"></asp:Label>&nbsp;<asp:Label ID="txtManagerZip" runat="server" Text="Label"></asp:Label>
                                            <br><asp:label ID="txtManagerEmail" runat="server" href="mailto:rfrteam@thefastpark.com" target="_blank"></asp:label>
                                            <br><asp:Label ID="txtManagerPhone" runat="server" Text="Label"></asp:Label>
                                            </p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center" valign="middle">

                                            <table border="0" cellpadding="0" cellspacing="0" width="100%" align="center" class="m_4391485547386968897emailwrapto320">
                                                <tbody><tr>
                                                    <td align="center" valign="middle" style="padding:8px 0px 8px 0px;border-bottom:solid 1px #d9d9d9;border-left:1px solid #d8d8d8;border-right:1px solid #d8d8d8">
                                                        <table class="m_4391485547386968897emailwrapto320" width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
                                                            <tbody><tr>
                                                                <td class="m_4391485547386968897emailnomob" width="30"></td>
                                                                <td class="m_4391485547386968897emailwrapto318" align="left" style="padding:10px 0px">
                                                                    <a class="m_4391485547386968897footer" href="https://www.thefastpark.com/contact-us" style="font-family:'Helvetica Neue',Helvetica,sans-serif,'Roboto';font-size:13px;font-weight:500;color:#4a4a4a;text-decoration:none" target="_blank" data-saferedirecturl="https://www.google.com/url?hl=en&amp;q=https://www.thefastpark.com/contact-us&amp;source=gmail&amp;ust=1524337538965000&amp;usg=AFQjCNGRL5lEli0DljJRGaGM-MQOlgQ2AA">Contact Us</a><span style="font-family:'Helvetica Neue',Helvetica,sans-serif,'Roboto';font-size:11px;color:#4a4a4a" class="m_4391485547386968897emailnomob">&nbsp;&nbsp;&nbsp;&nbsp;</span>
                                                                    <a class="m_4391485547386968897footer" href="https://www.thefastpark.com/privacy-policy" style="font-family:'Helvetica Neue',Helvetica,sans-serif,'Roboto';font-size:13px;font-weight:500;color:#4a4a4a;text-decoration:none" target="_blank" data-saferedirecturl="https://www.google.com/url?hl=en&amp;q=https://www.thefastpark.com/privacy-policy&amp;source=gmail&amp;ust=1524337538965000&amp;usg=AFQjCNECiqLlsLO3X6OyWwy0ph_HN-TEng">Privacy Policy</a><span style="font-family:'Helvetica Neue',Helvetica,sans-serif,'Roboto';font-size:12px;color:#4a4a4a" class="m_4391485547386968897emailnomob">&nbsp;&nbsp;&nbsp;&nbsp;</span>
                                                                    <a class="m_4391485547386968897footer" href="https://www.thefastpark.com/terms" style="font-family:'Helvetica Neue',Helvetica,sans-serif,'Roboto';font-size:13px;font-weight:500;color:#4a4a4a;text-decoration:none" target="_blank" data-saferedirecturl="https://www.google.com/url?hl=en&amp;q=https://www.thefastpark.com/terms&amp;source=gmail&amp;ust=1524337538965000&amp;usg=AFQjCNGmMoa8HxMLTPIM-28KN8H93GZlcg">Terms &amp; Conditions</a>
                                                                </td>

                                                            </tr>
                                                        </tbody></table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="middle" style="font-family:'Helvetica Neue',Helvetica,sans-serif,'Roboto';font-size:16px;line-height:24px;font-weight:300;text-decoration:none;color:#4a4a4a;padding:15px 80px 0px 32px;border-left:1px solid #d8d8d8;border-right:1px solid #d8d8d8;border-bottom:solid 1px #d9d9d9" class="m_4391485547386968897mob-mc-pad3">
                                                        <b style="font-family:'Helvetica Neue',Helvetica,sans-serif,'Roboto';font-size:13px;font-weight:500;color:#4a4a4a;text-decoration:none">We're in the business of filling parking lots, not your inbox.</b>
                                                        <p style="margin-top:0;font-family:'Helvetica Neue',Helvetica,sans-serif,'Roboto';font-size:14px;color:#979797">if you would like to change which emails you receive from Fast Park, <a href="https://www.thefastpark.com/relaxforrewards/email-settings" target="_blank" data-saferedirecturl="https://www.google.com/url?hl=en&amp;q=https://www.thefastpark.com/relaxforrewards/email-settings&amp;source=gmail&amp;ust=1524337538965000&amp;usg=AFQjCNGigXfSEKXDSaJQffF2IUSrG7nUPA">click here</a></p>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="center" valign="middle" style="padding:8px 0px 8px 0px;border-bottom:solid 1px #d9d9d9;border-left:1px solid #d8d8d8;border-right:1px solid #d8d8d8">

                                                        <table class="m_4391485547386968897emailwrapto320" width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
                                                            <tbody><tr>
                                                                <td class="m_4391485547386968897emailnomob" width="30"></td>
                                                                <td class="m_4391485547386968897emailwrapto318" align="left" style="padding:10px 0px 0px 0px;font-family:'Helvetica Neue',Helvetica,sans-serif,'Roboto';font-size:13px;color:#979797">
                                                                    Please do not reply to this email. This is a system-generated email. Replies will not be read or forwarded for handling.
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="m_4391485547386968897emailnomob" width="30"></td>
                                                                <td class="m_4391485547386968897emailwrapto318" align="left" style="padding:10px 0px;font-family:'Helvetica Neue',Helvetica,sans-serif,'Roboto';font-size:12px;color:#979797">
                                                                    © 2016 Parking Company of America
                                                                </td>
                                                            </tr>
                                                        </tbody></table>

                                                    </td>
                                                </tr>
                                            </tbody></table>

                                        </td>
                                    </tr>

                                </tbody></table>

                            </td>
                        </tr>
                    </tbody></table>

                </td>
            </tr>
        </tbody>
    </table>
    </div>
    <div style="margin-left:15px;margin-top:10px"><input id="email" value="Send" /></div>
    <div id="img-out" style="display:none"></div>
</asp:Content>

