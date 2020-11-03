from tensorflow.keras import layers
from tensorflow.keras import Sequential
from tensorflow.keras.callbacks import Callback, CSVLogger
from tensorflow.keras.utils import multi_gpu_model
import tensorflow as tf 


def vgg_3d_v1(input_shape=(38,38,6,1), n_filters=32, kernel_size=(3,3,3)):
    # No normalization, padding first to 40x40x8, same padding, max pooling
    model = Sequential()

    model.add(layers.ZeroPadding3D(padding=(1,1,1), input_shape=input_shape)) # 40x40x8

    model.add(layers.Conv3D(filters=n_filters, kernel_size=kernel_size, padding='same', activation='relu'))
    model.add(layers.Conv3D(filters=n_filters, kernel_size=kernel_size, padding='same', activation='relu'))
    model.add(layers.MaxPool3D(pool_size=(2,2,2))) # 20x20x4 

    model.add(layers.Conv3D(filters=2*n_filters, kernel_size=kernel_size, padding='same', activation='relu'))
    model.add(layers.Conv3D(filters=2*n_filters, kernel_size=kernel_size, padding='same', activation='relu'))
    model.add(layers.Conv3D(filters=2*n_filters, kernel_size=kernel_size, padding='same', activation='relu'))
    model.add(layers.MaxPool3D(pool_size=(2,2,2))) # 10x10x2

    model.add(layers.Flatten())
    model.add(layers.Dense(units=4*n_filters, activation='relu'))
    model.add(layers.Dropout(0.5))

    model.add(layers.Dense(units=4*n_filters, activation='relu'))
    model.add(layers.Dropout(0.5))

    model.add(layers.Dense(units=1, activation='sigmoid'))
    return model


# def vgg_3d_v2(input_shape=(38,38,8,1), n_filters=32, kernel_size=(3,3,3)):
#     # No normalization, one max pooling, valid padding
#     model = Sequential()

#     model.add(layers.Conv3D(filters=n_filters, kernel_size=kernel_size, activation='relu', input_shape=input_shape)) # 36x36x6
#     model.add(layers.Conv3D(filters=n_filters, kernel_size=kernel_size, activation='relu')) # 34x34x4
#     model.add(layers.Conv3D(filters=n_filters, kernel_size=kernel_size, activation='relu')) # 32x32x2
#     model.add(layers.MaxPool3D(pool_size=(2,2,2))) # 16x16x1

#     model.add(layers.Flatten())
#     model.add(layers.Dense(units=2*n_filters, activation='relu'))
#     model.add(layers.Dropout(0.5))

#     model.add(layers.Dense(units=2*n_filters, activation='relu'))
#     model.add(layers.Dropout(0.5))

#     model.add(layers.Dense(units=1, activation='sigmoid'))
#     return model


class multi_gpu_callback(Callback):
    """
    set callbacks for multi-gpu training
    """
    def __init__(self, model, save_name):
        super().__init__()
        self.model_to_save = model
        self.save_name = save_name
    
    def on_epoch_end(self, epoch, logs=None):
        self.model_to_save.save("{}_{}.h5".format(self.save_name, epoch))


class DeepNeuralNetwork:
    """
    deep nerual network class that wraps keras model (multi-gpu model) and related functions
    """
    def __init__(self, model, compile_args=None):
        with tf.device('/cpu:0'):
            self.network = model
        if compile_args is None:
            compile_args = {'optimizer':'adam', 'loss':'binary_crossentropy', 'metrics':['accuracy']}
        self.network.compile(**compile_args)
        self.compile_args = compile_args
        self.network.summary()

    def save_whole_network(self, file_path_name):
        file_name = file_path_name + '.whole.h5'
        self.network.save(file_name, overwrite=True)
        print('Save the whole network to disk as a .whole.h5 file.')

    def save_architecture(self, file_path_name):
        model_json = self.network.to_json()
        with open(file_path_name+'_arch.json', 'w') as json_file:
            json_file.write(model_json)
        self.network.save_weights(file_path_name+'_weight.h5', overwrite=True)
        print('Saved network architecture to disk with architecture in .json file and weights in .h5 file.')

    def train_network(self, generator, steps_per_epoch=100, epochs=1000, n_gpus=1, save_name=None, validation_data=None):
        # save_name: name of saved log file and model after each epoch (result in {save_name}.log and {save_name}_{epoch}.h5 file) 
        if save_name:
            csv_logger = CSVLogger(save_name+'.log')
            check_point = multi_gpu_callback(self.network, save_name)
            callbacks = [csv_logger, check_point]
        else:
            callbacks = None

        if n_gpus == 1:
            print("Training using a single GPU...")
            history = self.network.fit_generator(generator, steps_per_epoch=steps_per_epoch, epochs=epochs, callbacks=callbacks, validation_data=validation_data)
        else:
            print("Training using multiple GPUs...")
            parallel_model = multi_gpu_model(self.network, gpus=n_gpus, cpu_merge=True, cpu_relocation=False)
            parallel_model.compile(**self.compile_args)
            history = parallel_model.fit_generator(generator, steps_per_epoch=steps_per_epoch, epochs=epochs, callbacks=callbacks, validation_data=validation_data)
        return history