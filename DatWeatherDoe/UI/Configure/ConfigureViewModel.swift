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
    
    // Sorry US, but the world at large is using Celsius. Let's start with that.
    @Published var temperateUnit: TemperatureUnit = .celsius
    @Published var weatherSource: WeatherSource = .location

    @Published private(set) var weatherSourceTextHint = ""
    @Published private(set) var weatherSourceTextFieldDisabled = false
    @Published private(set) var weatherSourcePlaceholder = ""

    @Published var weatherSourceText = ""
    @Published var refreshInterval: RefreshInterval = .thirtyMinutes
    @Published var isShowingWeatherIcon: Bool = false
    @Published var isShowingHumidity: Bool = false
    @Published var isRoundingOffData: Bool = false
    @Published var isWeatherConditionAsTextEnabled: Bool = false
    @Published var launchAtLogin = LaunchAtLogin.observable
    
    private let configManager: ConfigManagerType
    private weak var popoverManager: PopoverManager?
    
    init(configManager: ConfigManagerType, popoverManager: PopoverManager?) {
        self.configManager = configManager
        self.popoverManager = popoverManager
        
        initalizeVariables()
        updateWeatherSource()
    }

    func closeConfigWithoutSaving() {
        // The user may have changed the UI elements, so after aborting we
        // need to re-initialize them to match the actual configuration which
        // did not change.
        initalizeVariables()
        popoverManager?.togglePopover(nil)
    }

    func saveAndCloseConfig() {
        saveConfig()
        popoverManager?.togglePopover(nil)
    }

    private func initalizeVariables() {
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
