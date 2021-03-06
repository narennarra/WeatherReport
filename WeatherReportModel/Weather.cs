//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace WeatherReportModel
{
    using System;
    using System.Collections.Generic;
    
    public partial class Weather
    {
        public int Id { get; set; }
        public int cityId { get; set; }
        public string clothingLayers { get; set; }
        public System.DateTime issued { get; set; }
        public int location { get; set; }
        public string past { get; set; }
        public Nullable<double> pressure { get; set; }
        public Nullable<double> rainfall { get; set; }
        public double relativeHumidity { get; set; }
        public string status { get; set; }
        public Nullable<double> temperature { get; set; }
        public Nullable<System.DateTime> time { get; set; }
        public Nullable<double> windChill { get; set; }
        public Nullable<double> windDirection { get; set; }
        public Nullable<double> windGustSpeed { get; set; }
        public string windProofLayers { get; set; }
        public Nullable<double> windSpeed { get; set; }
        public string windSpeedDesc { get; set; }
    
        public virtual City City { get; set; }
    }
}
