using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WeatherReportModel;

namespace WeatherReport.Models
{
    public class City
    {
        public int cityId { get; set; }
        public string cityName { get; set; }

        public static IEnumerable<City> GetCities()
        {
            WeatherReportEntities dbContext = new WeatherReportEntities();
            var query = from city in dbContext.Cities
                        select
                            new City
                            {
                                cityId = city.cityId,
                                cityName = city.cityName
                            };
            return query;

        }
    }
}