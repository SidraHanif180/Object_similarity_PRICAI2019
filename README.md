# To run the training code, we need MatConvNet: CNNs for MATLAB

**MatConvNet** is a MATLAB toolbox implementing *Convolutional Neural
Networks* (CNNs) for computer vision applications. It is simple,
efficient, and can run and learn state-of-the-art CNNs. Several
example CNNs are included to classify and encode images. Please visit
the [homepage](http://www.vlfeat.org/matconvnet) to know more.

In case of compilation issues, please read first the
[Installation](http://www.vlfeat.org/matconvnet/install/) and
[FAQ](http://www.vlfeat.org/matconvnet/faq/) section before creating an GitHub
issue. For general inquiries regarding network design and training
related questions, please use the
[Discussion forum](https://groups.google.com/d/forum/matconvnet).

# Code for PRICAI 2019

This repository is sharing a training and evaluation code for our papaer "Image Retrieval with Similar Object Detection
and Local Similarity to Detected Objects" publihed in Pacific Rim International Conference on Artificial Intelligence (PRICAI), 2019.
To run the code, first you place the pascal 2007 and Pascal 2012 datasets in the data folder and specify the path for 
root variable in the train.m code.
 
 root  = /path/to/data/
 
 data => contain train and trest images for Pascal 2007 and 2012 datsets
# Pretrained model

Pretrained model for pascal 2007and 2012 and  as well as INSTRE datasets are also provided in files 

pascal 2007 => Model_trained_pascal_voc_2007.mat

pascal 2012 => Model_trained_pascal_voc_2012.mat

INSTRE => Model_trained_pascal_voc_INSTRE.mat

# Evaluation
The evalution on Pascal 2007 and 2012 dataest for the recall of top-10 correct retrieval is given in the table below :


![img](https://github.com/SidraHanif180/Object_similarity_PRICAI2019/blob/master/results.png)

# Results

The qualitative results on Pascal datasets are shown in figure below. The "blue" bounding box is the region of interest in query image wheras the "yellow" bounding box shows the similar regions detected in database images.

![img](https://github.com/SidraHanif180/Object_similarity_PRICAI2019/blob/master/qualitaive_acm.png)
