//
//  ContentView.swift
//  MotionLoop
//
//  Created by Daniel Yu on 3/5/24.
//

import SwiftUI

struct ContentView: View {
	private var motion = Motion()
    var body: some View {
        VStack {
			Text(String(reflecting: motion.accelData))
			Button("Start") {
				motion.startDeviceMotion()
			}
			Button("Stop") {
				motion.stopDeviceMotion()
			}
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
