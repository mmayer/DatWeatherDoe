//
//  ConfigureViewModel.swift
//  DatWeatherDoe
//
//  Created by Inder Dhir on 3/20/22.
//  Copyright © 2022 Inder Dhir. All rights reserved.
//

import Combine
import Foundation
import LaunchAtLogin

final class ConfigureViewModel: ObservableObject {
    
    @Published var temperateUnit: TemperatureUnit
    @Published var weatherSource: WeatherSource

    @Published private(set) var weatherSourceTextHint = ""
    @Published private(set) var weatherSourceTextFieldDisabled = false
    @Published private(set) var weatherSourcePlaceholder = ""

    @Published var weatherSourceText = ""
    @Published var refreshInterval: RefreshInterval
    @Published var isShowingWeatherIcon: Bool
    @Published var isShowingHumidity: Bool
    @Published var isRoundingOffData: Bool
    @Published var isWeatherConditionAsTextEnabled: Bool
    @Published var launchAtLogin = LaunchAtLogin.observable
    
    private let configManager: ConfigManagerType
    private weak var popoverManager: PopoverManager?
    
    init(configManager: ConfigManagerType, popoverManager: PopoverManager?) {
        self.configManager = configManager
        self.popoverManager = popoverManager
        
        temperateUnit = TemperatureUnit(rawValue: configManager.temperatureUnit)!
        weatherSource = WeatherSource(rawValue: configManager.weatherSource)!
       
        switch configManager.refreshInterval {
        case 300: refreshInterval = .fiveMinutes
        case 900: refreshInterval = .fifteenMinutes
        case 1800: refreshInterval = .thirtyMinutes
        case 3600: refreshInterval = .sixtyMinutes
        default: refreshInterval = .oneMinute
        }
        
        isShowingWeatherIcon = configManager.isShowingWeatherIcon
        isShowingHumidity = configManager.isShowingHumidity
        isRoundingOffData = configManager.isRoundingOffData
        isWeatherConditionAsTextEnabled = configManager.isWeatherConditionAsTextEnabled
        
        updateWeatherSource()
    }

    func closeConfigWithoutSaving() {
        // Configuration change was aborted, so re-initialize the UI variables
        // from the existing configuration.
        isShowingWeatherIcon = configManager.isShowingWeatherIcon
        isShowingHumidity = configManager.isShowingHumidity
        isRoundingOffData = configManager.isRoundingOffData
        popoverManager?.togglePopover(nil)
    }
    
    func saveAndCloseConfig() {
        saveConfig()
        popoverManager?.togglePopover(nil)
    }
    
    private func updateWeatherSource() {
        weatherSourceTextHint = weatherSource.textHint
        weatherSourceTextFieldDisabled = weatherSource == .location
        if weatherSource == .location {
            weatherSourceText = ""
        }
        weatherSourcePlaceholder = weatherSource.placeholder
    }
    
    private func saveConfig() {
        let configCommitter = ConfigurationCommitter(configManager: configManager)

        // Store the current configuration
        configManager.isShowingWeatherIcon = isShowingWeatherIcon
        configManager.isShowingHumidity = isShowingHumidity
        configManager.isRoundingOffData = isRoundingOffData
        configManager.isWeatherConditionAsTextEnabled = isWeatherConditionAsTextEnabled

        configCommitter.setWeatherSource(weatherSource, sourceText: weatherSourceText)
        configCommitter.setOtherOptionsForConfig(
            refreshInterval: refreshInterval,
            isShowingHumidity: isShowingHumidity,
            isRoundingOffData: isRoundingOffData,
            isWeatherConditionAsTextEnabled: isWeatherConditionAsTextEnabled
        )
    }
}
