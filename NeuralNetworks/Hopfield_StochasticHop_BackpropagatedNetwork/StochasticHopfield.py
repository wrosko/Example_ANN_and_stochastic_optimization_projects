#!/usr/bin/env python2
import numpy as np
import math
import matplotlib.pyplot as plot
from numba import jit, vectorize
from random import random

def initialWeightsHebbsRule(patterns):
    def hebbsRule(pattern):
        return np.dot(pattern,pattern.T)
    dim = len(patterns[0])
    weights = np.zeros((dim,dim))
    for pattern in patterns:
        weights += hebbsRule(pattern)
    np.fill_diagonal(weights, 0)
    return weights / float(dim)

@jit
def g(b,beta):
    return 1.0/(1+math.e**(-2 * beta * b))
@vectorize
def update(b,beta):
    p = g(b,beta)
    if random() > p:
        return -1.0
    else:
        return 1.0
@jit
def updateHopfieldStochasticJit(state,weights,beta):
    return update(np.dot(weights,state),beta)

def updateHopfieldStochastic(state,weights,beta):
    def g(b):
        return 1.0/(1+math.e**(-2 * beta * b))
    def update(b):
        p = g(b)
        return np.random.choice([-1.0,1.0],p=[1-p,p])
    f = np.vectorize(update)
    return f(np.dot(weights,state))

def genRandomPatterns(n,dim):
    i = 0
    patterns = []
    while i < n:
        pattern = np.random.randint(low=0,high=2,size=dim)*2-1
        if not any(np.array_equal(pattern, j) for j in patterns):
            i += 1
            patterns.append(pattern.reshape((-1,1)))
    return patterns
    
def pError(p,N):
    sigma = math.sqrt(float(p)/float(N))
    mean = -float(p-1)/N
    return  1.0/2.0 * (1 - math.erf((1.0 - mean)/(math.sqrt(2)*sigma)))

def stepError(pattern0,pattern1):
    return np.sum(pattern0 != pattern1) / float(len(pattern0))

def m(state,pattern):
    return float(np.dot(state.T,pattern))/len(pattern)

N = 200
p = 40
beta = 2
iterationSteps = 500
travelingMean = 20
numRuns = 20

for i in xrange(numRuns):
    patterns = genRandomPatterns(p,N)
    weights = initialWeightsHebbsRule(patterns)
    ms = []
    state = patterns[0]
    for t in range(0,iterationSteps):
        state = updateHopfieldStochasticJit(np.float64(state),weights,beta)
        ms.append(m(state,patterns[0]))
    data = []
    for t in range(0,iterationSteps-travelingMean):
        data.append(np.mean(ms[t:t+travelingMean]))
    plot.plot(data)
plot.ylim([-1,1])
plot.ylabel("Order Parameter")
plot.xlabel("Iteration Steps")
plot.show()