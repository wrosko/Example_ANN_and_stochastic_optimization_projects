#!/usr/bin/env python2
import numpy as np
from pandas import read_csv
import random
import matplotlib.pyplot as plot


def InitializeWeights(layerSizes):
    weights = []
    layerSizesTemp = layerSizes[:]
    lastLayerSize = layerSizesTemp.pop(0)
    for size in layerSizesTemp:
        w = np.random.random((lastLayerSize, size))
        weights.append(2 * w - 1)
        lastLayerSize = size
    return weights


def CalculateZeta(weight, pattern):
    zeta = 0

    for dim in range(len(pattern)):
        zeta = zeta + weight[dim] * pattern[dim]
    return zeta


def UpdateWeights(weight, pattern, eta):
    zeta = CalculateZeta(weight, pattern)
    dW = eta * zeta * (pattern - zeta * weight)
    weight = weight + dW
    return weight


###Prepare Data

data = read_csv("data_ex2_task2_2017.txt", sep='\t', names=['x1', 'x2']).as_matrix()
dataNormed = (data - data.mean()) / data.std()

eta = 0.001
nUpdates = 2 * 10 ** 4
outputNeurons = len(data)

weights = InitializeWeights([1, 2])[0][0]
weights2 = np.copy(weights)

weightNorm = []
tValues = []
for t in range(1, nUpdates):
    randomInt = np.random.randint(len(data))
    randPattern = data[randomInt]
    patternWeight = weights

    patternWeight = UpdateWeights(patternWeight, randPattern, eta)
    weights = patternWeight
    modWeights = np.linalg.norm(weights)
    weightNorm.append(modWeights)
    if t%1000==0:
        print weights,modWeights
    tValues.append(t)

##plot.plot(tValues, weightNorm)
##plot.xlabel("Time (t)")
##plot.ylabel("Modulus of weight vector")
##plotTitle = "Modulus of the weight vector, un-centered"
##plot.title(plotTitle)
##plot.show()
##
##x,y = data.T
##mx,my = weights.T
##mx = [0, mx]
##my = [0,my]
##plot.plot(mx, my,color = 'r')
##plot.scatter(x,y)
##plot.xlabel("x")
##plot.ylabel("y")
##plotTitle = "Un-centered data with weight vector"
##plot.title(plotTitle)
##plot.show()

weightNorm2 = []
tValues = []
for t in range(1, nUpdates):
    randomInt = np.random.randint(len(dataNormed))
    randPattern = dataNormed[randomInt]
    patternWeight = weights2


    patternWeight = UpdateWeights(patternWeight, randPattern, eta)
    weights2 = patternWeight
    if t % 2000 == 0:
        print  weights2
    modWeights2 = np.linalg.norm(weights2)
    weightNorm2.append(modWeights2)
    tValues.append(t)

##plot.plot(tValues, weightNorm2)
##plot.xlabel("Time (t)")
##plot.ylabel("Modulus of weight vector")
##plotTitle = "Modulus of the weight vector, centered"
##plot.title(plotTitle)
##plot.show()
##
##x,y = dataNormed.T
##mx,my = weights2.T
##mx = [0, mx]
##my = [0,my]
##plot.plot(mx, my,color = 'r')
##plot.scatter(x,y)
##plot.xlabel("x")
##plot.ylabel("y")
##plotTitle = "Centered data with weight vector"
##plot.title(plotTitle)
##plot.show()


regCovariance = 0

for i in xrange(len(data)):
    print i 




