from scipy.io import loadmat
from data import prepare_validation_data_3d
from tensorflow.keras.models import load_model
from tensorflow.keras import backend as K 
import numpy as np 
import gc
import pickle
import matplotlib.pyplot as plt 
import glob


data_path = '/groups/heberlein/heberleinlab/Simon/DeepLearningData_SherrySet/'
file_names = glob.glob(data_path+'*.mat')

n_frames = 6
print("Preparing testing data...")
test_img, test_label = prepare_validation_data_3d(file_names, test_pct=1, n_frames=n_frames)

model_path = '/groups/heberlein/heberleinlab/Simon/DING_models/vgg_3d_v1/'
N_models = 1500
loss_all = np.zeros(N_models)
acc_all = np.zeros(N_models)
for i in range(N_models):
    model = load_model(model_path+'vgg_'+str(i)+'.h5')
    loss, acc = model.evaluate(test_img, test_label, batch_size=16)
    loss_all[i] = loss
    acc_all[i] = acc
    K.clear_session()
    gc.collect()
    f = open(model_path+'out_independent_test.log', 'a+')
    f.write("At epoch {}, loss={}, accuracy={}\n".format(i, loss, acc))
    f.close()

print("Performance on testing data:")
min_loss = min(loss_all)
min_loss_idx = np.argmin(loss_all)
print("At {} epoch, the model achieved lowest loss {}".format(min_loss_idx, min_loss))
max_acc = max(acc_all)
max_acc_idx = np.argmax(acc_all)
print("At {} epoch, the model achieved highest accuracy {}".format(max_acc_idx, max_acc))

history_name = 'history_train_all_lr1e-3_sgd_batch64_steps100_epochs1500_vgg3d_v1_1.pkl'
with open(model_path+history_name, 'rb') as f:
    history = pickle.load(f)

plt.figure()
plt.plot(range(N_models), history['acc'], 'r')
plt.plot(range(N_models), history['loss'], 'b')
plt.plot(range(N_models), acc_all, 'c')
plt.plot(range(N_models), loss_all, 'g')
plt.xlabel('Num epoch')
plt.ylabel('Performance')
plt.legend(['Train_Acc', 'Train_Loss', 'Test_Acc', 'Test_Loss'])
plt.grid(color='k', linestyle=':')
plt.savefig(model_path+'vgg_batch64_steps100_epochs1500.pdf', bbox_inches='tight')
plt.show()