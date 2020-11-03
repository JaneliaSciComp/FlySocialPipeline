from scipy.io import loadmat, savemat
from tensorflow.keras.models import load_model
import numpy as np 
import os
import sys
import getopt
import csv


def main(argv):

    input_path = None
    output_path = None
    model_path = None

    try:
        options, remainder = getopt.getopt(argv, "hi:o:m:", ["help","input=","output=","model="])
    except getopt.GetoptError:
        print("ERROR!") 
        print("Usage: classify_fly_wings.py -i <input_directory> -o <output_directory> [-m <model_file>]")
        sys.exit(1)

    # Get input arguments
    for opt, arg in options:
        if opt in ('-h', '--help'):
            print("Usage: classify_fly_wings.py -i <input_directory> -o <output_directory> [-m <model_file>]")
            print("OR: classify_fly_wings.py --input <input_dirctory> --output <output_directory> [--model <model_file>]")
            sys.exit(1)
        elif opt in ('-i', '--input'):
            input_path = arg
        elif opt in ('-o', '--output'):
            output_path = arg
        elif opt in ('-m', '--model'):
            model_path = arg
    
    if model_path is None:
        # use the default model
        model_path = '/scripts/classification_final_model.h5'
    elif not os.path.exists(model_path):
        print("WARNING: provided model " + model_path + " not found so the classifier will use the default model")
        model_path = '/scripts/classification_final_model.h5'

    assert os.path.exists(input_path), "Input directory " + input_path + " does not exist!"

    if output_path is None:
        output_path = input_path
    elif not os.path.exists(output_path):
        os.mkdir(output_path)

    # Get .mat files in the input directory
    print("Load .mat files from: ", input_path)
    file_names = [input_path+'/'+f for f in os.listdir(input_path) if f.endswith('.mat')]
    if len(file_names) == 0:
        print("ERROR: .mat files do not exist in directory "+ input_path + "!")
        sys.exit(1) 

    # Load trained model
    # model = load_model('/groups/heberlein/heberleinlab/Simon/DING_models/classification_final_model.h5')
    print("Load model: ", model_path)
    model = load_model(model_path)  # model in singularity container

    # Create a .csv file to store the result
    with open(output_path+'/classification_result.csv', 'w') as csv_file:
        writer = csv.writer(csv_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
        writer.writerow([' File name ', ' Result '])
    
    print("Doing classification...")
    for i in range(len(file_names)):
        # Classification and majority voting
        result = classification_voting(model, file_names[i], output_path)
        if result is None:
            continue
        # Save the result to .csv file
        with open(output_path+'/classification_result.csv', 'a') as csv_file:
            writer = csv.writer(csv_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
            writer.writerow([os.path.basename(file_names[i]), str(result)])        


def classification_voting(model, file_name, output_path, 
                          deepstack_start=0, deepstack_end=-1,
                          img_sz=(38,38), n_frames=6):
    '''
    VGG-3D classification on a data file (including two video series), and do majority voting on the classification results
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
    output_path: output directory for frame based results
    img_sz: image size of each frame
    n_frames: number of continuous frames in a 3D training data (38x38xn_frames)
    Return:
    result: an array of final result of each video series in the file
    '''
    
    assert os.path.exists(file_name), print("File {} does not exist!".format(file_name))

    print("######## Checking data {} ########".format(file_name))
    data = loadmat(file_name, struct_as_record=False, squeeze_me=True)
    deepstacks = data.get('deep') if data.get('deep') is not None else data.get('deepdata')
    if deepstacks is None:
        print("######## Ignoring {} - no deep data field found".format(file_name))
        return
    print("######## Processing data {} ########".format(file_name))
    result = np.zeros(len(deepstacks), dtype='int8')
    frame_predict={}  # used to save results for each frame 
    for j in range(len(deepstacks)):
        if deepstack_end != -1 and j >= deepstack_end:
            break;
        print("Loading data series stack {}...".format(j+1))
        deepdata = deepstacks[j]
        img = []
        if not hasattr(deepdata, 'video_cropSTACK'):
            # skip this entry because the video stack it's missing 
            print("Skip stack {} because it does not have video_cropSTACK field".format(j+1))
            continue
        elif j < deepstack_start:
            # skip stack because it's outside the stack range
            continue
        video = deepdata.video_cropSTACK
        frame = deepdata.frameNUM
        continuous_frame = []
        for k in range(len(frame)-n_frames):
            if frame[k]+n_frames-1 == frame[k+n_frames-1]:
                curr_img = video[:,:,k:k+n_frames]
                img.append(curr_img)
                continuous_frame.append(k+n_frames)
        test_img = np.zeros((len(img), img_sz[0], img_sz[1], n_frames, 1), dtype='float32')
        for i in range(len(img)):
            test_img[i,:,:,:,0] = img[i]
        
        print("VGG classification...")
        prediction = model.predict(test_img, batch_size=16)
        prediction[prediction>=0.5] = 1
        prediction[prediction<0.5] = -1
        frame_predict['deepdata_'+str(j+1)+'_frameID'] = continuous_frame
        frame_predict['deepdata_'+str(j+1)+'_prediction'] = np.transpose(prediction)

        print("Final voting...")
        if np.count_nonzero(prediction==1) > np.count_nonzero(prediction==-1):
            result[j] = 1
        else:
            result[j] = -1

    print("Saving result of each frame to mat file...")
    save_name = output_path + '/' + os.path.splitext(os.path.basename(file_name))[0] + '_result.mat'
    savemat(save_name, frame_predict)
    # print("Result of {} is {}".format(os.path.basename(file_name), result))
    return result


if __name__ == "__main__":
    main(sys.argv[1:])