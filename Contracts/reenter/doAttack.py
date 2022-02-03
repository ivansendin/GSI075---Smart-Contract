#!/usr/bin/python3

from brownie import *
import brownie

def main():
    v = reenterVictim.deploy({'from': accounts[0],'value':50})
    print(v.address)

    a = reenterAttacker.deploy(v.address,{'from':accounts[1],'value':0})

    v.doBet(a.address,{'from':accounts[1]})


    print(v.balance())
    print(a.balance())

    a.startAttack({'from':accounts[1]})

    print(v.balance())
    print(a.balance())
