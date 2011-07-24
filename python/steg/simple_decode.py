#!/usr/bin/env python
# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4 textwidth=79 autoindent

"""
Python source code
Last modified: 24 Jul 2011 - 23:03
Last author: Laban Mwangi

This is a simple test program that aims to decode the output of the steg
encoded images found in a wolfram blog article. The said article can be found
at http://blog.wolfram.com/2010/07/08/doing-spy-stuff-with-mathematica/
"""
import optparse
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import numpy as np

# If we were to fetch the image..
#import urllib2
#steg_img_url = "http://blog.wolfram.com/data/uploads/2010/07/shortMessage.png"
#u=urllib2.urlopen(steg_img_url)
#img=u.read()
#u.close()
#open("steg-chicken_secret.png","wb").write(img)
class FileDoesnotExistException(Exception):
    """thrown when a file could not be found"""
    def __init__(self, value):
        super(FileDoesnotExistException, self).__init__()
        self.parameter = value

    def __str__(self):
        return "%s" % (repr(self.parameter))


class GenericException(Exception):
    """
    Thrown when the fileformat is wrong
    """
    def __init__(self, value):
        super(GenericException, self).__init__()
        self.parameter = value

    def __str__(self):
        return "Error: %s" % (repr(self.parameter))




class Steganography(object):

    """Steganography class for simple png images"""
    def __init__(self):
        super(Steganography, self).__init__()
        # Powers of two vector
        self.m = np.array([128, 64, 32, 16, 8, 4, 2, 1])

    def encoded_read_image(self, filename):
        """
        Reads a png and sets a normalized nparray self.npimg.
        Keyword arguements:
            filename    -   File to read.
        """
        # Read image
        try:
            self.npimg = mpimg.imread(filename)
        except IOError:
            raise FileDoesnotExistException("File does not seem to exist. %s" %
                                               filename)
        except:
            raise GenericException("Could not open file for input %s" %
                                   filename)
        # Denormalize and lose precision
        self.upscaled = (self.npimg * 255).astype('uint8')

    def extract_image_bits(self):
        """
        extract_image_bits fetches the least significant bit in each of pixel.
        This means that a given image carries 3 bits per pixel for RGB files. 
        Total capacity is W * H * 3 bits
        """
        # Extract data by anding last bit with 1
        bits = (self.upscaled & 1).ravel()
        # Make sure we only touch bytes. Discard trailing bits
        usable_bit_count = 8 * (bits.size / 8)
        self.usable_bits = bits.ravel()[:usable_bit_count]
        self.usable_bits.resize(self.usable_bits.size/8, 8)

        # Convert bits into bytes by multiplying the bit vectors with a powers of 2
        # vector, then making sure our values are unsigned 8bit ints(shorts?) 
        msg_array = np.array(map(np.sum,self.usable_bits * self.m)).astype('uint8')
        self.msg_bytes = msg_array.tostring()

    def decoded_save(self, filename):
        """decoded_bits_save save data bits to a file"""
        # Filed away
        hdl = open(filename, "wb")
        hdl.write(self.msg_bytes)
        hdl.close()

def main():
    """Main function. Called when this file is a shell script"""
    usage = """
Hide/Unhide info in images as described in this post:
    http://blog.wolfram.com/2010/07/08/doing-spy-stuff-with-mathematica/

usage: %prog [options]
    """
    parser = optparse.OptionParser(usage)

    parser.add_option("-v", "--verbose", dest="debug",
                      default="0", type="int",
                      help="Debug. Higher integers increases verbosity")

    parser.add_option("-e", "--encoded_file", dest="encoded_file",
                      default="steg_chicken_secret.png", type="str",
                      help="Encoded PNG file to work with. Default is %default")

    parser.add_option("-d", "--data_file", dest="data_file",
                      default="steg.data", type="str",
                      help="File with decoded data or with data to encode.")

    (options, args) = parser.parse_args()
     
    st = Steganography()
    st.encoded_read_image(options.encoded_file)
    st.extract_image_bits()
    st.decoded_save(options.data_file)

if __name__ == '__main__':
    main()
