<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="Legal.aspx.cs" Inherits="Legal" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <link rel="stylesheet" href="/jqwidgets/styles/jqx.base.css" type="text/css" />
    <script type="text/javascript" src="jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="jqwidgets/jqxloader.js"></script>

   <script type="text/javascript">
       
        var group = '<%= Session["groupList"] %>';

       $(document).ready(function () {

            if (group.indexOf("Portal_Legal") <= 0) {
                $(location).attr('href', "http://www.thefastpark.com");
            }

            $("#jqxLoader").jqxLoader({ width: 100, height: 60, imagePosition: 'top' });
            
            var thisHeight = $(window).height() - $("#nav").height();

            $("#thisFrame").height(thisHeight);

            Security();
            $('#jqxLoader').jqxLoader('open');
            
            setTimeout(function () { $('#jqxLoader').jqxLoader('close') }, 1000);
       })

    </script>
    <div id="jqxLoader"></div>
    <div style="width:100%;height:100%;text-align:center;margin: 0 auto">
        <iframe id="thisFrame" src="http://pca-portal:8282/Restricted/LegalSearch.aspx" style="width:1000px;background: transparent;border:none;" ></iframe>
    </div>
</asp:Content>

