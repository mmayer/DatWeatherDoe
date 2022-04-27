//
//  SetRiseTextBuilder.swift
//  DatWeatherDoe
//
//  Created by Markus Markus on 4/26/22.
//  Copyright © 2022 Markus Mayer.
//

import Foundation

final class SetRiseTextBuilder {

    private let initial: String
    private let sunset: TimeInterval
    private let sunrise: TimeInterval
    private let logger: DatWeatherDoeLoggerType

    private let setRiseFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        return formatter
    }()

    init(
        initial: String,
        sunset: TimeInterval,
        sunrise: TimeInterval,
        logger: DatWeatherDoeLoggerType
    ) {
        self.initial = initial
        self.sunset = sunset
        self.sunrise = sunrise
        self.logger = logger
    }

    func build() -> String {
        guard let setRiseString = buildSetRise() else {
            logger.error("Unable to construct setRise string")

            return initial
        }

        return "\(initial) | \(setRiseString)"
    }

    private func buildSetRise() -> String? {
        guard let sunrise = buildFormattedString(ts: sunrise) else { return nil }
        guard let sunset = buildFormattedString(ts: sunset) else { return nil }

        return "\(sunrise)↑  \(sunset)↓"
    }

    private func buildFormattedString(ts: TimeInterval) -> String? {
        return setRiseFormatter.string(from: Date(timeIntervalSince1970: ts))
    }
}
