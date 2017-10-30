from __future__ import print_function
import numpy as np
from pandas import read_csv
from random import random
import matplotlib.pyplot as plot

def initializeWeights(layerSizes,weightRange=0.2):
    weights = []
    layerSizesTemp = layerSizes[:]
    lastLayerSize = layerSizesTemp.pop(0)
    for size in layerSizesTemp:
        w = np.random.random((lastLayerSize,size))
        weights.append((w - 0.5) * 2 * weightRange)
        lastLayerSize = size
    return weights

def initializeBiases(layerSizes,biasRange=1):
    biases = []
    layerSizesTemp = layerSizes[:]
    layerSizesTemp.pop(0)
    for size in layerSizesTemp:
        b = np.random.random((size))
        biases.append((b - 0.5) * 2 * biasRange)
    return biases

def feedForward(pattern,weights,biases,activationFunction):
    for i in xrange(len(weights)):
        pattern = pattern.dot(weights[i]) - biases[i]
        pattern = activationFunction(pattern)
    return pattern

def testData(inputs,targets,weights,biases,activationFunction):
    r = 0
    for i in xrange(len(targets)):
        out = feedForward(inputs[i,:],weights,biases,activationFunction)
        error = targets[i] - out
        r = r + np.sum(np.square(error))
    return r/2

def backPropagation(pattern,target,weights,biases,activationFunction,activationFunctionDifferential,learningRate):
    
    activations = [pattern]
    for i in xrange(len(weights)):
        pattern = pattern.dot(weights[i]) - biases[i]
        pattern = activationFunction(pattern)
        activations.append(pattern)
    
    error = target - activations[-1]
    res = error
    for i in reversed(xrange(len(weights))):
        d = activationFunctionDifferential(activations[i+1])
        d = d * error
        
        deltaB = d
        deltaW = np.einsum('i,j->ij',activations[i],d)
        error = d.dot(weights[i].T)
        
        biases[i] -= deltaB * learningRate
        weights[i] += deltaW * learningRate
    
    return (res, weights, biases)

def tanh(beta):
    def f(x):
        return np.tanh(beta * x)
    return f

def tanhDerivation(beta):
    def f(x):
        return beta * (1 - x ** 2)
    return np.vectorize(f)


### prepare data
    
data = read_csv("train_data_2017.txt",sep='\t',names=['x1','x2','y']).as_matrix()
inputs = data[:,:2]
outputs = data[:,2]

data = read_csv("valid_data_2017.txt",sep='\t',names=['x1','x2','y']).as_matrix()
testInputs = data[:,:2]
testOutputs = data[:,2]

mean = np.mean(np.append(inputs,testInputs),axis=0)
std = np.std(np.append(inputs,testInputs),axis=0)
inputs = (inputs - mean)/std
testInputs = (testInputs - mean)/std

### run the networks

architecture1 = [2,1]
architecture2 = [2,4,1]
beta = 0.5
learningRate = 0.02

trainingErrorEnd = [[],[]]
validationErrorEnd = [[],[]]
f, (ax1, ax2) = plot.subplots(1, 2)
for run in xrange(10):
    weights = initializeWeights(architecture1)
    biases = initializeBiases(architecture1)
    energy = []
    energyTraining = []
    for i in xrange(10**6):
        ind = (int) (random() * len(outputs))
        error, weights, biases = backPropagation(
                inputs[ind,:],outputs[ind],
                weights,biases,tanh(beta),tanhDerivation(beta),learningRate)
        
        if i % 5000 == 0:
            r = testData(testInputs,testOutputs,weights,biases,tanh(beta))
            energy.append(float(r))
            r = testData(inputs,outputs,weights,biases,tanh(beta))
            energyTraining.append(float(r))
            print("run {}: {}%, energy={}".format(run,float(i)/10**6*100,r))
            
    r = testData(testInputs,testOutputs,weights,biases,tanh(beta))
    r2 = testData(inputs,outputs,weights,biases,tanh(beta))
    validationErrorEnd[0].append(float(r))
    trainingErrorEnd[0].append(float(r2))


    ax1.plot(np.array(xrange(10 ** 6 / 5000)) * 5000, energy)
    ax2.plot(np.array(xrange(10 ** 6 / 5000)) * 5000, energyTraining)

