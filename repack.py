from os import path
from PIL import Image
import plistlib
import sys
import os

def run_with_args():
	if (len(sys.argv)) < 2 :
		print "Usage: repack.py <plist-filename>";
		return 0

	filename = sys.argv[1]

	if filename[-6:].lower() == '.plist' :
		combinedir = filename[:-6] + ".combines"
	else :
		combinedir = filename + ".combines"

	repack_atlas(filename, combinedir)


def repack_atlas(plist, combinedir):
	d = plistlib.readPlist(plist)
	atlas_image_filename = plist[:-5] + 'png'

	format = 0
	if d.has_key('metadata') :
		metadata = d['metadata']
		format = 1 # or 2

	frames = d['frames']

	split_nums = lambda s: tuple(int(i.strip('{ }')) for i in s.split(','))

	atlas_size = split_nums(metadata['size'])
	atlas_img = Image.new('RGBA', (atlas_size[0], atlas_size[1]), (0,0,0,0))

	# format 1, 2 TODO: format 0, 3
	for filename, spriteframe in frames.iteritems():

		if format == 1 or format == 2 :
			frame = split_nums(spriteframe['frame'])
			offset = split_nums(spriteframe['offset'])
			rotated = spriteframe.get('rotated', False)
			sourceColorRect = split_nums(spriteframe['sourceColorRect'])
			sourceSize = split_nums(spriteframe['sourceSize'])
			drawRect = sourceColorRect

		elif format == 0 :
			x = float(spriteframe['x'])
			y = float(spriteframe['y'])
			width = float(spriteframe['width'])
			height = float(spriteframe['height'])
			offsetX = float(spriteframe['offsetX'])
			offsetY = float(spriteframe['offsetY'])
			originalWidth = float(spriteframe['originalWidth'])
			originalHeight = float(spriteframe['originalHeight'])

			frame = (x, y, width, height)
			sourceSize = (originalWidth, originalHeight)
			rotated = False
			drawRect = (originalWidth/2 + offsetX - width/2, originalHeight/2 + offsetY - height/2, width, height)

		else :
			print "Error"
			exit

		itemfilename = combinedir + path.sep + filename;
		print itemfilename

		img = Image.open(itemfilename)
		print drawRect[0], drawRect[1], drawRect[2]+drawRect[0], drawRect[3]+drawRect[1]
		clip = img.crop(tuple([drawRect[0], drawRect[1], drawRect[2]+drawRect[0], drawRect[3]+drawRect[1]]))

		#clip = atlas_img.crop(tuple([frame[0], frame[1], frame[2]+frame[0], frame[3]+frame[1]]))
		if rotated :
			clip = clip.transpose(Image.ROTATE_270)
			frame = tuple([frame[0], frame[1], frame[3], frame[2]])

		print frame[0], frame[1], frame[2]+frame[0], frame[3]+frame[1]

		atlas_img.paste(clip, tuple([frame[0], frame[1], frame[2]+frame[0], frame[3]+frame[1]]) )

		#outputfilename = outputdir+path.sep+filename
		#print outputfilename
		#img.save(path.dirname(path.abspath(atlas_image))+path.sep+filename, 'PNG')

	atlas_img.save(atlas_image_filename, 'PNG')


run_with_args()

