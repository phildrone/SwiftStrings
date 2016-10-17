//: Playground - noun: a place where people can play

// Must import Foundation to get extension String.UTF16View : RandomAccessCollection {}
import UIKit

// The classic interview qeustion, can you reverse a string for me in Swift?
// This is probably the single best question to ask for a Swift interview as it
// is a very carefully laid trap designed to catch the unitiated.
//
// Some good and interesting links all about strings:
// https://oleb.net/blog/2016/08/swift-3-strings/
// and a little old, but good
// https://www.mikeash.com/pyblog/friday-qa-2015-11-06-why-is-swifts-string-api-so-hard.html
//
// Lastly, this will likely all change in Swift4 as it targets strings as a major
// goal.

// Back to reversing strings.
//
// First there is a method to do this in one go
var string = "Hello 🌎!"

// Recognize that string.characters gives you access to the characters in
// a struct called CharacterView, and CharacterView implements the
// BidirectionalCollection protocol. The BidirectionalCollection is then a requirement
// for the reverse extension which adds the reversed() method. See:
// https://github.com/apple/swift/blob/master/stdlib/public/core/Reverse.swift
// https://github.com/apple/swift/blob/master/stdlib/public/core/BidirectionalCollection.swift
//
// This returns a revered collection, which we can that init a String from.
string.characters.reversed()
let gnirts = String(string.characters.reversed())

// But lets say, they ask you to reverse the string without using the reversed() method
// of a BidirectionalCollection. The key here is to use the indicies since the size of each
// character can vary. The Character class can be composed of multiple code points, which
// can then combine. The bottom line, you don't have random access to the characters in 
// a CharacterView, but you can walk through them. And similarly you can construct your
// reversed string as either an array of Characters, which you then turn into a String, or
// insert into the CharacterView structure at the startIndex.
//
// Using the index lets you correctly navigate strings constructed multiple ways, for example:
string = "resumé"
string.lengthOfBytes(using: .utf8)
string.lengthOfBytes(using: .utf16)
string = "resum\u{0065}\u{0301}"
string.lengthOfBytes(using: .utf8)
string.lengthOfBytes(using: .utf16)

// because we're using the index it just works
var chars:[Character] = []
var rev:String = ""
for i in string.characters.indices {
    chars.insert(string.characters[i], at: 0)
    rev.insert(string.characters[i], at: rev.startIndex)
}
String(chars)
rev

// That said, we DO get random access to the UTF16 representation if we import Foundation
// because the UTF16 characters are constant width. However be careful, that can lead
// to incorrect behavors. Recall that NSString uses UTF16 internally.
//
// Incorrect behavors like:
var nsString = NSString(string: string)
var revNSString = NSMutableString(capacity: nsString.length+1)
for i in stride(from: nsString.length-1, to: 0, by: -1) {
    revNSString.appendFormat("%c", nsString.character(at: i))
}
revNSString // oops, where's our 'r'!!

// or working with utf16Chars directly in Swift
// https://github.com/apple/swift/blob/master/stdlib/public/core/StringUTF16.swift
//
var char16: [UTF16Char] = []
for i in (0..<string.utf16.count-1).reversed() {
    // UTF16View is subscritable but the index is not an integer.
    char16.insert(string.utf16[string.utf16.index(string.utf16.startIndex, offsetBy: i)], at:0)
}
char16
// But then there's no init method for a String taking an array of UTF16. We'd need to construct
// one and extend String, which I'm not going to do, but it can be done.

// A variation on the reverse a string question above is to take a sentence, and reverse the words.
let sentence = "Hello, 🌎!"
let words = sentence.characters.split(separator: " ").reversed().map{ String($0) }
words


// But this includes some characters that perhaps we don't want to see.
// We could use something similar to
// https://oleb.net/blog/2016/08/swift-3-strings/
let alpha : CharacterSet = .alphanumerics
let alphaWords = sentence.unicodeScalars.split { !alpha.contains($0) }.reversed().map { String($0) }
alphaWords
let whitespace : CharacterSet = .whitespacesAndNewlines
let punc : CharacterSet = .punctuationCharacters
let whitespaceAndPunc = whitespace.union(punc)
let betterWords = sentence.unicodeScalars.split { whitespaceAndPunc.contains($0) }.reversed().map { String($0) }
betterWords








