# Developing a Trading Strategy

A number of factors have to be considered to execute a trade. To simplify the strategy, only 3 factors are examined:

1. Buy or sell?
2. When to execute a trade?
3. At what price to exit a winning trade?

The AUD/USD currency pair is examined. The strategy is for intraday trading: positions are opened and closed on the same day.

## Point 2

A trade is best executed at or close to the day high or day low. This is to fully capture the day movement. Below shows the number of day high and day low occurrences across time intervals:

|  | Number of day high and low occurrences |
| --- | --- |
| Time Interval | 0000-0400 | 0400-0800 | 0800-1200 | 1200-1600 | 1600-2000 | 2000-0000 | Total |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Observed | 643 | 339 | 328 | 273 | 532 | 449 | 2564 |
| Expected | 427.3333 | 427.3333 | 427.3333 | 427.3333 | 427.3333 | 427.3333 | 2563.9998 |

The hypothesis is

H0: Day high and day low occurrences do not differ across time intervals
Ha: Day high and day low occurrences differ across time intervals