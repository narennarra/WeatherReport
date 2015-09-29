using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WeatherReportModel;


namespace WeatherReport
{
    public class WeatherController : Controller
    {
        public ActionResult Index(int id = 1)
        {
            ViewBag.cities = WeatherReport.Models.City.GetCities();
            ViewBag.id = id;

            return View(WeatherReport.Models.Weather.GetWeather(id));
        }


    }
}
