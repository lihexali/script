#!/usr/bin/env python
# -*- coding: utf-8 -*-
# 批量自动扣掉背景图为透明

from PIL import Image
import Tkinter as tk
from Tkinter import StringVar
import tkMessageBox
import os


def run_convert():
    edge_only = True #是否只透明边缘空白
    use_trim = True #是否最小化有效图片
    for (root, dirs, files) in os.walk(var_input_dir.get()):
        for filename in files:
            if filename.endswith('.DS_Store'):
                continue
            if_path = os.path.join(root,filename)
            portion=os.path.splitext(filename)
            of_path = os.path.join(var_output_dir.get(), portion[0] + ".png")
            img = Image.open(if_path)
            img = img.convert("RGBA")
            pixdata = img.load()

            min_x = img.size[0]
            min_y = img.size[1]

            max_right = 0
            max_bottom = 0

            for y in range(img.size[1]):
                for x in range(img.size[0]):
                    if pixdata[x, y][0] > 220 and pixdata[x, y][1] > 220 and pixdata[x, y][2] > 220 and pixdata[x, y][3] > 220:
                        pixdata[x, y] = (255, 255, 255, 0)
                    else:
                        min_x = x if x < min_x else min_x
                        min_y = y if y < min_y else min_y
                        if edge_only:
                             break
            for y in range(img.size[1]):
                for x in range(img.size[0] - 1, -1, -1):
                    if pixdata[x, y][0] == 255 and pixdata[x, y][1] == 255 and pixdata[x, y][2] == 255 and pixdata[x, y][3] == 0:
                        pass
                    elif pixdata[x, y][0] > 220 and pixdata[x, y][1] > 220 and pixdata[x, y][2] > 220 and pixdata[x, y][3] > 220:
                        pixdata[x, y] = (255, 255, 255, 0)
                    else:
                        max_right = x if x > max_right else max_right  
                        max_bottom = y if y > max_bottom else max_bottom
                        if edge_only:
                             break
            
            for x in range(img.size[0]):
                for y in range(img.size[1]):
                    if pixdata[x, y][0] == 255 and pixdata[x, y][1] == 255 and pixdata[x, y][2] == 255 and pixdata[x, y][3] == 0:
                        pass
                    elif pixdata[x, y][0] > 220 and pixdata[x, y][1] > 220 and pixdata[x, y][2] > 220 and pixdata[x, y][3] > 220:
                        pixdata[x, y] = (255, 255, 255, 0)
                    else:
                        if edge_only:
                             break
            for x in range(img.size[0]):
                for y in range(img.size[1]-1, -1, -1):
                    if pixdata[x, y][0] == 255 and pixdata[x, y][1] == 255 and pixdata[x, y][2] == 255 and pixdata[x, y][3] == 0:
                        pass
                    elif pixdata[x, y][0] > 220 and pixdata[x, y][1] > 220 and pixdata[x, y][2] > 220 and pixdata[x, y][3] > 220:
                        pixdata[x, y] = (255, 255, 255, 0)
                    else:
                        if edge_only:
                             break

            if use_trim:
                trimed_img = Image.new('RGBA', (max_right - min_x, max_bottom - min_y))
                to_pate_img = img.crop((min_x, min_y, max_right, max_bottom))
                trimed_img.paste(to_pate_img, (0, 0, trimed_img.size[0], trimed_img.size[1]))
                trimed_img.save(of_path)
            else:
                img.save(of_path)
    tkMessageBox.showinfo('提示','转换成功！', parent=window)


window = tk.Tk()
window.title('My Window')
window.geometry('500x300')  # 这里的乘是小x

var_input_dir = StringVar()
var_input_dir.set("./img_old")

var_output_dir = StringVar()
var_output_dir.set("./img_new")

l = tk.Label(window, text=r'输入文件夹路径：')
l.pack()

e1 = tk.Entry(window, show=None, textvariable=var_input_dir)
e1.pack()

l2 = tk.Label(window, text=r'输出文件夹路径：')
l2.pack()

e2 = tk.Entry(window, show=None, textvariable=var_output_dir)
e2.pack()

b2 = tk.Button(window,text="Run",command=run_convert)
b2.pack()

window.mainloop()