print("mean architecture 1 = {0}".format(np.mean(validationErrorEnd[0])))
print("std architecture 1 = {0}".format(np.std(validationErrorEnd[0])))
print("min architecture 1 = {0}".format(np.min(validationErrorEnd[0])))


#plot.xlabel('Iteration Number')
#plot.ylabel('Energy')


ax1.set_xlabel('Iteration Number')
ax1.set_ylabel('Energy')
ax1.set_ylim([80,170])

ax2.set_xlabel('Iteration Number')
ax2.set_ylabel('Energy')
ax2.set_ylim([80,170])

ax1.set_title('3a Validation Set')
ax2.set_title('3a Training Set')
plot.show()




f, (ax1, ax2) = plot.subplots(1, 2)
for run in xrange(10):
    weights = initializeWeights(architecture2)
    biases = initializeBiases(architecture2)
    energy = []
    energyTraining = []
    for i in xrange(10 ** 6):
        ind = (int)(random() * len(outputs))
        error, weights, biases = backPropagation(
            inputs[ind, :], outputs[ind],
            weights, biases, tanh(beta), tanhDerivation(beta), learningRate)

        if i % 5000 == 0:
            r = testData(testInputs, testOutputs, weights, biases, tanh(beta))
            energy.append(float(r))
            r = testData(inputs, outputs, weights, biases, tanh(beta))
            energyTraining.append(float(r))
            print("run {}: {}%, energy={}".format(run, float(i) / 10 ** 6 * 100, r))

    r = testData(testInputs, testOutputs, weights, biases, tanh(beta))
    validationErrorEnd[1].append(float(r))
    r = testData(inputs,outputs,weights,biases,tanh(beta))
    trainingErrorEnd[1].append(float(r))

    ax1.plot(np.array(xrange(10**6/5000))*5000,energy)
    ax2.plot(np.array(xrange(10 ** 6 / 5000)) * 5000, energyTraining)

ax1.set_xlabel('Iteration Number')
ax1.set_ylabel('Energy')
#ax1.set_ylim([80,170])

ax2.set_xlabel('Iteration Number')
ax2.set_ylabel('Energy')
#ax2.set_ylim([80,170])

ax1.set_title('3b Validation Set')
ax2.set_title('3b Training Set')
plot.show()

print()
print("3a")
print("mean architecture 1 = {0}".format(np.mean(validationErrorEnd[0])))
print("std architecture 1 = {0}".format(np.std(validationErrorEnd[0])))
print("min architecture 1 = {0}".format(np.min(validationErrorEnd[0])))
print()
print("3b")
print("mean architecture 2 = {0}".format(np.mean(validationErrorEnd[1])))
print("std architecture 2 = {0}".format(np.std(validationErrorEnd[1])))
print("min architecture 2 = {0}".format(np.min(validationErrorEnd[1])))


F = open("ErrorValue.txt","w")
F.write("3a")
F.write("\n mean architecture 1 = {0}".format(np.mean(trainingErrorEnd[0])))
F.write("\n std architecture 1 = {0}".format(np.std(trainingErrorEnd[0])))
F.write("\n min architecture 1 = {0}".format(np.min(trainingErrorEnd[0])))
F.write("\n")

F.write("\n mean architecture 1 = {0}".format(np.mean(validationErrorEnd[0])))
F.write("\n std architecture 1 = {0}".format(np.std(validationErrorEnd[0])))
F.write("\n min architecture 1 = {0}".format(np.min(validationErrorEnd[0])))
F.write("\n")

F.write("3b")
F.write("\n mean architecture 2 = {0}".format(np.mean(trainingErrorEnd[1])))
F.write("\n std architecture 2 = {0}".format(np.std(trainingErrorEnd[1])))
F.write("\n min architecture 2 = {0}".format(np.min(trainingErrorEnd[1])))
F.write("\n")

F.write("\n mean architecture 2 = {0}".format(np.mean(validationErrorEnd[1])))
F.write("\n std architecture 2 = {0}".format(np.std(validationErrorEnd[1])))
F.write("\n min architecture 2 = {0}".format(np.min(validationErrorEnd[1])))
F.close()
