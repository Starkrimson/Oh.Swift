import Foundation

@propertyWrapper
public struct FileStorage<T: Codable> {
    var value: T?
    
    let directory: FileManager.SearchPathDirectory
    let fileName: String
    
    public init(directory: FileManager.SearchPathDirectory, fileName: String) {
        let url = FileManager.default.urls(for: directory, in: .userDomainMask).first!
        if let data = try? Data(contentsOf: url.appendingPathComponent(fileName)) {
            value = try? JSONDecoder().decode(T.self, from: data)
        }
        self.directory = directory
        self.fileName = fileName
    }

    public var wrappedValue: T? {
        set {
            value = newValue
            if let value = newValue {
                if let url = FileManager.default.urls(for: directory, in: .userDomainMask).first {
                    let data = try? JSONEncoder().encode(value)
                    try? data?.write(to: url.appendingPathComponent(fileName))
                }
            } else {
                guard let url = FileManager.default.urls(for: directory, in: .userDomainMask).first else {
                    return
                }
                try? FileManager.default.removeItem(at: url.appendingPathComponent(fileName))
            }
        }
        
        get { value }
    }
}
