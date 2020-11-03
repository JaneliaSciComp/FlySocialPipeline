from scipy.io import loadmat
import numpy as np 
import os


def calculate_sample_percentage(file_names):
    '''
    calculate ramdom selection probability of positive and negative samples
    '''
    num_pos = np.zeros(len(file_names), dtype='float32')
    num_neg = np.zeros(len(file_names), dtype='float32')

    for i in range(len(file_names)):
        assert os.path.exists(file_names[i]), \
            print("File {} does not exist!".format(file_names[i]))

        data = loadmat(file_names[i], struct_as_record=False, squeeze_me=True)
        deepdata = data['deepdata']
        for j in range(len(deepdata)):
            frame = deepdata[j].frameNUM
            num_frame = len(frame)
            if deepdata[j].clipID[0] == -1:
                num_neg[i] = num_frame
            else:
                num_pos[i] = num_frame

    pos_prob = num_pos / num_pos.sum()
    neg_prob = num_neg / num_neg.sum()
    return pos_prob, neg_prob


def gen_vgg3d_batch(file_names, train_pct=0.9, img_sz=(38,38), n_frames=8, batch_sz=32, pos_prob=None, neg_prob=None):
    '''
    a generator that yields training batches for 3D vgg network
    Args:
    file_names: list of file names. Each file has a "deepdata"
    "deepdata", structure variable containing 2 cell arrays, one for each fly from a single experiment.
    each cell is a structure including:
    ".video_cropSTACK", 38x38 by m stack of image frames.
    ".frameNUM", the actual frame number from original video recorded at 30 hz.
    ".clipID" , the labels (-1 is not clipped and 0.1, 0.5, and 1 are ranked clips with 1 being the most).
    ".EuclidDist", measure for each frame of how far the fly moved from the previous frame.
    ".filePATH", directory path where the .avi is saved.
    ".filter_config", fields that contain the the various parameter settings
    train_pct: percentage of video data used in training
    img_sz: image size of each frame
    n_frames: number of continuous frames in a 3D training data (38x38xn_frames)
    batch_sz: batch size
    pos_prob: random selection probability of positive samples
    neg_prob: random selection probability of negative samples
    yield training images in 5D as (num_data,:,:,:,channel=1), and training scores in a 1D array
    '''

    for i in range(len(file_names)):
        assert os.path.exists(file_names[i]), \
            print("File {} does not exist!".format(file_names[i]))
    if pos_prob is not None:
        assert len(file_names) == len(pos_prob), \
            print("Probability of positive samples doesn't match sample size")
    if neg_prob is not None:
        assert len(file_names) == len(neg_prob), \
            print("Probability of negative samples doesn't match sample size")
    
    while True:
        batch_img = np.zeros((batch_sz, img_sz[0], img_sz[1], n_frames, 1), dtype='float32')
        batch_label = [1]*int(batch_sz/2) + [0]*int(batch_sz/2) # 1-clipped, 0-nonclipped

        for num in range(int(batch_sz/2)): 
            # Get positive (clipped) sample
            pos_file = np.random.choice(file_names, p=pos_prob)
            data = loadmat(pos_file, struct_as_record=False, squeeze_me=True)
            deepdata = data['deepdata']
            if deepdata[0].clipID[0] != -1:
                video = deepdata[0].video_cropSTACK
                frame = deepdata[0].frameNUM
            else:
                video = deepdata[1].video_cropSTACK
                frame = deepdata[1].frameNUM
            not_include = True  # if include current data stack in the batch
            while not_include:
                frame_idx = np.random.randint(int(len(frame)*train_pct)-n_frames)
                if frame[frame_idx]+n_frames-1 == frame[frame_idx+n_frames-1]:
                    not_include = False
            batch_img[num,:,:,:,0] = video[:,:,frame_idx:frame_idx+n_frames]

            # Get negative (nonclipped) sample
            neg_file = np.random.choice(file_names, p=neg_prob)
            data = loadmat(neg_file, struct_as_record=False, squeeze_me=True)
            deepdata = data['deepdata']
            if deepdata[0].clipID[0] == -1:
                video = deepdata[0].video_cropSTACK
                frame = deepdata[0].frameNUM
            else:
                video = deepdata[1].video_cropSTACK
                frame = deepdata[1].frameNUM
            not_include = True
            while not_include:
                frame_idx = np.random.randint(int(len(frame)*0.8)-n_frames)
                if frame[frame_idx]+n_frames-1 == frame[frame_idx+n_frames-1]:
                    not_include = False
            batch_img[int(batch_sz/2)+num,:,:,:,0] = video[:,:,frame_idx:frame_idx+n_frames]
        
        # Data augmentation
        x_flip = np.random.randint(2, size=batch_sz)
        rot_angle = np.random.randint(4, size=batch_sz)
        for i in range(batch_sz):
            if x_flip[i]:
                batch_img[i,:,:,:,0] = np.flip(batch_img[i,:,:,:,0], axis=0)
            if rot_angle[i]:
                batch_img[i,:,:,:,0] = np.rot90(batch_img[i,:,:,:,0], rot_angle[i], axes=(0,1))
        
        yield batch_img, batch_label


def prepare_validation_data_3d(file_names, test_pct=0.1, img_sz=(38,38), n_frames=6):
    '''
    prepare validation data for 3D vgg network
    Args:
    file_names: list of file names. Each file has a "deepdata"
    "deepdata", structure variable containing 2 cell arrays, one for each fly from a single experiment.
    each cell is a structure including:
    ".video_cropSTACK", 38x38 by m stack of image frames.
    ".frameNUM", the actual frame number from original video recorded at 30 hz.
    ".clipID" , the labels (-1 is not clipped and 0.1, 0.5, and 1 are ranked clips with 1 being the most).
    ".EuclidDist", measure for each frame of how far the fly moved from the previous frame.
    ".filePATH", directory path where the .avi is saved.
    ".filter_config", fields that contain the the various parameter settings
    test_pct: percentage of video data used in testing
    img_sz: image size of each frame
    n_frames: number of continuous frames in a 3D training data (38x38xn_frames)
    '''

    img_pos = []
    img_neg = []

    for i in range(len(file_names)):
        assert os.path.exists(file_names[i]), \
            print("File {} does not exist!".format(file_names[i]))

        data = loadmat(file_names[i], struct_as_record=False, squeeze_me=True)
        deepdata = data['deepdata']
        for j in range(len(deepdata)):
            img = []
            video = deepdata[j].video_cropSTACK
            video = video[:, :, -int(video.shape[2]*test_pct):]
            frame = deepdata[j].frameNUM
            frame = frame[-int(len(frame)*test_pct):]
            for k in range(len(frame)-n_frames):
                if frame[k]+n_frames-1 == frame[k+n_frames-1]:
                    curr_img = video[:,:,k:k+n_frames]
                    img.append(curr_img)
            if deepdata[j].clipID[0] == -1:
                img_neg.extend(img)
            else: 
                img_pos.extend(img)
    
    test_label = [1]*len(img_pos) + [0]*len(img_neg)
    test_img = np.zeros((len(img_pos)+len(img_neg), img_sz[0], img_sz[1], n_frames, 1), dtype='float32')
    for i in range(len(img_pos)):
        test_img[i,:,:,:,0] = img_pos[i]
    for j in range(len(img_neg)):
        test_img[len(img_pos)+j,:,:,:,0] = img_neg[j]
    
    return test_img, test_label