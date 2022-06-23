# -*- coding: utf-8 -*-
"""
Created on Sat Jun 18 13:22:27 2022

@author: ASUS
"""

import cv2
import time
import numpy as np
import math



def a(w_list, h_list):
    #stage1
    sum_w = np.sum(w_list)
    sum_h = np.sum(h_list)
    sumwh = np.sum(w_list* h_list)
    sumww = np.sum(w_list* w_list)
    
    #stage2
    sum_w_wh = np.sum(w_list) - np.sum(w_list* h_list)
    sum_h_ww = np.sum(h_list) - np.sum(w_list* w_list)
    
    #stage3
    m = sum_w_wh / sum_h_ww
    
    #state4
    mw = m*sum_w
    
    #stage5
    sum_h_mw = sum_h - mw
    
    #stage6
    b = sum_h_mw/len(h_list)

    return m,b

list_w = []
list_h = []
img = cv2.imread('C:/Users/ASUS/Desktop/111_SoC_Class/solar_panel_image/solar3.jpg')
vis = img.copy()
mask = np.zeros_like(img)
img_gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
ret, img_th = cv2.threshold(img_gray, 60, 255, cv2.THRESH_BINARY)

contours, hierarchy = cv2.findContours(img_th,cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE)  



for c in contours: 
    (x, y, w, h) = cv2.boundingRect(c)
    area=int(cv2.contourArea(c))
    
    if area>100 and area<20000:
        #h1 = 1.640956421133822*w -3.8013883532587727
        #cv2.rectangle(vis, (int(x), int(y)),(int(x)+int(w), int(y)+int(h1)),(0,0,255),2)
        cv2.rectangle(img, (int(x), int(y)),(int(x)+int(w), int(y)+int(h)),(255,0,0),2)
        list_w.append(int(w))
        list_h.append(int(h))
        print(list_w)
        print(list_h)
    
     
array_w=np.array(list_w)
array_h=np.array(list_h)
m,b = a(array_w, array_h)

print('m = ',m,' b = ',b)

for c in contours: 
    (x, y, w, h) = cv2.boundingRect(c)
    area=int(cv2.contourArea(c))
    if area>100 and area<20000:
        h1 = m*w +b
        cv2.rectangle(vis, (int(x), int(y)),(int(x)+int(w), int(y)+int(h1)),(0,0,255),2)


        
#cv2.drawContours(mask,contours,-1,(0,0,255),3)  
#print(img_gray)
#img_gray[img_gray > 80] = img_gray
cv2.imshow('vis',vis) 
cv2.imshow('img',img) 
cv2.imshow('img_th',img_th) 
#cv2.imshow('mask',mask) 

cv2.waitKey()
cv2.destroyAllWindows()