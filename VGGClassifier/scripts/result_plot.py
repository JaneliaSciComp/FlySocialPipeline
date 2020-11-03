import pickle
import matplotlib.pyplot as plt 
import numpy as np 

history_path = '/groups/heberlein/heberleinlab/Simon/DING_models/vgg_3d_v2/'
file_name = 'history_lr1e-3_sgd_batch64_steps100_epochs2000_vgg3d_v2_1.pkl'


with open(history_path+file_name, 'rb') as f:
    history = pickle.load(f)

min_loss = min(history['val_loss'])
min_loss_idx = np.argmin(history['val_loss'])
print('Minimum val_loss is {} at iteration {}'.format(min_loss, min_loss_idx))
print('Corresponding val_acc is {}'.format(history['val_acc'][min_loss_idx]))

# 3D VGG
num_epoch = len(history['loss'])
label=['Train_Acc', 'Train_Loss', 'Vali_acc', 'Vali_loss']
plt.figure()
plt.plot(range(num_epoch), history['acc'], 'r')
plt.plot(range(num_epoch), history['loss'], 'b')
plt.plot(range(num_epoch), history['val_acc'], 'c')
plt.plot(range(num_epoch), history['val_loss'], 'g')
plt.xlabel('Num epoch')
plt.ylabel('Performance')
plt.legend(label)
plt.grid(color='k', linestyle=':')
plt.savefig(history_path+'performance_lr1e-3_sgd_batch64_steps100_epochs2000_vgg3d_v1_1.pdf')
plt.show()