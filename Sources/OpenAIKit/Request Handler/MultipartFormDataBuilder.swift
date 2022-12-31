import Foundation

struct MultipartFormDataBuilder {
    private let boundary: String
    private var httpBody = NSMutableData()
    
    init(boundary: String = UUID().uuidString) {
        self.boundary = boundary
    }
        
    func addTextField(named name: String, value: String) {
        httpBody.append(textFormField(named: name, value: value))
    }
    
    private func textFormField(named name: String, value: String) -> Data {
        var fieldString = Data("--\(boundary)\r\n".utf8)
        fieldString += Data("Content-Disposition: form-data; name=\"\(name)\"\r\n".utf8)
        fieldString += Data("Content-Type: text/plain; charset=ISO-8859-1\r\n".utf8)
        fieldString += Data("\r\n".utf8)
        fieldString += Data("\(value)\r\n".utf8)
        
        return fieldString
    }
    
    func addDataField(fieldName: String, fileName: String, data: Data, mimeType: String) {
        httpBody.append(
            dataFormField(
                fieldName: fieldName,
                fileName:fileName,
                data: data,
                mimeType: mimeType
            )
        )
    }
    
    private func dataFormField(
        fieldName: String,
        fileName: String,
        data: Data,
        mimeType: String
    ) -> Data {
        
        var fieldData = Data("--\(boundary)\r\n".utf8)
        
        fieldData += Data("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".utf8)
        fieldData += Data("Content-Type: \(mimeType)\r\n".utf8)
        fieldData += Data("\r\n".utf8)
        fieldData += data
        fieldData += Data("\r\n".utf8)
        return fieldData
    }
    
    func build() -> Data {
        httpBody.append(Data("--\(boundary)--".utf8))
        return httpBody as Data
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
