import Foundation

protocol JSONable {
    var json: [String: Any] { get }
}

public class Response: JSONable {
    private var items = [Item]()
    
    public init() {}
    
    public func addItem(item: Itemable) {
        items.append(item.item)
    }
    
    var json: [String: Any] {
        return ["items": items.map{ $0.json } ]
    }
    
    public func toJSON() -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
            return ""
        }
        return String(data: data, encoding: String.Encoding.utf8) ?? ""
    }
}

public protocol Itemable {
    var item: Item { get }
}

public struct Item: JSONable, Itemable {
    
    public enum ItemType {
        case file, skipCheck
        
        var key: String {
            switch self {
            case .file: return "file"
            case .skipCheck: return "file:skipcheck"
            }
        }
    }
    
    public init(title: String, subtitle: String, arg: String? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.arg = arg
    }
    
    public var uid: String?
    public var title: String
    public var subtitle: String
    public var arg: String?
    public var icon: Icon?
    public var valid = true
    public var autocomplete: String?
    public var type: Item.ItemType?
    public var cmd: Modifier?
    public var alt: Modifier?
    
    var json: [String : Any] {
        var j = [String: Any]()
        j["uid"] = uid
        j["title"] = title
        j["subtitle"] = subtitle
        j["arg"] = arg
        j["icon"] = icon?.json
        if !valid { j["valid"] = valid }
        j["autocomplete"] = autocomplete
        j["type"] = type?.key
        
        var mod: [String: Any]?
        if cmd != nil || alt != nil { mod = [String: Any]() }
        mod?["cmd"] = cmd?.json
        mod?["alt"] = alt?.json
        j["mod"] = mod
        
        return j
    }
    
    public var item: Item {
        return self
    }
}

public struct Modifier: JSONable {
    public var valid = true
    var arg: String
    var subtitle: String?
    
    public init(arg: String, subtitle: String? = nil) {
        self.arg = arg
        self.subtitle = subtitle
    }
    
    var json: [String : Any] {
        var j = [String: Any]()
        j["subtitle"] = subtitle
        j["arg"] = arg
        if !valid { j["valid"] = valid }
        return j
    }
}


public struct Icon: JSONable {
    public enum IconType: String {
        case fileicon, filetype
    }
    
    var type: Icon.IconType?
    var path: String
    
    public init(path: String, type: Icon.IconType? = nil) {
        self.path = path
        self.type = type
    }
    
    var json: [String : Any] {
        var j = [String: Any]()
        j["path"] = path
        j["type"] = type?.rawValue
        return j
    }
}
