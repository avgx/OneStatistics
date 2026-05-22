import Foundation

extension Array {
    /// Splits an array into chunks of a given `chunkSize`.
    func chunked(into chunkSize: Int) -> [[Element]] {
        guard chunkSize > 0 else { return [] }
        return stride(from: 0, to: count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, count)])
        }
    }
}

