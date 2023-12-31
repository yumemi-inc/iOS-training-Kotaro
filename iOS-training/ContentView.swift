//
//  ContentView.swift
//  iOS-training
//
//  Created by 松本 幸太郎 on 2023/07/10.
//

import SwiftUI

struct ContentView: View {
    init(weatherFetchManager: FetchTaskManager<WeatherDateTemperature>) {
        _weatherFetchManager = State(initialValue: weatherFetchManager)
    }

    @State private var weatherFetchManager: FetchTaskManager<WeatherDateTemperature>

    private var weatherInfo: WeatherDateTemperature? {
        weatherFetchManager.fetched
    }

    private var minTemperature: String {
        (weatherInfo?.minTemperature).map(String.init) ?? "--"
    }

    private var maxTemperature: String {
        (weatherInfo?.maxTemperature).map(String.init) ?? "--"
    }

    private var isFetching: Bool {
        weatherFetchManager.isFetching
    }

    private var error: Error? {
        weatherFetchManager.error
    }

    private var errorMessage: String {
        error?.localizedDescription ?? "__"
    }

    var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            // Setting WeatherIcon to be square
            Color.clear
                .aspectRatio(1, contentMode: .fit)
                .containerRelativeFrame(.horizontal) { length, _ in
                    length / 2
                }
                .overlay {
                    ZStack {
                        WeatherIcon(weatherInfo?.weatherCondition)
                        if isFetching {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(.ultraThinMaterial)
                                }
                        }
                    }
                }

            HStack(spacing: .zero) {
                Text(minTemperature)
                    .foregroundStyle(.blue)
                    .containerRelativeFrame(.horizontal) { length, _ in
                        length / 4
                    }

                Text(maxTemperature)
                    .foregroundStyle(.red)
                    .containerRelativeFrame(.horizontal) { length, _ in
                        length / 4
                    }
            }
            .padding(.bottom, 80)

            HStack(spacing: .zero) {
                Button("Close") {
                    /* https://github.com/yumemi-inc/ios-training/blob/main/Documentation/VC_Lifecycle.md
                     SwiftUIで「UIViewControllerのライフサイクルの動作を確認する」ことに相当するような実装が思いつかなかったためスキップ */
                }
                .containerRelativeFrame(.horizontal) { length, _ in
                    length / 4
                }
                Button("Reload") {
                    weatherFetchManager.fetch()
                }
                .containerRelativeFrame(.horizontal) { length, _ in
                    length / 4
                }
            }
        }
        .task {
            weatherFetchManager.fetch()
        }
        .alert("Error", isPresented: .constant(error != nil)) {
            Button("YES") { weatherFetchManager.reset() }
        } message: {
            Text(errorMessage)
        }
    }
}

#Preview {
    let fetchingMethod = { try await WeatherAPIStub().fetchWeatherCondition(in: "tokyo", at: Date()) }
    return ContentView(weatherFetchManager: FetchTaskManager(for: fetchingMethod))
}
