<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="ShowGroups.aspx.cs" Inherits="ShowGroups" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <script type="text/javascript">

        var group = '<%= Session["groupList"] %>';


        $(document).ready(function () {
            $("#showGroups").html(group);
        });
    </script>

    <div>
        <textarea id="showGroups" style="width:100%; height: 200px; border: 1px solid #000000;margin:5px 0; padding:10px;margin-top:150px"></textarea>
    </div>

</asp:Content>


