using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net;
using Newtonsoft.Json;
using System.Threading;
using System.Diagnostics;
using System.Threading.Tasks;

namespace WeatherReport
{
    public class CheckWeather
    {
        private static readonly string metserviceurl = "http://metservice.com/publicData/oneMinObs_";

        public class ThreadWork
        {
            public static void DoWork()
            {
                bool CONTINIUSLOOP = true;
                while (CONTINIUSLOOP)
                {
                    ProcessWeather();
                    Thread.Sleep(60000);
                }
            }
        }

        public static void Start()
        {
            ThreadStart myThreadDelegate = new ThreadStart(ThreadWork.DoWork);
            Thread myThread = new Thread(myThreadDelegate);
            myThread.Name = "CheckWeather";            
            myThread.Start();
        }



        public static void ProcessWeather()
        {
            foreach (var City in WeatherReport.Models.City.GetCities())
            {
                using (var w = new WebClient())
                {
                    try
                    {
                        var json_data = string.Empty;
                        json_data = w.DownloadString(metserviceurl + City.cityName);
                        WeatherReport.Models.Weather.AddWeatherRecord(City.cityId, JsonConvert.DeserializeObject<WeatherReport.Models.Weather>(json_data));
                    }
                    catch (Exception ex)
                    {
                        Debug.WriteLine(ex.Message);
                    }
                }
            }
        }
    }
}