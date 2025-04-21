//
//  CosmonautWidgetExtensionBundle.swift
//  CosmonautWidgetExtension
//
//  Created by Cyril Cermak on 21.04.25.
//

import WidgetKit
import SwiftUI

@main
struct CosmonautWidget: Widget {
    let kind: String = "CosmonautWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CosmonautWidgetProvider()) { entry in
            CosmonautWidgetView(entry: entry)
        }
        .configurationDisplayName("Cosmonaut Widget")
        .description("Monitor the cosmonaut's health and spacesuit status.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
