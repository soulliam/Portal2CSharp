using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using class_ADO;

public partial class Dashboard : System.Web.UI.Page
{


    protected void Page_Load(object sender, EventArgs e)
    {
        thisUser.Text = Page.User.Identity.Name;

        GetWeather();
        GetDelays();
    }


    protected void GetWeather()
    {
        var listHTML = "";

        HtmlAgilityPack.HtmlWeb web = new HtmlAgilityPack.HtmlWeb();
        HtmlAgilityPack.HtmlDocument doc = web.Load("https://www.google.com/search?q=weather+for+Albuquerque&rlz=1C1VFKB_enUS683US684&oq=weather+for+Albuquerque&aqs=chrome..69i57j0l5.4151j0j4&sourceid=chrome&ie=UTF-8");

        var Headernames = doc.DocumentNode.SelectNodes("//div[@class='e']").ToList();

        listHTML = "<li>" + Headernames[0].InnerHtml + "</li>";

        doc = web.Load("https://www.google.com/search?safe=off&rlz=1C1VFKB_enUS683US684&ei=3n_zWc6MKMy9wATQmY_YBA&q=weather+for+Atlanta&oq=weather+for+Atlanta&gs_l=psy-ab.3..0i20i264k1j0l9.19963.19963.0.20754.1.1.0.0.0.0.236.236.2-1.1.0....0...1.1.64.psy-ab..0.1.235....0.4UUVykesfKA");

        Headernames = doc.DocumentNode.SelectNodes("//div[@class='e']").ToList();

        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";

        doc = web.Load("https://www.google.com/search?safe=off&rlz=1C1VFKB_enUS683US684&ei=YX3zWbG0D8qUwASZ0rfYAQ&q=weather+for+Austin&oq=weather+for+Austin&gs_l=psy-ab.3..0l10.18338.18338.0.19385.1.1.0.0.0.0.223.223.2-1.1.0....0...1.1.64.psy-ab..0.1.222....0.YZWX_iNr49I");

        Headernames = doc.DocumentNode.SelectNodes("//div[@class='e']").ToList();

        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";

        doc = web.Load("https://www.google.com/search?safe=off&rlz=1C1VFKB_enUS683US684&ei=dX3zWbqtLsbHwATrro64Aw&q=weather+for+Baltimore&oq=weather+for+Baltimore&gs_l=psy-ab.3..0l10.60255.60255.0.61629.1.1.0.0.0.0.237.237.2-1.1.0....0...1.1.64.psy-ab..0.1.236....0.rl6LFc-mR4c");

        Headernames = doc.DocumentNode.SelectNodes("//div[@class='e']").ToList();

        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";
        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";

        doc = web.Load("https://www.google.com/search?safe=off&rlz=1C1VFKB_enUS683US684&ei=tH3zWfuxJ8OnwgTouIbIBQ&q=weather+for+Cincinnati&oq=weather+for+Cincinnati&gs_l=psy-ab.3..0l10.33433.33433.0.34984.1.1.0.0.0.0.229.229.2-1.1.0....0...1.1.64.psy-ab..0.1.228....0.aikmr0uam6A");

        Headernames = doc.DocumentNode.SelectNodes("//div[@class='e']").ToList();

        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";

        doc = web.Load("https://www.google.com/search?safe=off&rlz=1C1VFKB_enUS683US684&ei=2H3zWZnuK4edwASi3akg&q=weather+for+Cleveland&oq=weather+for+Cleveland&gs_l=psy-ab.3..0l10.17500.17500.0.18842.1.1.0.0.0.0.225.225.2-1.1.0....0...1.1.64.psy-ab..0.1.225....0.VZQcYEmmTtA");

        Headernames = doc.DocumentNode.SelectNodes("//div[@class='e']").ToList();

        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";
        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";

        doc = web.Load("https://www.google.com/search?safe=off&rlz=1C1VFKB_enUS683US684&ei=7H3zWfe5K4a9wAS29rawDg&q=weather+for+Houston&oq=weather+for+Houston&gs_l=psy-ab.3..0l10.24786.24786.0.25617.1.1.0.0.0.0.225.225.2-1.1.0....0...1.1.64.psy-ab..0.1.225....0.tKREHurAP5g");

        Headernames = doc.DocumentNode.SelectNodes("//div[@class='e']").ToList();

        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";
        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";

        doc = web.Load("https://www.google.com/search?safe=off&rlz=1C1VFKB_enUS683US684&ei=u3_zWdTpIcGFwQSX1Jy4Bw&q=weather+for+Indianapolis&oq=weather+for+Indianapolis&gs_l=psy-ab.3..0l10.32310.32310.0.33364.1.1.0.0.0.0.222.222.2-1.1.0....0...1.1.64.psy-ab..0.1.221....0.4U6YkskXdZE");

        Headernames = doc.DocumentNode.SelectNodes("//div[@class='e']").ToList();

        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";

        doc = web.Load("https://www.google.com/search?safe=off&rlz=1C1VFKB_enUS683US684&ei=pH_zWb3cGYqOwgSzxbGwDQ&q=weather+for+Memphis&oq=weather+for+Memphis&gs_l=psy-ab.3..0l10.21041.21041.0.21944.1.1.0.0.0.0.216.216.2-1.1.0....0...1.1.64.psy-ab..0.1.215....0.d7bR5ZOFsuk");

        Headernames = doc.DocumentNode.SelectNodes("//div[@class='e']").ToList();

        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";

        doc = web.Load("https://www.google.com/search?safe=off&rlz=1C1VFKB_enUS683US684&ei=jn_zWYTCK8GjwgSCsa-gAQ&q=weather+for+Milwaukee&oq=weather+for+Milwaukee&gs_l=psy-ab.3..0i20i263k1j0l4j0i10k1j0l4.19693.19693.0.20500.1.1.0.0.0.0.249.249.2-1.1.0....0...1.1.64.psy-ab..0.1.248....0.I8St3sHV0C8");

        Headernames = doc.DocumentNode.SelectNodes("//div[@class='e']").ToList();

        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";

        doc = web.Load("https://www.google.com/search?safe=off&rlz=1C1VFKB_enUS683US684&ei=e3_zWbuFNsWjwQSBsb7IBg&q=weather+for+Orlando&oq=weather+for+Orlando&gs_l=psy-ab.3..0i20i264k1j0l9.15465.15465.0.16256.1.1.0.0.0.0.236.236.2-1.1.0....0...1.1.64.psy-ab..0.1.235....0.FZkN75fRdQ8");

        Headernames = doc.DocumentNode.SelectNodes("//div[@class='e']").ToList();

        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";

        doc = web.Load("https://www.google.com/search?safe=off&rlz=1C1VFKB_enUS683US684&ei=B37zWdiSK4GqwATe1ImYCA&q=weather+for+Raleigh&oq=weather+for+Raleigh&gs_l=psy-ab.3..0l10.58633.58633.0.59452.1.1.0.0.0.0.103.103.0j1.1.0....0...1.1.64.psy-ab..0.1.102....0.UH2etC2RILw");

        Headernames = doc.DocumentNode.SelectNodes("//div[@class='e']").ToList();

        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";

        doc = web.Load("https://www.google.com/search?safe=off&rlz=1C1VFKB_enUS683US684&ei=RH7zWbbFDcP-jwS9mJyoCA&q=weather+for+Tucson&oq=weather+for+Tucson&gs_l=psy-ab.3..0l5.309472.309472.0.310502.1.1.0.0.0.0.235.235.2-1.1.0....0...1.1.64.psy-ab..0.1.234....0.5wGN4tmqGIk");

        Headernames = doc.DocumentNode.SelectNodes("//div[@class='e']").ToList();

        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";

        WeatherList.InnerHtml = listHTML;

        //foreach (var item in Headernames)
        //{
        //    TEST.InnerHtml = item.InnerHtml;
        //}
    }

