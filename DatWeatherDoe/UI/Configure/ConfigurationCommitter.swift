//
//  ConfigurationCommitter.swift
//  DatWeatherDoe
//
//  Created by Inder Dhir on 1/17/22.
//  Copyright © 2022 Inder Dhir. All rights reserved.
//

final class ConfigurationCommitter {
    
    private let configManager: ConfigManagerType
    
    init(configManager: ConfigManagerType) {
        self.configManager = configManager
    }
    
    func setWeatherSource(_ source: WeatherSource, sourceText: String) {
        configManager.weatherSource = source.rawValue
        configManager.weatherSourceText = source == .location ? nil : sourceText
    }
    
    func setOtherOptionsForConfig(
        refreshInterval: RefreshInterval,
        isShowingHumidity: Bool,
        isShowingSetRise: Bool,
        isRoundingOffData: Bool,
        isWeatherConditionAsTextEnabled: Bool
    ) {
        configManager.refreshInterval = refreshInterval.rawValue
        configManager.isShowingHumidity = isShowingHumidity
        configManager.isShowingSetRise = isShowingSetRise
        configManager.isRoundingOffData = isRoundingOffData
        configManager.isWeatherConditionAsTextEnabled = isWeatherConditionAsTextEnabled
    }
}
