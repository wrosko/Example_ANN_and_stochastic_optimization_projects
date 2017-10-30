#!/usr/bin/env python2
import numpy as np
import math
import matplotlib.pyplot as plot

def initialWeightsHebbsRule(patterns):
    def hebbsRule(pattern):
        return np.dot(pattern,pattern.T)
    dim = len(patterns[0])
    weights = np.zeros((dim,dim))
    for pattern in patterns:
        weights += hebbsRule(pattern)
    return weights / float(dim)
    
def updateHopfield(state,weights):
    return np.sign(np.dot(weights,state))

def genRandomPatterns(n,dim):
    i = 0
    patterns = []
    while i < n:
        pattern = np.random.randint(low=0,high=2,size=dim)*2-1
        if not any(np.array_equal(pattern, p) for p in patterns):
            i += 1
            patterns.append(pattern.reshape((-1,1)))
    return patterns
    
def pError(p,N):
    if p == 1:
        return 0
    elif N == 1:
        return 0;
    else:
        sigma = math.sqrt(float(p-1)/(N-1))
        mean = -float(p-1)/N
        return 1.0/2.0 * (1 - math.erf((1.0 - mean)/(math.sqrt(2)*sigma)))

def stepError(pattern0,pattern1):
    return np.sum(pattern0 != pattern1) / float(len(pattern0))

N = 200
ps = [1, 20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, 240, 260,
      280, 300, 320, 340, 360, 380, 400]
bitThreshold = 10**5

stepErrors = []
pErrors = []
for p in ps:
    bitcount = 0
    stepE = 0
    while(bitcount < bitThreshold):
        patterns = genRandomPatterns(p,N)
        weights = initialWeightsHebbsRule(patterns)
        for pattern in patterns:
            bitcount += N
            stepPattern = updateHopfield(pattern,weights)
            stepE += stepError(pattern,stepPattern)
            if(bitcount >= bitThreshold):
                break
    stepE /= bitcount / N  # devide through number of patterns
    stepErrors.append(stepE)
    pErrors.append(pError(p,N))

#plot.xkcd()
plot.ylabel("ERROR")
plot.xlabel("P")
plot.plot(ps,stepErrors)
plot.plot(ps,pErrors)
plot.show()
    
            