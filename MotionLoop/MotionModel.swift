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
	private var accelLog: [(x: Double, y: Double, z: Double, timestamp: TimeInterval)] = []
	private var trialNumber: Int = 0
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
		createAndShareFile()
		accelLog.removeAll()
		trialNumber += 1
	}
	private func createAndShareFile() {
		if accelLog.isEmpty { return }
		let fileName = "trial\(trialNumber).csv"
		
		if let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName) {
			
			var content = "x,y,z,timestamp\n"
			for accelEntry in accelLog {
				let x = accelEntry.x
				let y = accelEntry.y
				let z = accelEntry.z
				let timestamp = accelEntry.timestamp
				content.append("\(x),\(y),\(z),\(timestamp)\n")
			}
			
			do {
				try content.write(to: fileURL, atomically: true, encoding: .utf8)
				// Sharing
				let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
				UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
			} catch {
				print("Error writing to file: \(error)")
			}
		}
	}
	private func timer() -> Timer {
		return Timer(fire: Date(), interval: (1/6), repeats: true) { timer in
			if !self.status.active { timer.invalidate() }
			if let data = self.motionManager.deviceMotion {
				let x = data.userAcceleration.x.truncate(places: 3)
				let y = data.userAcceleration.y.truncate(places: 3)
				let z = data.userAcceleration.z.truncate(places: 3)
				let timestamp = data.timestamp
				self.accelLog.append((x, y, z, timestamp))
				self.handleData(x, y, z)
			}
		}
	}
	private func handleData(_ x: Double, _ y: Double, _ z: Double) {
		self.accelData = (x, y, z)
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
