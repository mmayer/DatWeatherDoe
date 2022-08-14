//
//  RiseSetTextBuilder.swift
//  DatWeatherDoe
//
//  Created by Markus Markus on 7/26/22.
//  Copyright © 2022 Markus Mayer.
//

import Foundation

final class RiseSetTextBuilder {

    private let initial: String
    private let sunset: TimeInterval
    private let sunrise: TimeInterval
    private let use24Hr: Bool

    private let upArrowStr = "⬆"
    private let downArrowStr = "⬇"

    init(
        initial: String = "",
        sunset: TimeInterval = 0,
        sunrise: TimeInterval = 0,
        use24Hr: Bool = false
    ) {
        self.initial = initial
        self.sunset = sunset
        self.sunrise = sunrise
        self.use24Hr = use24Hr
    }

    func build() -> String {
        let riseSetString = buildRiseSet()
        if riseSetString == "" {
            return initial
        }
        return (initial != "") ? "\(initial) \(riseSetString)" : riseSetString
    }

    private func buildRiseSet() -> String {
        var ret: String = ""
        let sunRiseText = buildFormattedString(ts: sunrise)
        let sunSetText = buildFormattedString(ts: sunset)

        if sunRiseText != "" {
            ret = "\(upArrowStr)\(sunRiseText)"
        }
        if sunSetText != "" {
            if ret != "" {
                ret += " "
            }
            ret += "\(downArrowStr)\(sunSetText)"
        }

        return ret
    }

    private func buildFormattedString(ts: TimeInterval) -> String {
        if ts == 0 {
            return ""
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
