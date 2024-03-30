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
			.fixedSize()
			.scaledToFit()
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
			VStack {
				ThresholdSlider(name: "X", threshold: $motion.thresholds.xThreshold)
				ThresholdSlider(name: "Y", threshold: $motion.thresholds.yThreshold)
				ThresholdSlider(name: "Z", threshold: $motion.thresholds.zThreshold)
			}
        }
        .padding()
    }
	private func stringify(_ data: (x: Double, y: Double, z: Double)?) -> String {
		return String(reflecting: data)
	}
}

struct ThresholdSlider: View {
	let name: String
	@Binding var threshold: Double
	var body: some View {
		HStack {
			Text(name)
			Slider(
				value: $threshold,
				in: 0...1,
				step: 0.01
			)
		}
		Text(String(threshold.truncate(places: 2)))
	}
}

extension Double {
	func truncate(places : Int)-> Double {
		return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
	}
}

#Preview {
    ContentView()
}
