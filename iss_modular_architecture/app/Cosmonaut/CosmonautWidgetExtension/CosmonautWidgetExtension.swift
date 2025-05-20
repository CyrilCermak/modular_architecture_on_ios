//
//  CosmonautWidgetExtension.swift
//  CosmonautWidgetExtension
//
//  Created by Cyril Cermak on 21.04.25.
//

import WidgetKit
import SwiftUI
import Intents
import ISSRadio
import ISSCosmonautService
import ISSSpacesuitService

struct CosmonautWidgetEntry: TimelineEntry {
    let date: Date
    
    // Cosmonaut health data
    let bloodPressure: String
    let bloodOxygen: String
    let heartRate: String
    let bodyTemperature: String
    
    // Spacesuit data
    let outsideTemperature: String
    let charge: String
    let pressure: String
}

struct CosmonautWidgetProvider: TimelineProvider {
    private let cosmonautHealthService = CosmonautHealthService(radio: RadioService())
    private let spacesuitService = SpacesuitService(radio: RadioService())
    
    func placeholder(in context: Context) -> CosmonautWidgetEntry {
        let loading = "Loading..."
        return CosmonautWidgetEntry(date: Date(),
                                    bloodPressure: loading,
                                    bloodOxygen: loading,
                                    heartRate: loading,
                                    bodyTemperature: loading,
                                    outsideTemperature: loading,
                                    charge: loading,
                                    pressure: loading)
    }

    func getSnapshot(in context: Context, completion: @escaping (CosmonautWidgetEntry) -> Void) {
        cosmonautHealthService.startHealthMonitoring()
        spacesuitService.startSpacesuitMonitoring()
        
        let entry = CosmonautWidgetEntry(date: Date(),
                                         bloodPressure: cosmonautHealthService.health.bloodPressure?.level ?? "",
                                         bloodOxygen: cosmonautHealthService.health.bloodOxygen?.level ?? "",
                                         heartRate: cosmonautHealthService.health.heartRate?.level ?? "",
                                         bodyTemperature: cosmonautHealthService.health.bodyTemperature?.level ?? "",
                                         outsideTemperature: spacesuitService.spacesuit.outsideTemperature?.level ?? "",
                                         charge: spacesuitService.spacesuit.charge?.level ?? "",
                                         pressure: spacesuitService.spacesuit.pressure?.level ?? "")
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CosmonautWidgetEntry>) -> Void) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        
        cosmonautHealthService.startHealthMonitoring()
        spacesuitService.startSpacesuitMonitoring()
        
        let entry = CosmonautWidgetEntry(date: Date(),
                                         bloodPressure: cosmonautHealthService.health.bloodPressure?.level ?? "",
                                         bloodOxygen: cosmonautHealthService.health.bloodOxygen?.level ?? "",
                                         heartRate: cosmonautHealthService.health.heartRate?.level ?? "",
                                         bodyTemperature: cosmonautHealthService.health.bodyTemperature?.level ?? "",
                                         outsideTemperature: spacesuitService.spacesuit.outsideTemperature?.level ?? "",
                                         charge: spacesuitService.spacesuit.charge?.level ?? "",
                                         pressure: spacesuitService.spacesuit.pressure?.level ?? "")
        
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        completion(timeline)
    }
}

struct CosmonautWidgetView: View {
    var entry: CosmonautWidgetProvider.Entry

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("Cosmonaut")
                    .font(.headline)
                    .padding(.bottom, 5)
                Text("Heart: \(entry.heartRate)")
                    .font(.subheadline)
                Text("Oxygen: \(entry.bloodOxygen)")
                    .font(.subheadline)
                Text("Blood: \(entry.bloodPressure)")
                    .font(.subheadline)
                Text("Temperature: \(entry.bodyTemperature)")
                    .font(.subheadline)
            }
            .padding()
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Spacesuit")
                    .font(.headline)
                    .padding(.bottom, 5)
                Text("Charge: \(entry.charge)")
                    .font(.subheadline)
                Text("Temperature: \(entry.outsideTemperature)")
                    .font(.subheadline)
                Text("Pressure: \(entry.pressure)")
                    .font(.subheadline)
            }
            .padding()
        }
    }
}

#Preview {
    CosmonautWidgetView(entry: CosmonautWidgetEntry(date: Date(),
                                bloodPressure: "Loading...",
                                bloodOxygen: "Loading...",
                                heartRate: "Loading...",
                                bodyTemperature: "Loading...",
                                outsideTemperature: "Loading...",
                                charge: "Loading...",
                                pressure: "Loading..."))
}
