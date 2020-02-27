enum AutocompleteType: String, Codable {
    case none
    case artist
    case title
}

struct Autocomplete {
    var type: AutocompleteType = .artist
    var value: String = ""
}
