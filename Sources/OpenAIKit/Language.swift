//
//  Language.swift
//  
//
//  Created by Dylan Shine on 3/19/23.
//

import Foundation

// List of languages in ISO-639-1 format.

/// Please note all languages may not be supported by the OpenAI API currently.

public enum Language: String {

    case abkhazian = "ab"

    case afar = "aa"

    case afrikaans = "af"

    case akan = "ak"

    case albanian = "sq"

    case amharic = "am"

    case arabic = "ar"

    case aragonese = "an"

    case armenian = "hy"

    case assamese = "as"

    case avaric = "av"

    case avestan = "ae"

    case aymara = "ay"

    case azerbaijani = "az"

    case bambara = "bm"

    case bashkir = "ba"

    case basque = "eu"

    case belarusian = "be"

    case bengali = "bn"

    case bislama = "bi"

    case bosnian = "bs"

    case breton = "br"

    case bulgarian = "bg"

    case burmese = "my"

    case catalan = "ca"

    case chamorro = "ch"

    case chechen = "ce"

    case chichewa = "ny"

    case chinese = "zh"

    case chuvash = "cv"

    case cornish = "kw"

    case corsican = "co"

    case cree = "cr"

    case croatian = "hr"

    case czech = "cs"

    case danish = "da"

    case dutch = "nl"

    case dzongkha = "dz"

    case english = "en"

    case esperanto = "eo"

    case estonian = "et"

    case ewe = "ee"

    case faroese = "fo"

    case fijian = "fj"

    case finnish = "fi"

    case french = "fr"

    case fulah = "ff"

    case gaelic = "gd"

    case galician = "gl"

    case ganda = "lg"

    case georgian = "ka"

    case german = "de"

    case greek = "el"

    case kalaallisut = "kl"

    case guarani = "gn"

    case gujarati = "gu"

    case haitian = "ht"

    case hausa = "ha"

    case hebrew = "he"

    case herero = "hz"

    case hindi = "hi"

    case hungarian = "hu"

    case icelandic = "is"

    case ido = "io"

    case igbo = "ig"

    case indonesian = "id"

    case interlingue = "ie"

    case inuktitut = "iu"

    case inupiaq = "ik"

    case irish = "ga"

    case italian = "it"

    case japanese = "ja"

    case javanese = "jv"

    case kannada = "kn"

    case kanuri = "kr"

    case kashmiri = "ks"

    case kazakh = "kk"

    case kikuyu = "ki"

    case kinyarwanda = "rw"

    case kirghiz = "ky"

    case komi = "kv"

    case kongo = "kg"

    case korean = "ko"

    case kuanyama = "kj"

    case kurdish = "ku"

    case lao = "lo"

    case latin = "la"

    case latvian = "lv"

    case limburgen = "li"

    case lingala = "ln"

    case lithuanian = "lt"

    case lubaKatanga = "lu"

    case luxembourgish = "lb"

    case macedonian = "mk"

    case malagasy = "mg"

    case malay = "ms"

    case malayalam = "ml"

    case maltese = "mt"

    case manx = "gv"

    case maori = "mi"

    case marathi = "mr"

    case marshallese = "mh"

    case mongolian = "mn"

    case nauru = "na"

    case navajo = "nv"

    case ndonga = "ng"

    case nepali = "ne"

    case norwegian = "no"

    case sichuanYi = "ii"

    case occitan = "oc"

    case ojibwa = "oj"

    case oriya = "or"

    case oromo = "om"

    case ossetian = "os"

    case pali = "pi"

    case pashto = "ps"

    case persian = "fa"

    case polish = "pl"

    case portuguese = "pt"

    case punjabi = "pa"

    case quechua = "qu"

    case romanian = "ro"

    case romansh = "rm"

    case rundi = "rn"

    case russian = "ru"

    case samoan = "sm"

    case sango = "sg"

    case sanskrit = "sa"

    case sardinian = "sc"

    case serbian = "sr"

    case shona = "sn"

    case sindhi = "sd"

    case sinhala = "si"

    case slovak = "sk"

    case slovenian = "sl"

    case somali = "so"

    case spanish = "es"

    case sundanese = "su"

    case swahili = "sw"

    case swati = "ss"

    case swedish = "sv"

    case tagalog = "tl"

    case tahitian = "ty"

    case tajik = "tg"

    case tamil = "ta"

    case tatar = "tt"

    case telugu = "te"

    case thai = "th"

    case tibetan = "bo"

    case tigrinya = "ti"

    case tsonga = "ts"

    case tswana = "tn"

    case turkish = "tr"

    case turkmen = "tk"

    case twi = "tw"

    case uighur = "ug"

    case ukrainian = "uk"

    case urdu = "ur"

    case uzbek = "uz"

    case venda = "ve"

    case vietnamese = "vi"

    case volapük = "vo"

    case walloon = "wa"

    case welsh = "cy"

    case wolof = "wo"

    case xhosa = "xh"

    case yiddish = "yi"

    case yoruba = "yo"

    case zhuang = "za"

    case zulu = "zu"

}



extension Language: Codable {}
