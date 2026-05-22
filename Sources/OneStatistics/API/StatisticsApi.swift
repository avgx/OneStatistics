import Foundation
import RequestResponse

//TODO: описание API тут https://docs.itvgroup.ru/confluence/spaces/next46ru/pages/198799208/Статистика+видеокамер нужно проверить передаваемые параметры на валидность или подправить до требуемого состояния и описать в /// в методе что нужно передавать.

/// API for retrieving stream statistics (Axxon Next).
public enum StatisticsApi {
    /// Request for a single stream's statistics.
    public typealias StreamRequest = Request<StreamStatisticResponse>
    
    /// Creates a request to fetch statistics for a single stream.
    /// - Parameters:
    ///   - id: AccessPoint in `hosts/...` format
    /// - Returns: Request to fetch stream statistics
    public static func statistics(for id: AccessPoint) -> Request<StreamStatisticResponse> {
        precondition(!id.starts(with: "hosts"), "AccessPoint must not start with 'hosts/")
        return Request(path: "statistics/\(id)", method: .get)
    }
    
    /// Creates a request to fetch statistics for a single stream.
    /// - Parameters:
    ///   - id: AccessPoint in `hosts/...` format
    /// - Returns: Request to fetch stream statistics
    public static func statistics(for ids: [AccessPoint]) -> Request<StreamStatisticResponse> {
        precondition(ids.allSatisfy({ $0.starts(with: "hosts") }), "AccessPoint's in ids must start with 'hosts/")
        let body = try? JSONEncoder().encode(ids)
        return Request(path: "/statistics", method: .post, body: body)
        /* response
         {
         "hosts/DEMOSERVER/DeviceIpint.1/SourceEndpoint.video:0:0" : {
         "bitrate" : 1085025,
         "fps" : 19.899177551269531,
         "height" : 720,
         "mediaType" : 2,
         "streamType" : 875967048,
         "width" : 1280
         },
         ...
         }
         */
    }
}

