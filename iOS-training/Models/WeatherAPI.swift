//
//  WeatherAPI.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/09/27.
//

import Foundation
import SwiftUI
protocol WeatherAPI {
    func fetchWeatherCondition(in area: String, at date: Date) -> Result<WeatherDateTemperature, Error>
}