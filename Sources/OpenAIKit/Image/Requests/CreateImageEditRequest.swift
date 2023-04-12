import AsyncHTTPClient
import NIOHTTP1
import Foundation

struct CreateImageEditRequest: Request {
    let method: HTTPMethod = .POST
    let path = "/v1/images/edits"
    let body: Data?
    private let boundary = UUID().uuidString

    var headers: HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: "multipart/form-data; boundary=\(boundary)")
        return headers
    }
    
    init(
        image: Data,
        mask: Data?,
        prompt: String,
        n: Int,
        size: Image.Size,
        user: String?
    ) throws {
        
        let builder = MultipartFormDataBuilder(boundary: boundary)
        
        builder.addDataField(
            fieldName:  "image",
            fileName: "image.png",
            data: image,
            mimeType: "image/png"
        )
        
        if let mask = mask {
            builder.addDataField(
                fieldName:  "mask",
                fileName: "mask.png",
                data: mask,
                mimeType: "image/png"
            )
        }
        
        builder.addTextField(named: "prompt", value: prompt)
        builder.addTextField(named: "n", value: "\(n)")
        builder.addTextField(named: "size", value: size.rawValue)
        
        if let user = user {
            builder.addTextField(named: "user", value: user)
        }

        self.body = builder.build()
    }
}