    protected void GetDelays()
    {
        var listHTML = "";

        HtmlAgilityPack.HtmlWeb web = new HtmlAgilityPack.HtmlWeb();
        HtmlAgilityPack.HtmlDocument doc = web.Load("https://www.flightview.com/airport/ABQ-Albuquerque-NM/delay");

        var Headernames = doc.DocumentNode.SelectNodes("//div[@class='faaDelayStatus']").ToList();

        listHTML = "<li>" + Headernames[0].InnerHtml + "</li>";

        doc = web.Load("https://www.flightview.com/airport/ATL-Atlanta-GA/delay");

        Headernames = doc.DocumentNode.SelectNodes("//div[@class='faaDelayStatus']").ToList();

        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";

        doc = web.Load("https://www.flightview.com/airport/AUS-Austin-TX/delay");

        Headernames = doc.DocumentNode.SelectNodes("//div[@class='faaDelayStatus']").ToList();

        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";

        doc = web.Load("https://www.flightview.com/airport/BWI-Baltimore-MD/delay");

        Headernames = doc.DocumentNode.SelectNodes("//div[@class='faaDelayStatus']").ToList();

        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";
        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";

        doc = web.Load("https://www.flightview.com/airport/CVG-Cincinnati-OH/delay");

        Headernames = doc.DocumentNode.SelectNodes("//div[@class='faaDelayStatus']").ToList();

        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";

        doc = web.Load("https://www.flightview.com/airport/CLE-Cleveland-OH/delay");

        Headernames = doc.DocumentNode.SelectNodes("//div[@class='faaDelayStatus']").ToList();

        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";
        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";

        doc = web.Load("https://www.flightview.com/airport/IAH-Houston-TX-(Intercontinental)/delay");

        Headernames = doc.DocumentNode.SelectNodes("//div[@class='faaDelayStatus']").ToList();

        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";

        doc = web.Load("https://www.flightview.com/airport/HOU-Houston-TX-(Hobby)/delay");

        Headernames = doc.DocumentNode.SelectNodes("//div[@class='faaDelayStatus']").ToList();

        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";

        doc = web.Load("https://www.flightview.com/airport/IND-Indianapolis-IN/delay");

        Headernames = doc.DocumentNode.SelectNodes("//div[@class='faaDelayStatus']").ToList();

        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";

        doc = web.Load("https://www.flightview.com/airport/MEM-Memphis-TN/delay");

        Headernames = doc.DocumentNode.SelectNodes("//div[@class='faaDelayStatus']").ToList();

        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";

        doc = web.Load("https://www.flightview.com/airport/MKE-Milwaukee-WI/delay");

        Headernames = doc.DocumentNode.SelectNodes("//div[@class='faaDelayStatus']").ToList();

        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";

        doc = web.Load("https://www.flightview.com/airport/MCO-Orlando-FL/delay");

        Headernames = doc.DocumentNode.SelectNodes("//div[@class='faaDelayStatus']").ToList();

        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";

        doc = web.Load("https://www.flightview.com/airport/RDU-Raleigh_Durham-NC/delay");

        Headernames = doc.DocumentNode.SelectNodes("//div[@class='faaDelayStatus']").ToList();

        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";

        doc = web.Load("https://www.flightview.com/airport/TUS-Tucson-AZ/delay");

        Headernames = doc.DocumentNode.SelectNodes("//div[@class='faaDelayStatus']").ToList();

        listHTML = listHTML + "<li>" + Headernames[0].InnerHtml + "</li>";

        delayList.InnerHtml = listHTML;

        //foreach (var item in Headernames)
        //{
        //    TEST.InnerHtml = item.InnerHtml;
        //}
    }
}