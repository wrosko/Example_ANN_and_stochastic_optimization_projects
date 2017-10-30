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


def InitializeThresholds(layerSizes, thresholdRange=1):
    thresholds = []
    layerSizesTemp = layerSizes[:]
    layerSizesTemp.pop(0)
    for size in layerSizesTemp:
        b = np.random.random((size))
        thresholds.append((b - 0.5) * 2 * thresholdRange)
    return thresholds


def Distance(firstLocation, secondLocation):
    differenceVector = firstLocation - secondLocation
    distance = np.sqrt(differenceVector[0] ** 2 + differenceVector[1] ** 2)
    return distance


def ComputeActivations(pattern, weights):
    nWeights = len(weights)
    maxActivation = 0

    denominatorSum = 0
    activations = []
    for weight in weights:
        distance = Distance(weight, pattern)
        denominatorSum = denominatorSum + np.exp((-distance ** 2) / 2)

    for i in range(nWeights):

        iWeight = weights[i]
        distance = Distance(iWeight, pattern)

        numerator = np.exp((-distance ** 2) / 2)

        activation = numerator / denominatorSum
        activations.append(activation)

        if activation >= maxActivation:
            winningWeight = i
            maxActivation = activation
    return (winningWeight, weights[winningWeight], activations)


def UpdateWeight(winningWeight, pattern, eta):
    dW = eta * (pattern - winningWeight)
    winningWeight = winningWeight + dW
    return winningWeight


def tanh(beta):
    def f(x):
        return np.tanh(beta * x)

    return f


def tanhDerivation(beta):
    def f(x):
        return beta * (1 - x ** 2)

    return np.vectorize(f)


def backPropagation(pattern, target, weights, thresholds, activationFunction, activationFunctionDifferential,
                    learningRate):
    pattern = np.copy([pattern])
    activations = [pattern]

    for i in xrange(len(weights)):
        pattern = pattern.dot(weights[i]) - thresholds[i]
        pattern = activationFunction(pattern)
        activations.append(pattern)

    error = target - activations[-1]
    res = error
    for i in reversed(xrange(len(weights))):
        d = activationFunctionDifferential(activations[i + 1])
        d = d * error

        deltaB = d
        deltaW = d * activations[i].T
        error = d.dot(weights[i].T)

        thresholds[i] = thresholds[i] - deltaB * learningRate
        weights[i] += deltaW * learningRate

    return (res, weights, thresholds)


def PointClassify(pattern, activationFunction, weights, secondWeights, thresholds):
    iNeuron, winningNeuron, activationVals = ComputeActivations(pattern, weights)
    pattern = activationVals
    pattern = np.copy([pattern])

    for i in xrange(len(secondWeights)):
        out = pattern.dot(secondWeights[i]) - thresholds[i]
        out = activationFunction(out)

    return out


def TestDataClassification(inputs, targets, weights, secondWeights, thresholds, activationFunction):
    r = 0
    for i in xrange(len(targets)):
        out = PointClassify(inputs[i], tanh(beta), weights, secondWeights, thresholds)
        error = targets[i] - out
        if np.abs(error)[0] > 1:
            r = r + 1
    return float(r) / len(targets)


data = read_csv("data_ex2_task3_2017.txt", sep='\t', names=['classification', 'x1', 'x2']).as_matrix()
inputs = data[:, 1:]
outputs = data[:, 0]

# gaussianNeurons = 4
eta = 0.02
learningRate = 0.1
beta = 0.5

unsupervisedTime = 10 ** 5
supervisedTime = 3000

min_x = -15
max_x = 25
min_y = -10
max_y = 15

allErrors = []
# kRange = [1,2,3,4,5,6,7,8,9,10]
kRange = [10]
for gaussianNeurons in kRange:

    print "%%%"
    print gaussianNeurons
    errors = []
    bestError = 100
    for run in xrange(20):
        print run

        weights = InitializeWeights([gaussianNeurons, 2])[0]
        initWeights = np.copy(weights)

        allActivations = []

        for t in range(unsupervisedTime):
            randomInt = np.random.randint(len(data))
            randPattern = inputs[randomInt]

            iNeuron, winningNeuron, activations = ComputeActivations(randPattern, weights)
            ##print weights
            weights[iNeuron] = UpdateWeight(winningNeuron, randPattern, eta)
        ##    print weights



        secondWeights = InitializeWeights([gaussianNeurons, 1])
        thresholds = InitializeThresholds([gaussianNeurons, 1])
        initSecWeights = np.copy(secondWeights)

        for i in xrange(supervisedTime):
            randomInt = np.random.randint(len(data))
            randPattern = inputs[randomInt]

            iNeuron, winningNeuron, activationVals = ComputeActivations(randPattern, weights)

            error, secondWeights, thresholds = backPropagation(
                activationVals, outputs[randomInt], secondWeights,
                thresholds, tanh(beta), tanhDerivation(beta), learningRate)
        ##    print error


        nPoints = 0
        ones = []
        minusOnes = []
        while nPoints < 3000:
            x_1 = random.uniform(min_x, max_x)
            x_2 = random.uniform(min_y, max_y)

            category = PointClassify([x_1, x_2], tanh(beta), weights, secondWeights, thresholds)
            category = int(round(category))

            if category == 1:
                ones.append([x_1, x_2])
                nPoints += 1
            if category == -1:
                minusOnes.append([x_1, x_2])
                nPoints += 1
        ones = np.asarray(ones)
        minusOnes = np.asarray(minusOnes)

        runError = TestDataClassification(inputs, outputs, weights, secondWeights, thresholds, tanh(beta))
        errors.append(runError)

        if runError < bestError:
            runError = bestError
            bestOnes = np.copy(ones)
            bestMinusOnes = np.copy(minusOnes)
            bestWeights = weights

    kMean = np.mean(errors)
    kMin = np.min(errors)
    kStd = np.std(errors)
    allErrors.append([gaussianNeurons,kMean])

    print "error mean for k = ", gaussianNeurons, " is ", kMean
    print "error min for k = ", gaussianNeurons, " is ", kMin
    print "error std for k = ", gaussianNeurons, " is ", kStd





    x,y = bestOnes.T
    plot.axis([-15, 25, -10, 15])
    plot.scatter(x,y,color='red',alpha=0.6,label="-1 Boundary")
    xx,yy = bestMinusOnes.T
    plot.scatter(xx,yy,color='blue',alpha=0.6,label="1 Boundary")




    wx,wy = bestWeights.T

    ix,iy = inputs.T
    plot.scatter(ix,iy,color='0.5',s=30,label="Data set points/training points")

    plot.scatter(wx,wy,color='black',marker="s",s=10**2,label="Weights")
    plot.xlabel("x")
    plot.ylabel("y")
    plotTitle = "k = "+str(gaussianNeurons)+" Gaussian Neurons"
    plot.title(plotTitle)
    plot.legend()
    plot.show()






# Mean error for 4
# error mean for k =  4  is  0.149
# error min for k =  4  is  0.1225
# error std for k =  4  is  0.0196551519964


##plot.axis([-15, 25, -10, 15])
##
##print initWeights
##print
##print weights
##
##x,y = weights.T
##xx,yy = inputs.T
##plot.scatter(x,y,color='red')
##plot.scatter(xx,yy,color='blue')
##plot.show()








