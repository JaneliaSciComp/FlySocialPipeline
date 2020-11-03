from scipy.io import loadmat
from tensorflow.keras.models import load_model
from tensorflow.keras import backend as K 
import numpy as np 
import gc
import os


def classification_voting(model, file_name, img_sz=(38,38), n_frames=6):
    '''
    VGG-3D classification on a data file (including two video series), and do voting on the classification results
    Args:
    model: trained vgg model
    file_name: name of a file that includes a "deepdata"
    "deepdata"--structure variable containing 2 cell arrays, one for each fly from a single experiment.
    each cell is a structure including:
    ".video_cropSTACK", 38x38 by m stack of image frames.
    ".frameNUM", the actual frame number from original video recorded at 30 hz.
    ".clipID" , the labels (-1 is not clipped and 0.1, 0.5, and 1 are ranked clips with 1 being the most).
    ".EuclidDist", measure for each frame of how far the fly moved from the previous frame.
    ".filePATH", directory path where the .avi is saved.
    ".filter_config", fields that contain the the various parameter settings
    img_sz: image size of each frame
    n_frames: number of continuous frames in a 3D training data (38x38xn_frames)
    Return:
    result: an array of final result of each video series in the file
    '''
    
    assert os.path.exists(file_name), \
            print("File {} does not exist!".format(file_name))

    print("######## Processing data {} ########".format(os.path.basename(file_name)))
    data = loadmat(file_name, struct_as_record=False, squeeze_me=True)
    deepdata = data['deepdata']
    result = np.zeros(len(deepdata), dtype='int8')
    for j in range(len(deepdata)):
        print("Loading data series {}...".format(j+1))
        img = []
        video = deepdata[j].video_cropSTACK
        frame = deepdata[j].frameNUM
        for k in range(len(frame)-n_frames):
            if frame[k]+n_frames-1 == frame[k+n_frames-1]:
                curr_img = video[:,:,k:k+n_frames]
                img.append(curr_img)
        test_img = np.zeros((len(img), img_sz[0], img_sz[1], n_frames, 1), dtype='float32')
        for i in range(len(img)):
            test_img[i,:,:,:,0] = img[i]
        
        print("VGG classification...")
        prediction = model.predict(test_img, batch_size=16)
        prediction[prediction>=0.5] = 1
        prediction[prediction<0.5] = 0

        print("Final voting...")
        if np.count_nonzero(prediction) > len(prediction)-np.count_nonzero(prediction):
            result[j] = 1
        else:
            result[j] = -1
        
    print("Result of {} is {}".format(os.path.basename(file_name), result))
    return result


def calculate_performance(data_path, results):
    '''
    Calculate the performance
    sensitivity = TP/(TP+FN)
    specificity = TN/(TN+FP)
    accuracy = (TP+TN)/(TP+TN+FP+FN)
    Args:
    data_path: data directory
    results: a directionary containing all results of the data
    '''
    TP = 0
    TN = 0
    FP = 0
    FN = 0
    
    for key, val in results.items():
        data = loadmat(data_path+key, struct_as_record=False, squeeze_me=True)
        deepdata = data['deepdata']
        for j in range(len(deepdata)):
            if deepdata[j].clipID[0] == -1:
                if val[j] == -1:
                    TN += 1
                else:
                    FP += 1
            else:
                if val[j] == 1:
                    TP += 1
                else:
                    FN += 1
    
    sens = TP/(TP+FN)
    spec = TN/(TN+FP)
    acc = (TP+TN)/(TP+TN+FP+FN)

    return sens, spec, acc


def main():

    data_path = '/groups/heberlein/heberleinlab/Simon/DeepLearningData_SherrySet/'
    file_names = [data_path+f for f in os.listdir(data_path) if f.endswith('.mat')]

    model = load_model('/groups/heberlein/heberleinlab/Simon/DING_models/vgg_3d_v1/vgg_1014.h5')  # 980

    result_all = {}
    print("Doing classification...")
    for i in range(len(file_names)):
        result = classification_voting(model, file_names[i])
        result_all[os.path.basename(file_names[i])] = result

    sens, spec, acc = calculate_performance(data_path, result_all)
    print("sensitivity={}, specificity={}, accuracy={}".format(sens,spec,acc))


if __name__ == "__main__":
    main()