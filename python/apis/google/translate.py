#!/usr/bin/env python
# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4 textwidth=79 autoindent

"""
Python source code
Last modified: 01 Mar 2011 - 12:07
Last author: Laban Mwangi

Simple translator using the google translate API.
Example run:
    $ python translate1.py  -t sw "Hello. Are we meeting today?"
    Hello. Sisi ni mkutano wa leo?
"""
import urllib2
import json
import optparse

# API KEY
API_KEY = "REPLACE ME"
API_URL = "https://www.googleapis.com/language/translate/v2?\
key=%s&q=%s&source=%s&target=%s&prettyprint=false"

#Defaults
DEFAULT_SRC_LANG = "en"
DEFAULT_DEST_LANG = "fr"


class Translate(object):

    """Translate: Uses the google api to translate a string from one language
    to another
    """
    def __init__(self):
        super(Translate, self).__init__()
        self.langs = ["af", "sq", "ar", "be", "bg", "ca", "zh-CN", "zh-TW",
                      "hr", "cs", "da", "nl", "en", "et", "tl", "fi", "fr",
                      "gl", "de", "el", "ht", "iw", "hi", "hu", "is", "id",
                      "ga", "it", "ja", "lv", "lt", "mk", "ms", "mt", "no",
                      "fa", "pl", "pt", "ro", "ru", "sr", "sk", "sl", "es",
                      "sw", "sv", "th", "tr", "uk", "vi", "cy", "yi"]

        self.uri = API_URL

    def translate(self, params):
        """Translates texts
        keywords:
            params - Dictionary
                src_text - String
                src_lang - 2 letter iso code for language
                dest_lang - 2 letter iso code for language
        """
        req_uri = self.uri % (API_KEY, urllib2.quote(params['src_text']),
                         params['src_lang'],
                         params['dest_lang'])

        hdl = urllib2.urlopen(req_uri)
        resp = hdl.read()
        hdl.close()
        j = json.loads(resp)
        try:
            return j['data']['translations'][0]['translatedText']
        except TypeError:
            return ""


def check_lang(option, opt_str, value, parser):
    """ Callback for optparse. Verifies that value is an item in a list"""
    translator = Translate()
    langs = translator.langs
    if value not in langs:
        raise optparse.OptionValueError(
            "Invalid option: %s.\nLanguage not in %s" % (opt_str, langs))

    setattr(parser.values, option.dest, value)


def main():
    """Main function. Called when this file is a shell script"""
    translator = Translate()
    usage = "usage: %prog [options] 'Text to translate'"
    parser = optparse.OptionParser(usage)
    parser.add_option("-f", "--from", action="callback",
                      callback=check_lang, dest="src_lang",
                      default=DEFAULT_SRC_LANG, type="string",
                      help="Translate from this language. Default is %default")

    parser.add_option("-t", "--to", action="callback",
                      default=DEFAULT_DEST_LANG, type="string",
                      callback=check_lang, dest="dest_lang",
                      help="Translate to this language. Default is %default")

    (options, args) = parser.parse_args()

    params = {}
    params['src_lang'] = options.src_lang
    params['dest_lang'] = options.dest_lang
    params['src_text'] = args[0]
    dest_text = translator.translate(params)
    print dest_text

if __name__ == '__main__':
    main()
