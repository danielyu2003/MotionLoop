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
			Spacer()
			AccelerationView(data: motion.accelData)
				.font(.title)
				.fixedSize()
				.scaledToFit()
			Spacer()
			PlayButton(motion: motion)
				.font(.largeTitle)
				.labelStyle(.iconOnly)
			Spacer()
			VStack {
				ThresholdSlider(name: "X", threshold: $motion.thresholds.xThreshold)
				ThresholdSlider(name: "Y", threshold: $motion.thresholds.yThreshold)
				ThresholdSlider(name: "Z", threshold: $motion.thresholds.zThreshold)
			}
        }
        .padding()
    }
}

struct PlayButton: View {
	@State var playing = false
	var motion: Motion
	var body: some View {
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

struct AccelerationView: View {
	var data: (x: Double, y: Double, z: Double)?
	var body: some View {
		if let data {
			VStack {
				Text("x: \(data.x)")
				Text("y: \(data.y)")
				Text("z: \(data.z)")
			}
		}
		else {
			Text("Accelerometer not active")
		}
	}
}

extension Double {
	func truncate(places: Int) -> Double {
		return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
	}
}

#Preview {
    ContentView()
}
