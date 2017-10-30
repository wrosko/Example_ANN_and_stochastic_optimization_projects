#!/usr/bin/env python2
import numpy as np
import math
import matplotlib.pyplot as plot
from numba import jit, vectorize
import random
from shapely.geometry import Polygon, Point


def GetUniformRandomPoints(polygon, nPoints):
    min_x, min_y, max_x, max_y = polygon.bounds

    points = []
    x1_points = []
    x2_points = []

    while len(points) < nPoints:
        x_1 = random.uniform(min_x, max_x)
        x_2 = random.uniform(min_y, max_y)
        random_point = Point([x_1, x_2])
        if (random_point.within(polygon)):
            points.append([x_1, x_2])
            x1_points.append(x_1)
            x2_points.append(x_2)

    return x1_points, x2_points, points


def InitializeWeights(layerSizes):
    weights = []
    layerSizesTemp = layerSizes[:]
    lastLayerSize = layerSizesTemp.pop(0)
    for size in layerSizesTemp:
        w = np.random.random((lastLayerSize, size))
        weights.append(2 * w - 1)
        lastLayerSize = size
    return weights


def Distance(firstPoint, secondPoint):
    distance = np.sqrt((firstPoint[0] - secondPoint[0]) ** 2 + (firstPoint[1] - secondPoint[1]) ** 2)
    return distance


def NeighborDistance(firstIndex, secondIndex):
    distance = firstIndex - secondIndex

    return distance


def SigmaT(t, sigma_val, tau_sigma=300):
    sigma = sigma_val * np.exp(-t / tau_sigma)
    return sigma


def EtaT(t, eta_val, tau_sigma=300):
    eta = eta_val * np.exp(-t / tau_sigma)
    return eta


def NeighborhoodFunction(distance, sigma):
    neighborFunc = np.exp(-distance ** 2 / (2 * sigma ** 2))
    return neighborFunc


def UpdateWeights(weights, winningNeuron, randPattern, eta, sigma):
    ##    print "%%%%%%%%%%%%%%%%%%%%%"
    winningWeight = weights[winningNeuron]
    newWeights = weights
    for i in xrange(len(weights)):
        iNeuron = newWeights[i]
        distance = NeighborDistance(i, winningNeuron)
        neighborFunc = NeighborhoodFunction(distance, sigma)
        ##        print neighborFunc
        dW = eta * neighborFunc * (randPattern - iNeuron)

        newWeights[i] = newWeights[i] + dW
    return newWeights


polygon = Polygon([(0, 0), (0.5, 0), (0.5, 0.5), (1, 0.5), (1, 1), (0, 1)])

nPoints = 1000
outputNeurons = 100  # 100
t = 0

tConv = 2 * 10 ** 4
tOrder = 10 ** 3

sigma_0 = 100
eta_0 = 0.1
# tau_sigma = 300
sigma_conv = 0.9
eta_conv = 0.01

x1, x2, points = GetUniformRandomPoints(polygon, nPoints)
weights = InitializeWeights([outputNeurons, 2])[0]
##xx,yy = weights.T
##plot.scatter(x1,x2)
##plot.show()
##
##
##plot.figure()
##plot.scatter(xx,yy)
##plot.show()
##plot.figure()
plot.axis([0, 1, 0, 1])
# plot.ion()

for t in range(tOrder):
    randomInt = np.random.randint(len(points))
    randPattern = points[randomInt]
    minDistance = 100.0
    maxDistance = 0

    for i in xrange(len(weights)):
        iNeuron = weights[i]
        distance = Distance(iNeuron, randPattern)
        if distance >= maxDistance:
            maxDistance = distance
            maxNeuron = i
        if distance <= minDistance:
            minDistance = distance
            winningNeuron = i
    eta = EtaT(t, eta_0)
    sigma = SigmaT(t, sigma_0)
    weights = UpdateWeights(weights, winningNeuron, randPattern, eta, sigma)

x,y = weights.T
plot.plot(x,y)
plot.scatter(x1,x2,color='r',alpha=0.6)
plot.scatter(x,y)
plot.xlabel("x1")
plot.ylabel("x2")
plotTitle = "Post Ordering Kohonen Network with sigma = 5"
plot.title(plotTitle)
plot.show()
##plot.ioff()

print "Now running convergence"

for t in range(tConv):
    randomInt = np.random.randint(len(points))
    randPattern = points[randomInt]
    minDistance = 100.0

    for i in xrange(len(weights)):
        iNeuron = weights[i]
        distance = Distance(iNeuron, randPattern)

        if distance <= minDistance:
            minDistance = distance
            winningNeuron = i

    weights = UpdateWeights(weights, winningNeuron, randPattern, eta_conv, sigma_conv)
#     if t % 1000 == 0:
#         x, y = weights.T
#         plot.plot(x, y)
#         plot.pause(0.01)
#
# plot.ioff()
x, y = weights.T
plot.axis([0, 1, 0, 1])
plot.plot(x, y)
plot.scatter(x,y)
plot.scatter(x1,x2,color='r',alpha=0.6)
plot.xlabel("x1")
plot.ylabel("x2")
plotTitle = "Post Convergence Kohonen Network with sigma = 5"
plot.title(plotTitle)

plot.show()

