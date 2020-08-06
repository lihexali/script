from os import path
from PIL import Image
import plistlib
import sys
import os

def run_with_args():
	if (len(sys.argv)) < 2 :
		print "Usage: atlas_tool.py plist";

	filename = sys.argv[1]

	if filename[-6:].lower() == '.plist' :
		outputdir = filename[:-6] + ".atlas"
	else :
		outputdir = filename + ".atlas"

	if not path.exists(outputdir) :
		os.mkdir(outputdir)
	unpack_atlas(filename, outputdir)


def unpack_atlas(plist, outputdir):
	d = plistlib.readPlist(plist)
	atlas_image = plist[:-5] + 'png'

	format = 0
	if d.has_key('metadata') :
		metadata = d['metadata']
		format = 1 # or 2

	frames = d['frames']

	split_nums = lambda s: tuple(int(i.strip('{ }')) for i in s.split(','))
	# format 1, 2 TODO: format 0, 3
	for filename, spriteframe in frames.iteritems():

		if format == 1 or format == 2 :
			frame = split_nums(spriteframe['frame'])
			offset = split_nums(spriteframe['offset'])

			frame = ( frame[0], frame[1], frame[2], frame[3] )
			rotated = spriteframe.get('rotated', False)
			sourceColorRect = split_nums(spriteframe['sourceColorRect'])
			sourceSize = split_nums(spriteframe['sourceSize'])
			originalSize = (sourceColorRect[0]*2 + sourceColorRect[2] - offset[0]*2, sourceColorRect[1]*2 + sourceColorRect[3] + offset[1]*2 )
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
			originalSize = (originalWidth, originalHeight)
			rotated = False
			drawRect = (originalWidth/2 + offsetX - width/2, originalHeight/2 + offsetY - height/2, width, height)

		else :
			print "Error"
			exit


		atlas_img = Image.open(atlas_image)
		img = Image.new('RGBA', originalSize, (0,0,0,0))

		if rotated :
			clip = atlas_img.crop(tuple([frame[0], frame[1], frame[3]+frame[0], frame[2]+frame[1]]))
			clip = clip.transpose(Image.ROTATE_90)
		else :
			clip = atlas_img.crop(tuple([frame[0], frame[1], frame[2]+frame[0], frame[3]+frame[1]]))			
		
		img.paste(clip, tuple([drawRect[0], drawRect[1], drawRect[2]+drawRect[0], drawRect[3]+drawRect[1]]) )

		outputfilename = outputdir+path.sep+filename
		print outputfilename

		#img.save(path.dirname(path.abspath(atlas_image))+path.sep+filename, 'PNG')
		img.save(outputfilename, 'PNG')


run_with_args()

