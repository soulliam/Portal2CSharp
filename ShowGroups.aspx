<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="ShowGroups.aspx.cs" Inherits="ShowGroups" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <style>
        .contextItems{
          list-style:none;
          margin:0px;
          margin-top:4px;
          padding-left:5px;
          padding-right:5px;
          padding-bottom:3px;
          font-size:15px;
          color: #333333;
  
        }

        #cntnr{
          display:none;
          position:fixed;
          border:1px solid #B2B2B2;
          width:150px;      background:#F9F9F9;
          border-radius:4px;
        }

        .contextItems > li{
          padding: 3px;
          padding-left:5px;
        }

        .contextItems :hover{
          color: white;
          background:#284570;
          border-radius:2px;
        }
    </style>

    <script type="text/javascript">

        var group = '<%= Session["groupList"] %>';
        
        $(document).ready(function () {
            //Code to prevent inspect function
            //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            //When we click the custom context menu we lose focus on where we want to paste.  so we use this to hold the previous element
            window.prevFocus = $();
            //This holds the highlighted text before the selection is lost when focus goes to the custom context menu
            var copiedText = "";

            //store the previous element in our variable for pastibng.  We only want inputs not buttons checkboxes and such
            $(document).on('focusin', ':input:not(:button, :checkbox, :submit)', function () {
                window.prevFocus = $(this);
            });

            //HighJacks context menu request and shows custom context menu
            $(document).bind("contextmenu", function (e) {

                var cm = false;
                $(":input").each(function () {
                    //if ~!~ is in any input on the page it will allow default context menu
                    var element = $(this);
                    if (element.val().indexOf("~!~") >= 0) {
                        cm = true;
                        return false;
                    }
                });
                if (cm == true) {
                    return;
                }
                e.preventDefault();
                $("#cntnr").css("left", e.pageX);
                $("#cntnr").css("top", e.pageY);    
                $("#cntnr").fadeIn(200);
            });

            //Closes the menu on any click 
            $(document).on("click", function () {
                $("#cntnr").hide();
            });
               
            //Copy button on context menu gets highlighted text and saves it to variable and the executes copy command
            $("#copy").on("click", function () {
                copiedText = window.getSelection().toString();
                document.execCommand('copy');
            });
                
            //Cut button on context menu gets highlighted text and saves it to variable and the executes copy command
            $("#cut").on("click", function () {
                copiedText = window.getSelection().toString();
                document.execCommand('cut');
            });

            //Past button first tries to add copied text to last element by val then html (textarea)
            $("#paste").on("click", function () {
                $("#" + window.prevFocus[0].id).val(copiedText);
                $("#" + window.prevFocus[0].id).html(copiedText);
            });

            //Prevents chrome key strokes opening inspect
            document.onkeydown = function (e) {
                if (event.keyCode == 123) {
                    return false;
                }
                if (e.ctrlKey && e.shiftKey && e.keyCode == 'I'.charCodeAt(0)) {
                    return false;
                }
                if (e.ctrlKey && e.shiftKey && e.keyCode == 'J'.charCodeAt(0)) {
                    return false;
                }
                if (e.ctrlKey && e.shiftKey && e.keyCode == 'C'.charCodeAt(0)) {
                    return false;
                }
                if (e.ctrlKey && e.keyCode == 'U'.charCodeAt(0)) {
                    return false;
                }
            }
            //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            
            $("#showGroups").html(group);

            var thisLoggedinUsername = $("#txtLoggedinUsername").val();

            loadVehicleLocations(thisLoggedinUsername);

            $("#sendEmail").on('click', function () {
                var body = "<div><label>Groups</label></div>" + $("#showGroups").val() + "</div><hr><div><label>Old Portal Vehicle Locations</label></div>" + $("#showVehicleLocations").val() + "</div>";
                PageMethods.SendEmail($("#emailAddress").val(), "IT@thefastpark.com", "Member Data", body, true, onSucess, onError);
                function onSucess(result) {
                    swal(result);
                }
                function onError(result) {
                    swal('Error instructions not sent.');
                }
            });

        });


        function loadVehicleLocations(username) {
            username = username.split('\\');
           
            var url = $("#localApiDomain").val() + "Vehicles/GetUsersVehicleLocations/" + username[1];
            //var url = "http://localhost:52839/api/Vehicles/GetUsersVehicleLocations/" + username[1]

            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                success: function (thisData) {
                    var locs = "";
                    var first = true;
                    $.each(thisData, function (key, value) {
                        if (first == true) {
                            locs = value.ShortLocationName;
                        } else {
                            locs = locs + ", " + value.ShortLocationName;
                        }
                        first = false;
                    });

                    $("#showVehicleLocations").val(locs);
                },
                error: function (request, status, error) {
                    alert(error);
                }
            });
        }
    </script>
    <div id="thisBody" class="context-menu-one">
        <div id="Locations" class="container-fluid container-970 wrap-search-options" style="margin-bottom:100px">
            <div id="FPR_SearchBox" class="FPR_SearchBox wrap-search-options" style="display:block;width:100%;">
                <label style="font-size:xx-large;color:white;margin:0 auto">User Data</label>
            </div>
        </div>
        <div>
            <label style="font-size:large;color:white;margin:0 auto">User Groups</label>
            <textarea id="showGroups" style="width:100%; height: 200px; border: 1px solid #000000;margin:5px 0; padding:10px;margin-bottom:50px"></textarea>
        </div>

        <div>
            <label style="font-size:large;color:white;margin:0 auto">Old Portal Vehicle Locations</label>
            <textarea id="showVehicleLocations" style="width:100%; height: 200px; border: 1px solid #000000;margin:5px 0; padding:10px;"></textarea>
        </div>
        <div>
            <input id="sendEmail" type="button" value="Send Email" style="width:200px" /><input id="emailAddress" type="text" placeholder="email address" style="width:200px;margin-left:15px;" />
        </div>
    </div>

    //context menu
    <div id='cntnr'>
        <ul id='items' class="contextItems">
          <li><input type="button" id="copy" value="copy" /></li>
          <li><input type="button" id="cut" value="cut" /></li>
          <li><input type="button" id="paste" value="paste" /></li>
        </ul>
   </div>
</asp:Content>


