using Microsoft.VisualBasic;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Configuration;

namespace class_ADO
{
    public class clsADO
    {

        public string getMaxConnectionString()
        {
            var result = "";
            try
            {
                System.Configuration.Configuration rootWebConfig1 = System.Web.Configuration.WebConfigurationManager.OpenWebConfiguration("/Portal2CSharp");

                if (rootWebConfig1.AppSettings.Settings.Count > 0)
                {
                    System.Configuration.KeyValueConfigurationElement customSetting = rootWebConfig1.AppSettings.Settings["ConStrMax"];
                    if (customSetting != null)
                        result = customSetting.Value;
                    else
                        Console.WriteLine("No ConStrMax application string");
                }

                return result;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
                return null;
            }

        }

        public string getLocalConnectionString()
        {
            try
            {
                var result = "";
                try
                {
                    System.Configuration.Configuration rootWebConfig1 = System.Web.Configuration.WebConfigurationManager.OpenWebConfiguration("/Portal2CSharp");

                    if (rootWebConfig1.AppSettings.Settings.Count > 0)
                    {
                        System.Configuration.KeyValueConfigurationElement customSetting = rootWebConfig1.AppSettings.Settings["ConStrLocal"];
                        if (customSetting != null)
                            result = customSetting.Value;
                        else
                            Console.WriteLine("No ConStrMax application string");
                    }

                    return result;
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.ToString());
                    return null;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
                return null;
            }

        }


        public void updateOrInsert(string strSQL, bool Max)
        {
          
                string conn = "";

                if (Max == true)
                {
                    conn = getMaxConnectionString();
                }
                else
                {
                    conn = getLocalConnectionString();
                }

                using (SqlConnection con = new SqlConnection(conn))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = strSQL;
                        cmd.Connection = con;
                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
                }
   
        }

        public object returnSingleValue(string strSQL, bool Max)
        {
        
                object thisReturn = null;
                string conn = "";

                if (Max == true)
                {
                    conn = getMaxConnectionString();
                }
                else
                {
                    conn = getLocalConnectionString();
                }

                using (SqlConnection con = new SqlConnection(conn))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = strSQL;
                        cmd.Connection = con;
                        con.Open();
                        using (SqlDataReader sdr = cmd.ExecuteReader())
                        {
                            while (sdr.Read())
                            {
                                thisReturn = sdr[0];
                            }
                        }
                        con.Close();
                    }
                }
                return thisReturn;
       

        }

        
    }
}
