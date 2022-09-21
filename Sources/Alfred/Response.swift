import Foundation

public struct Response: Encodable {
    var items: [Item]
    let shouldSort: Bool

    public init(items: [Item] = [], shouldSort: Bool = true) {
        self.items = items
        self.shouldSort = shouldSort
    }

    public mutating func append(item: ItemRepresentable) {
        items.append(item.item)
    }

    public mutating func append(contentsOf items: [ItemRepresentable]) {
        self.items.append(contentsOf: items.map { $0.item })
    }

    public mutating func output() throws -> String {
        let json = try Self.makeEncoder(shouldSort: shouldSort).encode(self)
        return String(data: json, encoding: .utf8)!
    }

    static func makeEncoder(shouldSort: Bool = true) -> JSONEncoder {
        let encoder = JSONEncoder()
        var formatting: JSONEncoder.OutputFormatting = [.prettyPrinted]
        if shouldSort {
            formatting.insert(.sortedKeys)
        }
        encoder.outputFormatting = formatting
        return encoder
    }
}
