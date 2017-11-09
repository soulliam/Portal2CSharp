<%@ Page Title="" Language="C#" MasterPageFile="~/Portal2.master" AutoEventWireup="true" CodeFile="Twitter.aspx.cs" Inherits="Twitter" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <script type="text/javascript">
       
        var group = '<%= Session["groupList"] %>';

       $(document).ready(function () {

            if (group.indexOf("Portal_CarCount") <= 0) {
                $(location).attr('href', "http://www.thefastpark.com");
            }
            
            //$("#thisFrame").height(640);
            Security();
        })
    </script>

    <div id="thisDisplay" style="height:700px;width:100%">
        <div id="twitter" style="width:30%;height:100%;overflow-y: scroll;">
            <a class="twitter-timeline" href="https://twitter.com/thefastpark?ref_src=twsrc%5Etfw">Tweets by thefastpark</a> 
            <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
        </div>
        <div style="height:100%;width:100%;text-align:center;margin: 0 auto;float:right;">
            <iframe id="thisFrame" src="http://pca-portal:8080/CarcountWebsite/" background: transparent;border:none;" scrolling="no"></iframe>
        </div>
    </div>
</asp:Content>
