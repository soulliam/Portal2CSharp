﻿using Microsoft.VisualBasic;
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

        public string getPark09ConnectionString()
        {
            try
            {
                var result = "";
                try
                {
                    System.Configuration.Configuration rootWebConfig1 = System.Web.Configuration.WebConfigurationManager.OpenWebConfiguration("/Portal2CSharp");

                    if (rootWebConfig1.AppSettings.Settings.Count > 0)
                    {
                        System.Configuration.KeyValueConfigurationElement customSetting = rootWebConfig1.AppSettings.Settings["Park08ConnectionString"];
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
            try
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
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
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

        public object returnSingleValuePark09(string strSQL)
        {

            object thisReturn = null;
            string conn = "";

            conn = getPark09ConnectionString();

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

        public struct sql2DObject
        {
            public object one;
            public object two;
        }


        public List<sql2DObject> return2DListLocal(string strSQL, Boolean Max = false)
        {
            clsADO thisADO = new clsADO();

            sql2DObject myObject;

            List<sql2DObject> thisList = new List<sql2DObject>();

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
                            myObject.one = sdr[0];
                            if (sdr.FieldCount > 1)
                            {
                                myObject.two = sdr[1];
                            }
                            else
                            {
                                myObject.two = "";
                            }
                            thisList.Add(myObject);
                        }
                    }
                    con.Close();
                }
            }
            return thisList;
        }
    }
}
