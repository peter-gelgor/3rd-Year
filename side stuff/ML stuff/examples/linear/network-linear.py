import tensorflow as tf
from tensorflow import keras
import pandas as pd
import numpy as np

#load data
train_df = pd.read_csv("examples/linear/data/train.csv")
#all the zeros and one's are together, so the model will not really know how it actually
#works. To fix that, we should randomize the order.

np.random.shuffle(train_df.values)

#make the model
model = keras.Sequential([
    #hidden layer has 4 nodes, the input takes 2 features (x and y)
    keras.layers.Dense(4, input_shape=(2,), activation="relu"),
    #output layer has 2 nodes, 1 or 0
    keras.layers.Dense(2, activation="sigmoid")
])


#compile the model, our optimizer is adam cuz apparently that's the best
model.compile(optimizer="adam", 
                #loss function is binary cross entropy, cuz we're doing binary classification
                #from_logits=True cuz our output is not normalized???
                loss = keras.losses.SparseCategoricalCrossentropy(from_logits=True), 
                metrics=["accuracy"])

#the fit function takes in the input attributes, the output attribute, and batch size
    #because our input has 2 features (x and y), we gotta stack the values
    #this is easily done with np.column_stack().
#key thing - we use 2 sets of brackets, cuz np.column_stack takes a single argument
    #and we want to stack 2 arrays, so we have 2 sets of brackets
attributes = np.column_stack((train_df.x.values, train_df.y.values))

model.fit(attributes, train_df.color.values, batch_size=4, epochs=10)

test_df = pd.read_csv("examples/linear/data/test.csv")
test_x = np.column_stack((test_df.x.values, test_df.y.values))

model.evaluate(test_x, test_df.color.values)