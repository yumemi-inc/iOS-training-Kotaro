//
//  LayoutPrototype.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/07/10.
//

import SwiftUI
import YumemiWeather

struct LayoutPrototype: View {
    @State private var weatherFetchResult: Result<Weather, Error>?

    var errorAlertIsPresented: Bool {
        switch weatherFetchResult {
        case .failure:
            return true
        default:
            return false
        }
    }

    var body: some View {
        GeometryReader { geometry in

            let imageSideLength = geometry.size.width / 2
            let temperatureWidth = geometry.size.width / 4
            let buttonWidth = geometry.size.width / 4

            VStack(alignment: .center, spacing: .zero) {
                switch weatherFetchResult {
                case .none:
                    EmptyView()
                case let .success(weather):
                    weather.icon
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(weather.color)
                        .frame(width: imageSideLength,
                               height: imageSideLength)
                case .failure:
                    Image(systemName: "exclamationmark.square.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.gray)
                        .frame(width: imageSideLength,
                               height: imageSideLength)
                }

                HStack(spacing: .zero) {
                    Text("--")
                        .foregroundStyle(.blue)
                        .frame(width: temperatureWidth)
                    Text("--")
                        .foregroundStyle(.red)
                        .frame(width: temperatureWidth)
                }
                .padding(.bottom, 80)

                HStack(spacing: .zero) {
                    Button("Close") {}
                        .frame(width: buttonWidth)
                    Button("Reload") {
                        weatherFetchResult = self.fetchWeatherCondition(at: "tokyo")
                    }
                    .frame(width: buttonWidth)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .alert("Error", isPresented: Binding(
            get: { errorAlertIsPresented },
            set: { isPresented in
                if !isPresented { weatherFetchResult = nil }
            }
        )) { /* Buttons */ } message: {
            if case let .failure(error) = weatherFetchResult {
                Text(error.localizedDescription)
            }
        }
    }

    func fetchWeatherCondition(at area: String) -> Result<Weather, Error> {
        let fetchedResult = Result<String, Error> { try YumemiWeather.fetchWeatherCondition(at: area) }
        return fetchedResult.flatMap { weather in
            switch weather {
            case "sunny":
                return .success(.sunny)
            case "cloudy":
                return .success(.cloudy)
            case "rainy":
                return .success(.rainy)
            default:
                return .failure(YumemiWeatherError.unknownError)
            }
        }
    }
}

#Preview {
    LayoutPrototype()
}
