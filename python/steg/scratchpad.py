import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import numpy as np
#import urllib2
#steg_img_url = "http://blog.wolfram.com/data/uploads/2010/07/shortMessage.png"
#u=urllib2.urlopen(steg_img_url)
#img=u.read()
#u.close()
#open("steg-chicken_secret.png","wb").write(img)
# Powers of two vector
m = np.array([128, 64, 32, 16, 8, 4, 2, 1])

# Read image
npimg = mpimg.imread("steg-chicken_secret.png")
# Denormalize and lose precision
upscaled = (npimg*255).astype('uint8')
# Extract data by anding last bit with 1
data_bits = upscaled & 1
# Make sure we only touch bytes. Discard trailing bits
total_bits = np.product(data_bits.shape)
a=data_bits[:1]
ta=a.ravel()[:8*(a.size/8)]
ta.resize(ta.size/8, 8)
#r=ta[0]
#value = sum(r * m)
#msg_bytes = map(sum, ta*m)
# Convert bits into bytes by multiplying the bit vectors with a powers of 2
# vector, then making sure our values are unsigned 8bit ints(shorts?) 
msg_array = np.array(map(np.sum,ta*m)).astype('uint8')
msg_bytes = msg_array.tostring()

# Filed away
hdl = os.open("decoded.msg","wb")
hdl.write(msg_bytes)
hdl.close()
