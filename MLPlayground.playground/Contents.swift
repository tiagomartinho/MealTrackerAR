import CreateML
import Foundation

let path = Bundle.main.path(forResource: "books", ofType: "csv")
let bookTable = try MLDataTable(contentsOf: URL(fileURLWithPath: path!))

let builder = try MLClassifier(trainingData: bookTable, targetColumn: "movement")

print(builder.trainingMetrics.classificationError)
print(builder.model.modelDescription)
let metadata = MLModelMetadata(author: "TM", shortDescription: "Bite", license: nil, version: "1.0", additional: nil)
try builder.write(to: URL(fileURLWithPath: "/Users/tiagomartinho/Desktop/chews.mlmodel"), metadata: metadata)
