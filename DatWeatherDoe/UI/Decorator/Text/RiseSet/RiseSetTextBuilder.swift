//
//  RiseSetTextBuilder.swift
//  DatWeatherDoe
//
//  Created by Markus Markus on 4/26/22.
//  Copyright © 2022 Markus Mayer.
//

import Foundation

final class RiseSetTextBuilder {

    private let initial: String
    private let sunset: TimeInterval
    private let sunrise: TimeInterval
    private let use24Hr: Bool
    private let logger: DatWeatherDoeLoggerType

    init(
        initial: String,
        sunset: TimeInterval = 0,
        sunrise: TimeInterval = 0,
        use24Hr: Bool,
        logger: DatWeatherDoeLoggerType
    ) {
        self.initial = initial
        self.sunset = sunset
        self.sunrise = sunrise
        self.use24Hr = use24Hr
        self.logger = logger
    }

    func build() -> String {
        guard let riseSetString = buildRiseSet() else {
            logger.error("Unable to construct riseSet string")

            return initial
        }

        return "\(initial) \(riseSetString)"
    }

    private func buildRiseSet() -> String? {
        var ret: String = ""
        let sunRiseOpt = buildFormattedString(ts: sunrise)
        let sunSetOpt = buildFormattedString(ts: sunset)

        if let sunRiseText = sunRiseOpt {
            ret = "↑\(sunRiseText)"
        }
        if let sunSetText = sunSetOpt {
            ret += "↓\(sunSetText)"
        }

        return ret
    }

    private func buildFormattedString(ts: TimeInterval) -> String? {
        if ts == 0 {
            return nil
        }
        return getDateFormatter().string(from: Date(timeIntervalSince1970: ts))
    }

    private func getDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        // BEWARE: If, under System Preferences -> "Language and Region", the checkbox
        // "24-Hour Time" is ticked, this will return the time in 24 hour format
        // no matter what. In other words, macOS overrides the meaning of format
        // specifiers "h" and "hh" to mean "HH" and format specifier "a" will expand
        // to the empty string ("h:mm a" becomes equivalent to "HH:mm"). The application
        // cannot influence this behaviour. It must be changed in System Preferences.
        formatter.dateFormat = use24Hr ? "HH:mm" : "h:mm a"

        return formatter
    }
}
