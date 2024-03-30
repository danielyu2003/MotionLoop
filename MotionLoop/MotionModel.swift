//
//  MotionModel.swift
//  MotionLoop
//
//  Created by Daniel Yu on 3/18/24.
//

import UIKit
import Foundation
import CoreMotion

@Observable class Motion {
	private let motionManager = CMMotionManager()
	private let fileManager = FileManager.default
	private var status: (available: Bool, active: Bool) {(
		motionManager.isDeviceMotionAvailable,
		motionManager.isDeviceMotionActive
	)}
	private(set) var accelData: (x: Double, y: Double, z: Double)? = nil
	var thresholds: (xThreshold: Double, yThreshold: Double, zThreshold: Double) = (0.0,0.0,0.0)
	func startDeviceMotion() {
		if status.available && !status.active {
			motionManager.deviceMotionUpdateInterval = 1/6
			motionManager.showsDeviceMovementDisplay = true
			motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
			RunLoop.current.add(timer(), forMode: RunLoop.Mode.default)
		}
	}
	func stopDeviceMotion() {
		motionManager.stopDeviceMotionUpdates()
		accelData = nil
		saveToFile()
	}
	private func saveToFile() {
		let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
		let fileURL = URL(filePath: "myfile", relativeTo: documentsURL).appendingPathComponent("txt")
		let myString = "Saving data with FileManager is easy!"
		let data = myString.data(using: .utf8)!
		do {
			try data.write(to: fileURL)
			print("File saved: \(fileURL.absoluteURL)")
		} catch {
			print(error.localizedDescription)
		}
	}
	private func timer() -> Timer {
		return Timer(fire: Date(), interval: (1/6), repeats: true) { timer in
			if !self.status.active { timer.invalidate() }
			if let data = self.motionManager.deviceMotion {
				let x = data.userAcceleration.x
				let y = data.userAcceleration.y
				let z = data.userAcceleration.z
				self.handleAccelData(x, y, z)
			}
		}
	}
	private func handleAccelData(_ x: Double, _ y: Double, _ z: Double) {
		// Use motion data below
		// include frame number and timestamp?
		self.accelData = (x, y, z)
		// DEBUG
		feedbackThreshold(val: x, thresholdVal: self.thresholds.xThreshold)
		feedbackThreshold(val: y, thresholdVal: self.thresholds.yThreshold)
		feedbackThreshold(val: z, thresholdVal: self.thresholds.zThreshold)
	}
	private func feedbackThreshold(val: Double, thresholdVal: Double) {
		if abs(val) > thresholdVal && thresholdVal != 0.0 {
			UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
		}
	}
}
