To run the program for testing and training use the testing and training scripts

FeatureFileCreator takes a folder path to the folder which contains many folders of images. each of the folders should contain only one class of images. 
The code will create for each folder an output cell which containes two elements. the first element is the 544xnumber of image gist feature matrix, the second is the 1xnumber of image classification vector
this is all ones, and as such needs to be scaled in the second part of the program to get the proper end class for training.

The benefit of this method is that the features need only be extracted once for each set so that training can be done more quickly and with different class combinations easily.

place all file which are to be trained together in a folder, point SceneRecognition at that folder and run, this will traing the network using back propagation to recognize those scenes.

