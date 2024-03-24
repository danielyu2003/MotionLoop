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
	var threshold: Double = 0
	private(set) var accelData: (x: Double, y: Double, z: Double)? = nil
	func startDeviceMotion() {
		if available && !active {
			manager.deviceMotionUpdateInterval = 1/6
			manager.showsDeviceMovementDisplay = true
			manager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
			let timer = Timer(fire: Date(), interval: (1/6), repeats: true) { timer in
				if !self.active { timer.invalidate() }
				if let data = self.manager.deviceMotion {
					// include frame number and timestamp?
					let x = data.userAcceleration.x
					let y = data.userAcceleration.y
					let z = data.userAcceleration.z
					self.accelData = (x, y, z)
					// DEBUG
					if x > self.threshold && x != 0  {
						UIImpactFeedbackGenerator(style: .medium).impactOccurred()
					}
				}
			}
			RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
		}
	}
	func stopDeviceMotion() {
		manager.stopDeviceMotionUpdates()
		accelData = nil
	}
	func setThreshhold(at value: Double) {
		threshold = value
	}
}
