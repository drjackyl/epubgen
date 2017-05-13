import Foundation





extension String {
    func substring(with range: NSRange) -> String {
        let startlocation = self.index(self.startIndex, offsetBy: range.location)
        let endLocation = self.index(self.startIndex, offsetBy: range.location+range.length)
        return self.substring(with: startlocation..<endLocation)
    }
}






























