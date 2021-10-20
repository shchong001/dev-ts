
#include <MiscFuncs.mqh>
#include <Trade.mqh>
#include <CountOrders.mqh>

CTrade Trade;
CCount Count;

double aYtdRange = 0.0074; // 70% quantile day ranges
double targetRange = 0.0057; // 30% quantile day ranges

void OnTick()
{
    double ytdRange = iHigh(Symbol(), PERIOD_D1, 1) - iLow(Symbol(), PERIOD_D1, 1);
    MqlDateTime currTime;
    TimeCurrent(currTime);
    
    // Close all open positions 3 hours before the end of trading day
    if(Count.TotalMarket() > 0 && currTime.hour >= 21) Trade.CloseMultipleOrders(CLOSE_ALL_MARKET);
    
    // Conditions 1 and 2
    if(ytdRange >= aYtdRange && currTime.hour >=4 && currTime.hour <21)
    {
        
        int eHighIndex = iHighest(Symbol(), PERIOD_H1, MODE_HIGH, 4, currTime.hour-3);
        int eLowIndex = iLowest(Symbol(), PERIOD_H1, MODE_LOW, 4, currTime.hour-3);
        
        double eHigh = iHigh(Symbol(), PERIOD_H1, eHighIndex); // 0000-0400's high
        double eLow = iLow(Symbol(), PERIOD_H1, eLowIndex); // 0000-0400's low
        
        double lotSz = 0.01;
        double todayOpen = iOpen(Symbol(), PERIOD_D1, 0);
        double currRange;
        double tpPrice;
        
        // Condition 3
        if(Bid > eHigh && !ChkTodayOrders())
        {
            currRange = iHigh(Symbol(), PERIOD_D1, 0) - iLow(Symbol(), PERIOD_D1, 0);
            tpPrice = Bid + (targetRange - currRange);
            
            Trade.Buy(Symbol(), lotSz, todayOpen, tpPrice);
        }
        else if(Bid < eLow && !ChkTodayOrders())
        {
            currRange = iHigh(Symbol(), PERIOD_D1, 0) - iLow(Symbol(), PERIOD_D1, 0);
            tpPrice = Bid - (targetRange - currRange);
            
            Trade.Sell(Symbol(), lotSz, todayOpen, tpPrice);
        }
        
    }
}