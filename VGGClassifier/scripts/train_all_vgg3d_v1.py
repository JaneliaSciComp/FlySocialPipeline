from models import vgg_3d_v1, DeepNeuralNetwork
from data import gen_vgg3d_batch, calculate_sample_percentage, prepare_validation_data_3d
from tensorflow.keras.optimizers import SGD
import os
import pickle


data_path = '/groups/heberlein/heberleinlab/Simon/DeepLearningData/'
file_names = [data_path+f for f in os.listdir(data_path) if f.endswith('.mat')]

model = vgg_3d_v1()
sgd_opti = SGD(lr=0.001, momentum=0.9, decay=0.00005, nesterov=True)
compile_args = {'optimizer':sgd_opti, 'loss':'binary_crossentropy', 'metrics':['accuracy']}
network = DeepNeuralNetwork(model, compile_args=compile_args)

batch_sz = 64
n_gpus = 1
pos_prob, neg_prob = calculate_sample_percentage(file_names)
n_frames = 6
generator = gen_vgg3d_batch(file_names, train_pct=1, n_frames=n_frames, batch_sz=batch_sz*n_gpus, pos_prob=pos_prob, neg_prob=neg_prob)
# test_img, test_label = prepare_validation_data_3d(file_names, n_frames=n_frames)
save_path = '/groups/heberlein/heberleinlab/Simon/DING_models/vgg_3d_v1/'
history = network.train_network(generator=generator, steps_per_epoch=100, epochs=1500, n_gpus=n_gpus, save_name=save_path+'vgg', validation_data=None)

with open(save_path+'history_train_all_lr1e-3_sgd_batch64_steps100_epochs1500_vgg3d_v1_1.pkl', 'wb') as f:
    pickle.dump(history.history, f)