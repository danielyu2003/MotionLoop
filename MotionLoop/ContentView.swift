//
//  ContentView.swift
//  MotionLoop
//
//  Created by Daniel Yu on 3/5/24.
//

import SwiftUI

struct ContentView: View {
	@Bindable private var motion = Motion()
	@State var playing = false
    var body: some View {
        VStack {
			Spacer()
			Text(stringify(motion.accelData))
			.font(.title)
			Spacer()
			Group {
				if playing {
					Button("Stop", systemImage: "stop.circle") {
						motion.stopDeviceMotion()
						playing.toggle()
					}
				}
				else {
					Button("Start", systemImage: "play.circle") {
						motion.startDeviceMotion()
						playing.toggle()
					}
				}
			}
			.labelStyle(.iconOnly)
			.font(.largeTitle)
			Spacer()
			HStack {
				Text("X")
				Slider(
					value: $motion.thresholds.xThreshold,
					in: 0...1,
					step: 0.01
				)
			}
			Text(String(motion.thresholds.xThreshold))
			HStack {
				Text("Y")
				Slider(
					value: $motion.thresholds.yThreshold,
					in: 0...1,
					step: 0.01
				)
			}
			Text(String(motion.thresholds.yThreshold))
			HStack {
				Text("Z")
				Slider(
					value: $motion.thresholds.zThreshold,
					in: 0...1,
					step: 0.01
				)
			}
			Text(String(motion.thresholds.zThreshold))
        }
        .padding()
    }
	private func stringify(_ data: (x: Double, y: Double, z: Double)?) -> String {
		return String(reflecting: data)
	}
}

#Preview {
    ContentView()
}
