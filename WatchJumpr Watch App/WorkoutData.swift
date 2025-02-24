import Foundation
import SwiftData

@Model
final class WorkoutData {
    var jumpCount: Int
    var duration: TimeInterval
    var date: Date

    init(jumpCount: Int, duration: TimeInterval, date: Date = Date()) {
        self.jumpCount = jumpCount
        self.duration = duration
        self.date = date
    }
}
