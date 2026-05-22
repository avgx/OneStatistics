import Foundation
import RequestResponse

private let hostsPrefix = "hosts/"

/// API for retrieving stream statistics (`/statistics`).
public enum StatisticsApi {
    /// Endpoint: `GET /statistics/{accessPoint}` — legacy VMS.
    ///
    /// The path must not include the `hosts/` prefix; it is stripped automatically when present.
    public static func statistics(for id: AccessPoint) -> Request<StreamStatistics> {
        let pathID = id.hasPrefix(hostsPrefix) ? String(id.dropFirst(hostsPrefix.count)) : id
        return Request(path: "statistics/\(pathID)", method: .get)
    }

    /// Endpoint: `POST /statistics` — recommended batch request.
    ///
    /// Body: JSON array of access points. The `hosts/` prefix is added automatically when missing.
    /// Accepts at most ~200 access points per request; split larger lists on the client side.
    public static func statistics(for ids: [AccessPoint]) -> Request<StreamStatisticResponse> {
        precondition(ids.count <= 200, "POST /statistics accepts at most 200 access points per request")
        let normalizedIDs = ids.map { id in
            id.hasPrefix(hostsPrefix) ? id : hostsPrefix + id
        }
        let encoder = JSONEncoder()
        encoder.outputFormatting = .withoutEscapingSlashes
        let body = try? encoder.encode(normalizedIDs)
        return Request(path: "statistics", method: .post, body: body)
    }
}
