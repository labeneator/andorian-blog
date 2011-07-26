#!/usr/bin/env python
# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4 textwidth=79 autoindent

"""
Python source code
Last modified: 26 Jul 2011 - 20:16
Last author: Laban Mwangi

This is a simple test program that aims to decode the output of the steg
encoded images found in a wolfram blog article. The said article can be found
at http://blog.wolfram.com/2010/07/08/doing-spy-stuff-with-mathematica/
"""
import optparse
#import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import numpy as np
import Image
#import png

# If we were to fetch the image..
#import urllib2
#steg_img_url = "http://blog.wolfram.com/data/uploads/2010/07/shortMessage.png"
#u=urllib2.urlopen(steg_img_url)
#img=u.read()
#u.close()
#open("steg-chicken_secret.png","wb").write(img)


class FileDoesnotExistException(Exception):
    """thrown when a file could not be found"""
    def __init__(self):
        super(FileDoesnotExistException, self).__init__()

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
        self.bit2byte = np.array([128, 64, 32, 16, 8, 4, 2, 1])
        self.data_to_encode = None
        self.npimg = None
        self.usable_bits = None
        self.upscaled = None
        self.msg_bytes = None

    def read_image(self, filename):
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
        # Denormalize and lose precision
        self.upscaled = (self.npimg * 255).astype('uint8')

    def write_image(self, filename):
        """
        Write a png from normalized nparray self.npimg.
        Keyword arguements:
            filename    -   File to write.
        """
        # Write image
        try:
            # Normalize
            data = self.upscaled.astype("uint8")
            # Restore original array shape
            data.resize(self.npimg.shape)
            print data[:1]
            print self.npimg[:1] * 255

            #from IPython.Debugger import Tracer
            #debug_here = Tracer()
            #debug_here()

            #PIL
            img = Image.fromarray(data, 'RGB')
            img.save(filename)

#            #pypng
#            column_count = self.npimg.shape[0]
#            row_count = self.npimg.shape[1]
#            plane_count = self.npimg.shape[2]
#            pngWriter = png.Writer(column_count, row_count,
#                                    greyscale=False, alpha=False,
#                                    bitdepth=8)
#            #png.Writer.write(open(filename,"wb"), data.resize(pilshape))
#            # This does not seem to work
#            pypngshape = (column_count, row_count * plane_count)
#            pngfile = open(filename, "wb")
#            pngWriter.write(pngfile,
#                            np.reshape(data,
#                               (-1, column_count * plane_count)))

            #mpimg.imsave(filename, data)
        except IOError:
            raise FileDoesnotExistException("File does not seem to exist. %s" %
                                               filename)

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
        self.usable_bits.resize(self.usable_bits.size / 8, 8)

        # Convert bits into bytes by multiplying the bit vectors with a powers
        # of 2 vector, then making sure our values are unsigned 8bit ints
        msg_array = np.array(
            map(np.sum, self.usable_bits * self.bit2byte)).astype('uint8')
        self.msg_bytes = msg_array.tostring()

    def push_image_bits(self):
        """Gets bytes to encode and pushes them into an image array"""
        bits = []
        # Convert bytes to an array of an array of bits
        for byte in self.data_to_encode:
            bits.append(map(lambda y: (byte >> y) & 1, range(7, -1, -1)))

        # Zero out LSB
        self.upscaled &= 254

        # Flatten arrays
        bit_array = np.array(bits).ravel()
        denorm = self.upscaled.ravel()

        # Generate a zero'd array with the right shape
        bit_array_padded = np.zeros(denorm.shape).astype('uint8')
        # Add data to zero'd array. Rest of zeros are pads
        bit_array_padded[:bit_array.size] = bit_array

        # Push data into image array
        denorm |= bit_array_padded

        self.upscaled = denorm

    def file_save(self, filename):
        """file_save save data bits to a file"""
        # Filed away
        try:
            hdl = open(filename, "wb")
            hdl.write(self.msg_bytes)
            hdl.close()
        except IOError:
            raise FileDoesnotExistException(
                "Could not open file to write %s" % filename)

    def file_read(self, filename):
        """file_read reads a file to encode/hide  """
        try:
            hdl = open(filename, "rb")
            data = hdl.read()
            hdl.close()
            self.data_to_encode = np.fromstring(data, dtype=np.uint8)
        except IOError:
            raise FileDoesnotExistException(
                "Could not open file to read %s" % filename)


def main():
    """Main function. Called when this file is a shell script"""
    usage = """
usage: %prog [options]
Hide/Unhide info in images as described in this post:
http://blog.wolfram.com/2010/07/08/doing-spy-stuff-with-mathematica/
    """
    parser = optparse.OptionParser(usage)

    parser.add_option("-v", "--verbose", dest="debug",
                      default="0", type="int",
                      help="Debug. Higher integers increases verbosity")

    parser.add_option("-i", "--input_file", dest="input_file",
                      type="str", help="Input file with data to encode.")

    parser.add_option("-o", "--output_file", dest="output_file",
                      type="str", help="Output file with decoded data")

    parser.add_option("-e", "--encode_file", dest="encode_file",
                      type="str", help="""
Image file with hidden data in it,
 - Read on encode to provide a template to hide bits.
                      """)

    parser.add_option("-s", "--steg_file", dest="steg_file",
                      type="str",
                      help="""
Image file with hidden data in it,
 - Read on decode operation to extract bits.
 - Written to on decode to hide bits.
                      """)

    parser.add_option("-D", "--decode", dest="decode",
                      action="store_true",
                      help="Operation is to decode a steg input file")

    parser.add_option("-E", "--encode", dest="encode",
                      action="store_true",
                      help="Operation is to encode a steg output file")

    (options, args) = parser.parse_args()
    del args

    steg = Steganography()
    if options.decode:
        if not options.steg_file or not options.output_file:
            raise parser.error("""
--output_file and --steg_file are required for the decode operation.
Please see the --help option.
                               """)
        steg.read_image(options.steg_file)
        steg.extract_image_bits()
        steg.file_save(options.output_file)
    elif options.encode:
        if not options.input_file   \
        or not options.encode_file  \
        or not options.steg_file: \
            raise parser.error("""
--input_file, --encode_file and --steg_file are required for the encode
operation.
Please see the --help option.
                               """)
        steg.file_read(options.input_file)
        steg.read_image(options.encode_file)
        steg.push_image_bits()
        steg.write_image(options.steg_file)
    else:
        raise parser.error(
            "Unknown operation. Must be --encode or --decode. Try --help")


if __name__ == '__main__':
    main()
