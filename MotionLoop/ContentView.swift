//
//  ContentView.swift
//  MotionLoop
//
//  Created by Daniel Yu on 3/5/24.
//

import SwiftUI

struct ContentView: View {
	@Bindable private var motion = Motion()
    var body: some View {
        VStack {
			Text(String(reflecting: motion.accelData))
			Spacer()
			HStack {
				Button("Start") {
					motion.startDeviceMotion()
				}
				Spacer()
				Button("Stop") {
					motion.stopDeviceMotion()
				}
			}
			Spacer()
			Slider(
				value: $motion.threshold,
				in: 0...1,
				step: 0.01
			)
			Text(String(motion.threshold))
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
