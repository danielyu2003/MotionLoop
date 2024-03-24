//
//  MotionModel.swift
//  MotionLoop
//
//  Created by Daniel Yu on 3/18/24.
//

import CoreMotion
import UIKit

@Observable class Motion {
	private let manager = CMMotionManager()
	private var available: Bool { manager.isDeviceMotionAvailable }
	private var active: Bool { manager.isDeviceMotionActive }
	private(set) var accelData: (x: Double, y: Double, z: Double)? = nil
	var thresholds: (xThreshold: Double, yThreshold: Double, zThreshold: Double) = (0.0,0.0,0.0)
	func startDeviceMotion() {
		if available && !active {
			manager.deviceMotionUpdateInterval = 1/6
			manager.showsDeviceMovementDisplay = true
			manager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
			RunLoop.current.add(timer(), forMode: RunLoop.Mode.default)
		}
	}
	func stopDeviceMotion() {
		manager.stopDeviceMotionUpdates()
		accelData = nil
	}
	private func timer() -> Timer {
		return Timer(fire: Date(), interval: (1/6), repeats: true) { timer in
			if !self.active { timer.invalidate() }
			if let data = self.manager.deviceMotion {
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
		if abs(x) > self.thresholds.xThreshold && self.thresholds.xThreshold != 0.0  {
			UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
		}
		if abs(y) > self.thresholds.yThreshold && self.thresholds.yThreshold != 0.0  {
			UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
		}
		if abs(z) > self.thresholds.zThreshold && self.thresholds.zThreshold != 0.0  {
			UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
		}
	}
}
