//
//  WeatherTextBuilder.swift
//  DatWeatherDoe
//
//  Created by Inder Dhir on 1/15/22.
//  Copyright © 2022 Inder Dhir. All rights reserved.
//

final class WeatherTextBuilder {
    
    struct Options {
        let isWeatherConditionAsTextEnabled: Bool
        let temperatureOptions: TemperatureTextBuilder.Options
        let isShowingHumidity: Bool
        let isShowingRise: Bool
        let isShowingSet: Bool
        let isUsing24Hr: Bool
    }
    
    private let response: WeatherAPIResponse
    private let options: Options
    private let logger: DatWeatherDoeLoggerType
    
    init(
        response: WeatherAPIResponse,
        options: Options,
        logger: DatWeatherDoeLoggerType
    ) {
        self.response = response
        self.options = options
        self.logger = logger
    }
    
    func build() -> String {
        let finalString = buildWeatherConditionAsText() |>
        appendTemperatureAsText |>
        appendHumidityText |>
        appendRiseText |>
        appendSetText

        return finalString
    }
    
    private func buildWeatherConditionAsText() -> String? {
        guard options.isWeatherConditionAsTextEnabled else { return nil }
        
        let weatherCondition = WeatherConditionBuilder(response: response).build()
        return WeatherConditionTextMapper().map(weatherCondition)
    }
    
    private func appendTemperatureAsText(initial: String?) -> String {
        TemperatureTextBuilder(
            initial: initial,
            response: response,
            options: options.temperatureOptions
        ).build()
    }
    
    private func appendHumidityText(initial: String) -> String {
        guard options.isShowingHumidity else { return initial }
        
        return HumidityTextBuilder(
            initial: initial,
            humidity: response.humidity,
            logger: logger
        ).build()
    }

    private func appendRiseText(initial: String) -> String {
        guard options.isShowingRise else { return initial }

        return RiseSetTextBuilder(
            initial: initial,
            sunrise: response.sunrise,
            use24Hr: self.options.isUsing24Hr
        ).build()
    }

    private func appendSetText(initial: String) -> String {
        guard options.isShowingSet else { return initial }

        return RiseSetTextBuilder(
            initial: initial,
            sunset: response.sunset,
            use24Hr: self.options.isUsing24Hr
        ).build()
    }
}
