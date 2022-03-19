import Foundation

@propertyWrapper
public struct FileStorage<T: Codable> {
    var value: T?

    let directory: FileManager.SearchPathDirectory
    let fileName: String

    public init(directory: FileManager.SearchPathDirectory, fileName: String) {
        value = try? FileHelper.loadJSON(from: directory, fileName: fileName)
        self.directory = directory
        self.fileName = fileName
    }

    public var wrappedValue: T? {
        set {
            value = newValue
            if let value = newValue {
                try? FileHelper.writeJSON(value, to: directory, fileName: fileName)
            } else {
                try? FileHelper.delete(from: directory, fileName: fileName)
            }
        }

        get { value }
    }
}
