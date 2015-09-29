using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WeatherReportModel;
using System.Diagnostics;
using System.Data.Entity.Validation;
using System.ComponentModel.DataAnnotations;

namespace WeatherReport.Models
{
    public class Weather
    {
        public int Id { get; set; }
        public int cityId { get; set; }
        [Display(Name = "Clothing Layers")]
        public string clothingLayers { get; set; }
        public System.DateTime issued { get; set; }
        public int location { get; set; }
        [Display(Name = "Past")]
        public string past { get; set; }
        [Display(Name = "Pressure")]
        public Nullable<double> pressure { get; set; }
        [Display(Name = "Rainfall")]
        public Nullable<double> rainfall { get; set; }
        [Display(Name = "Relative Humidity")]
        public double relativeHumidity { get; set; }
        [Display(Name = "Status")]
        public string status { get; set; }
        [Display(Name = "Temperature")]
        public Nullable<double> temperature { get; set; }
        [Display(Name = "Time")]
        [DisplayFormat(DataFormatString = "{0:dd MMM yyyy  H:mm}")]
        public Nullable<System.DateTime> time { get; set; }
         [Display(Name = "Wind Chill")]
        public Nullable<double> windChill { get; set; }
        [Display(Name = "wind Direction")]
        public Nullable<double> windDirection { get; set; }
        [Display(Name = "wind GustSpeed")]
        public Nullable<double> windGustSpeed { get; set; }
        [Display(Name = "wind Proof Layers")]
        public string windProofLayers { get; set; }
        [Display(Name = "Wind Speed")]
        public Nullable<double> windSpeed { get; set; }
        [Display(Name = "Wind Speed Description")]
        public string windSpeedDesc { get; set; }

        public static IEnumerable<Weather> GetWeather(int cityID)
        {
            var last24hours = DateTime.Now.AddDays(-1);
            WeatherReportEntities dbContext = new WeatherReportEntities();
            var query = from weather in dbContext.Weathers
                        where weather.cityId == cityID && weather.issued >= last24hours
                        orderby weather.issued descending
                        select
                            new Weather
                            {
                                clothingLayers = weather.clothingLayers,
                                past = weather.past,
                                rainfall = weather.rainfall,
                                relativeHumidity = weather.relativeHumidity,
                                status = weather.status,
                                temperature = weather.temperature,
                                time = weather.time,
                                windChill = weather.windChill,
                                windDirection = weather.windDirection,
                                windGustSpeed = weather.windGustSpeed,
                                windProofLayers = weather.windProofLayers,
                                windSpeed = weather.windSpeed,
                                windSpeedDesc = weather.windSpeedDesc
                            };
            return query;

        }

        public static void AddWeatherRecord(int cityId, Weather weather)
        {
            try
            {
                WeatherReportModel.Weather w = new WeatherReportModel.Weather();
                w.cityId = cityId;
                w.clothingLayers = weather.clothingLayers;
                w.issued = weather.issued;
                w.location = weather.location;
                w.past = weather.past;
                w.pressure = weather.pressure;
                w.rainfall = weather.rainfall;
                w.relativeHumidity = weather.relativeHumidity;
                w.status = weather.status;
                w.temperature = weather.temperature;
                w.time = weather.time;
                w.windChill = weather.windChill;
                w.windDirection = weather.windDirection;
                w.windGustSpeed = weather.windGustSpeed;
                w.windProofLayers = weather.windProofLayers;
                w.windSpeed = weather.windSpeed;
                w.windSpeedDesc = weather.windSpeedDesc;

                WeatherReportEntities dbContext = new WeatherReportEntities();
                dbContext.Weathers.Add(w);
                dbContext.SaveChanges();
            }
            catch (DbEntityValidationException e)
            {
                //Debug.WriteLine(ex.Message);

                foreach (var eve in e.EntityValidationErrors)
                {
                    Debug.WriteLine("Entity of type \"{0}\" in state \"{1}\" has the following validation errors:",
                        eve.Entry.Entity.GetType().Name, eve.Entry.State);
                    foreach (var ve in eve.ValidationErrors)
                    {
                        Debug.WriteLine("- Property: \"{0}\", Error: \"{1}\"",
                            ve.PropertyName, ve.ErrorMessage);
                    }
                }
                throw;
            }
        }
    }

}