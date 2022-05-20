import numpy as np
import argparse
import cv2 
import subprocess
import time
import os
import matplotlib.pyplot as plt
from scipy.spatial import distance as dist




# Get the labels
classes = open('coco.names').read().strip().split('\n')
# print(classes)


try:
    vid = cv2.VideoCapture('video.mp4')
    height, width = None, None
    writer = None
    # plt_writer = None
except:
    raise 'Video cannot be loaded!\n\
            Please check the path provided!'

finally:


    while True:
        grabbed, image = vid.read()

        # Checking if the complete video is read
        if not grabbed:
            break

        if width is None or height is None:
            height, width = image.shape[:2]


        if writer is None:
                # Initialize the video writer
                fourcc = cv2.VideoWriter_fourcc(*"MJPG")
                writer = cv2.VideoWriter('./output2.avi', fourcc, 30, 
                                (image.shape[1], image.shape[0]), True)        


       
        # load the yolov3 model
        net = cv2.dnn.readNetFromDarknet('yolov3.cfg', 'yolov3.weights') 

        # collection of binary data stored as a single entity

        # The cv2.dnn.blobFromImage function returns a blob which is our input image after mean subtraction, 
        # normalizing, and channel swapping.
        # blob = cv2.dnn.blobFromImage(image, scalefactor=1.0, size, mean, swapRB=True)
        net.setInput(cv2.dnn.blobFromImage(image, 1/255.0, size=(416,416), mean=(0,0,0), swapRB=True, crop=False))

        # net.getUnconnectedOutLayers() gives the position of the layers. the output is an ndarray of shape (1,). 
        # So to get the integer we do ln[0]. And to get the index we subtract 1 from the position.
        layer_names = net.getLayerNames()
        output_layers = [layer_names[i - 1] for i in net.getUnconnectedOutLayers()]

        # to know how many times you wanna perform the forward function
        outs = net.forward(output_layers)
        class_ids = []
        confidences = []
        centroids=[]
        boxes = []
        Width = image.shape[1]
        Height = image.shape[0]
        for out in outs:
            for detection in out:
                scores = detection[5:]

                # the index with max score is class_id
                class_id = np.argmax(scores)
                confidence = scores[class_id]
                
                # class id == 0 is person
                if confidence > 0.1 and class_id==0:
                    center_x = int(detection[0] * Width)
                    center_y = int(detection[1] * Height)
                    w = int(detection[2] * Width)
                    h = int(detection[3] * Height)
                    x = center_x - w / 2
                    y = center_y - h / 2
                    class_ids.append(class_id)
                    confidences.append(float(confidence))
                    centroids.append((center_x,center_y))
                    boxes.append([x, y, w, h])

        # IOU happening here. NMS - non-maximum suppression. Box removed if it has IOU more than 0.8 with other box
        indices = cv2.dnn.NMSBoxes(boxes, confidences, 0.1, 0.1)

        objects=[]
        close = set()



        for j in indices:
            (x, y) = (boxes[j][0], boxes[j][1])
            (w, h) = (boxes[j][2], boxes[j][3])
            r = (confidences[j], (x, y, x + w, y + h), centroids[j])
            objects.append(r)
        
        #find the distance between center of each object detected
        n=len(objects)
        if len(objects) >= 2:
            centroids = np.array([r[2] for r in objects])
            d = np.zeros((n,n))
            for i in range(n):
                for j in range(i+1,n):
                    if i!=j:
                        dis = dist.euclidean(centroids[i], centroids[j])
                        if dis<50:
                            close.add(i)
                            close.add(j)


            
        #write the image of objects with red color for people with distance less than 6 feet
        for (i, (conf, bbox, centroid)) in enumerate(objects):
            # i = i[0]
            (startX, startY, endX, endY) = bbox
            border_color=(0,255,0)
            if i in close:
                border_color = (0, 0, 255)
            cv2.rectangle(image, (round(startX),round(startY)), (round(endX),round(endY)), border_color, 2)
                
                
        # disp(image)
        writer.write(image)

    print ("[INFO] Cleaning up...")
    writer.release()
    vid.release()

    