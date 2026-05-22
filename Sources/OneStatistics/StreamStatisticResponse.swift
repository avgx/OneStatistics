import Foundation

public struct StreamStatisticResponse : Decodable, Sendable {
    public let streams: [AccessPoint: StatisticsStream]
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            let s = try container.decode([AccessPoint: StatisticsStream?].self)
            //print(s)
            self.streams = s
                .filter({ $0.value?.isValidVideo ?? false })
                .map({ (key: $0.key, value: $0.value! )})
                .reduce(into: [:], { (r, kv) in
                    r[kv.key] = kv.value
                })
        } catch {
            streams = [:]
        }
        
    }
}
